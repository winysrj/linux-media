Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o74BRKrk029464
	for <video4linux-list@redhat.com>; Wed, 4 Aug 2010 07:27:20 -0400
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o74BRAdK004478
	for <video4linux-list@redhat.com>; Wed, 4 Aug 2010 07:27:10 -0400
Received: from jim.nabble.com ([192.168.236.80])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <sudhindra.nayak@gmail.com>) id 1Ogc7p-00061r-Q1
	for video4linux-list@redhat.com; Wed, 04 Aug 2010 04:27:09 -0700
Date: Wed, 4 Aug 2010 04:27:09 -0700 (PDT)
From: Sudhindra Nayak <sudhindra.nayak@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <1280921229798-5372108.post@n2.nabble.com>
In-Reply-To: <20100731133201.79939101@tele>
References: <1280489451608-5354598.post@n2.nabble.com>
	<20100731133201.79939101@tele>
Subject: Re: Not able to capture video frames
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Hi Jean,

First of all, thanks for the response. 

I'm using the above mentioned driver and the test application on an
AT91SAM9G45-EKES evaluation kit and not on the PC. Does your solution hold
good for the ARM9 based kit too?

I downloaded the test version of the 'gspca' driver from your home page as
you mentioned in your previous mail. I'm now using the new gspca driver ,
header files and the new ov534 driver. I've changed the arguments in the
'sensor_init' array to correspond to the OV10620 sensor values. 

But when I run the application, I get the following:

gspca: [a.out] open
gspca: frame alloc frsz: 614400
gspca: reqbufs st:0 c:4
gspca: mmap start:4013e000 size:614400
gspca: mmap start:401d4000 size:614400
gspca: mmap start:4026a000 size:614400
gspca: mmap start:40300000 size:614400
gspca: qbuf 0
gspca: qbuf 1
gspca: qbuf 2
gspca: qbuf 3
gspca: no transfer endpoint found
VIDIOC_STREAMON error 5, Input/outgspca: [a.out] close
pgspca: frame free
ut error
gspca: close done


I'm getting an I/O error here. The usb interface seems to be working fine
since I tested it with a pen drive. Can you please help me out. I'm
including the 'strace' ouput below for your reference:


execve("./a.out", ["./a.out"], [/* 13 vars */]) = 0
brk(0)                                  = 0x13000
uname({sys="Linux", node="at91sam9g45ekes", ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x4001c000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or
directory)
open("/var/run/ld.so.cache", O_RDONLY)  = -1 ENOENT (No such file or
directory)
open("/lib/tls/v5l/fast-mult/half/libc.so.6", O_RDONLY) = -1 ENOENT (No such
file or directory)
stat64("/lib/tls/v5l/fast-mult/half", 0xbee35220) = -1 ENOENT (No such file
or directory)
open("/lib/tls/v5l/fast-mult/libc.so.6", O_RDONLY) = -1 ENOENT (No such file
or directory)
stat64("/lib/tls/v5l/fast-mult", 0xbee35220) = -1 ENOENT (No such file or
directory)
open("/lib/tls/v5l/half/libc.so.6", gspca: [a.out] open
O_RDONLY) = -1 ENOENT (No such file or directory)
sgspca: frame alloc frsz: 614400
tat64("/lib/tls/v5l/gspca: reqbufs st:0 c:4
half", 0xbee35220) = -1 ENOENT (No such file or directory)
gspca: mmap start:4013e000 size:614400
open("/lib/tls/v5l/libc.so.6", O_RDONLY) = -1 ENOENT (gspca: mmap
start:401d4000 size:614400
No such file or directory)
stat64("/lib/tls/v5l", 0xbee35220)      = -1 ENOENT (No such file or
directory)
open("/lib/tls/fast-mult/half/libc.so.6", O_RDONLY) = -1 ENOENT (No such
file or directory)
stat64("/lib/tls/fast-mult/half", 0xbee35220) = -1 ENOENT (No such file or
directory)
open("/lib/tls/fast-mult/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or
directory)
stat64("/lib/tls/fast-mult", 0xbee35220) = -1 ENOENT (No such file or
directory)
open("/lib/tls/half/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or
directory)
stat64("/lib/tls/half", 0xbee35220)     = -1 ENOENT (No such file or
directory)
open("/lib/tls/libc.so.6", O_RDONLY)    = -1 ENOENT (No such file or
directory)
stat64("/lib/tls", 0xbee35220)          = -1 ENOENT (No such file or
directory)
open("/lib/v5l/fast-mult/half/libc.so.6", O_RDONLY) = -1 ENOENT (No such
file or directory)
stat64("/lib/v5l/fast-mult/half", 0xbee35220) = -1 ENOENT (No such file or
directory)
open("/lib/v5l/fast-mult/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or
directory)
stat64("/lib/v5l/fast-mult", 0xbee35220) = -1 ENOENT (No such file or
directory)
open("/lib/v5l/half/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or
directory)
stat64("/lib/v5l/half", 0xbee35220)     = -1 ENOENT (No such file or
directory)
open("/lib/v5l/libc.so.6", O_RDONLY)    = -1 ENOENT (No such file or
directory)
stat64("/lib/v5l", 0xbee35220)          = -1 ENOENT (No such file or
directory)
open("/lib/fast-mult/half/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or
directory)
stat64("/lib/fast-mult/half", 0xbee35220) = -1 ENOENT (No such file or
directory)
open("/lib/fast-mult/libc.so.6", O_RDONLY) = -1 ENOENT (No such file or
directory)
stat64("/lib/fast-mult", 0xbee35220)    = -1 ENOENT (No such file or
directory)
open("/lib/half/libc.so.6", O_RDONLY)   = -1 ENOENT (No such file or
directory)
stat64("/lib/half", 0xbee35220)         = -1 ENOENT (No such file or
directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\220K\1\000"..., 512)
= 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1111536, ...}) = 0
mmap2(NULL, 1147328, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
0x40025000
mprotect(0x40130000, 32768, PROT_NONE)  = 0
mmap2(0x40138000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10b) = 0x40138000
mmap2(0x4013b000, 8640, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x4013b000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x4001d000
syscall_983045(0x4001d090, 0x4001d090, 0x68c, 0x4001d768, 0x40024060,
0x40024000, 0, 0xf0005, 0x60, 0xffff565c, 0, 0xbee35aec, 0, 0xbee357e8,
0x40010e24, 0x40001fc4, 0x20000010, 0x4001d090, 0xb575, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0) = 0
mprotect(0x40138000, 8192, PROT_READ)   = 0
mprotect(0x40023000, 4096, PROT_READ)   = 0
fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(4, 64), ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 opost isig icanon echo
...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x4001e000
write(1, "Opening Device\n", 15Opening Device
)        = 15
stat64("/dev/video", {st_mode=S_IFCHR|0660, st_rdev=makedev(81, 0), ...}) =
0
open("/dev/video", O_RDWR|O_NONBLOCK)   = 3
write(1, "Initializing Device\n", 20Initializing Device
)   = 20
ioctl(3, VIDIOC_QUERYCAP or VT_OPENQRY, 0xbee35bec) = 0
ioctl(3, VIDIOC_CROPCAP, 0xbee35bc0)    = -1 EINVAL (Invalid argument)
ioctl(3, VIDIOC_S_FMT or VT_RELDISP, 0xbee35ae0) = 0
ioctl(3, VIDIOC_REQBUFS or VT_DISALLOCATE, 0xbee35aac) = 0
brk(0)                                  = 0x13000
brk(0x34000)                            = 0x34000
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbee35a68) = 0
mmap2(NULL, 614400, PROT_READ|PROT_WRITgspca: mmap start:4026a000
size:614400
E, MAP_SHARED, 3, 0) = 0x4013e000
ioctl(3, VIDIOC_QUERgspca: mmap start:40300000 size:614400
YBUF or VT_RESIZE, 0xbee35a68) = 0
mmap2(NULL, 614400, Pgspca: qbuf 0
ROT_READ|Pgspca: qbuf 1
ROT_WRITE,gspca: qbuf 2
 MAP_SHARED, 3, 0x96) = 0x40gspca: qbuf 3
1d4000
iogspca: no transfer endpoint found
ctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbee35a68) = 0
mmapgspca: [a.out] close
2gspca: frame free
(NULL, 614400,gspca: close done
 PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0x12c) = 0x4026a000
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbee35a68) = 0
mmap2(NULL, 614400, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0x1c2) = 0x40300000
write(1, "Capturing Frames\n", 17Capturing Frames
)      = 17
ioctl(3, VIDIOC_QBUF, 0xbee35c0c)       = 0
ioctl(3, VIDIOC_QBUF, 0xbee35c0c)       = 0
ioctl(3, VIDIOC_QBUF, 0xbee35c0c)       = 0
ioctl(3, VIDIOC_QBUF, 0xbee35c0c)       = 0
ioctl(3, VIDIOC_STREAMON, 0xbee35c50)   = -1 EIO (Input/output error)
write(2, "VIDIOC_STREAMON error 5, Input/o"..., 44VIDIOC_STREAMON error 5,
Input/output error
) = 44
io_submit(0x1, 0x1, 0xfbad2088 <unfinished ... exit status 1>
Process 1053 detached 

-----
Regards,

Sudhindra Nayak
-- 
View this message in context: http://video4linux-list.1448896.n2.nabble.com/Not-able-to-capture-video-frames-tp5354598p5372108.html
Sent from the video4linux-list mailing list archive at Nabble.com.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
