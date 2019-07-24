import hashlib
import sys
Serial = str(sys.argv[1])
hash_id = hashlib.sha256(Serial).hexdigest()[0:6]+"00"
print(hash_id)