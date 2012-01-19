Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:50506 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2ASNNz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 08:13:55 -0500
Message-ID: <4F181711.1020201@mlbassoc.com>
Date: Thu, 19 Jan 2012 06:13:53 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Adding YUV input support for OMAP3ISP driver
References: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com> <201201171633.50619.laurent.pinchart@ideasonboard.com> <4F180F95.7050003@mlbassoc.com> <201201191350.51761.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201191350.51761.laurent.pinchart@ideasonboard.com>
Content-Type: multipart/mixed;
 boundary="------------050008020203030108080406"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050008020203030108080406
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 2012-01-19 05:50, Laurent Pinchart wrote:
> Hi Gary,
>
> On Thursday 19 January 2012 13:41:57 Gary Thomas wrote:
>> On 2012-01-17 08:33, Laurent Pinchart wrote:
>>      <snip>
>>
>>> I already had a couple of YUV support patches in my OMAP3 ISP tree at
>>> git.kernel.org. I've rebased them on top of the lastest V4L/DVB tree and
>>> pushed them to
>>> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
>>> omap3isp-yuv. Could you please try them, and see if they're usable with
>>> your sensor ?
>>
>> I just tried this kernel with my board.  The media control infrastructure
>> comes up and all of the devices are created, but I can't access them.
>>
>>   From the bootup log:
>>     Linux media interface: v0.10
>>     Linux video capture interface: v2.00
>
> Any message from the omap3isp driver and from the sensor driver ?

No, it doesn't appear that the sensor was probed (or maybe it failed but
no messages).  I'll check into this.

Has the way of adding the sensors on the i2c bus changed?  I have my
TVP5150 on a i2c-2 all by itself and with the 3.0+ kernel, it was being
added when I initialized the camera subsystem.

Do you have an example driver (like the BeagleBoard one that was in
your omap3isp-sensors-next branch previously)?

>
>> When I try to access the devices:
>>     root@cobra3530p73:~# media-ctl -p
>>     Opening media device /dev/media0
>>     media_open_debug: Can't open media device /dev/media0
>>     Failed to open /dev/media0
>
> Could you please strace that ?

Attached.  Looks like it blows up immediately.

Note: my media-ctl program was built from SRCREV 7266b1b5433b5644a06f05edf61c36864ab11683

>
>> The devices look OK to me:
>>     root@cobra3530p73:~# ls -l /dev/v*  /dev/med*
>>     crw------- 1 root root 252, 0 Nov  8 10:44 /dev/media0
>>     crw-rw---- 1 root video 81,   7 Nov  8 10:44 /dev/v4l-subdev0
>>     crw-rw---- 1 root video 81,   8 Nov  8 10:44 /dev/v4l-subdev1
>>     crw-rw---- 1 root video 81,   9 Nov  8 10:44 /dev/v4l-subdev2
>>     crw-rw---- 1 root video 81,  10 Nov  8 10:44 /dev/v4l-subdev3
>>     crw-rw---- 1 root video 81,  11 Nov  8 10:44 /dev/v4l-subdev4
>>     crw-rw---- 1 root video 81,  12 Nov  8 10:44 /dev/v4l-subdev5
>>     crw-rw---- 1 root video 81,  13 Nov  8 10:44 /dev/v4l-subdev6
>>     crw-rw---- 1 root video 81,  14 Nov  8 10:44 /dev/v4l-subdev7
>>     crw-rw---- 1 root video 81,  15 Nov  8 10:44 /dev/v4l-subdev8
>>     crw-rw---- 1 root tty    7,   0 Nov  8 10:44 /dev/vcs
>>     crw-rw---- 1 root tty    7,   1 Nov  8 10:44 /dev/vcs1
>>     crw-rw---- 1 root tty    7, 128 Nov  8 10:44 /dev/vcsa
>>     crw-rw---- 1 root tty    7, 129 Nov  8 10:44 /dev/vcsa1
>>     crw-rw---- 1 root video 81,   0 Nov  8 10:44 /dev/video0
>>     crw-rw---- 1 root video 81,   1 Nov  8 10:44 /dev/video1
>>     crw-rw---- 1 root video 81,   2 Nov  8 10:44 /dev/video2
>>     crw-rw---- 1 root video 81,   3 Nov  8 10:44 /dev/video3
>>     crw-rw---- 1 root video 81,   4 Nov  8 10:44 /dev/video4
>>     crw-rw---- 1 root video 81,   5 Nov  8 10:44 /dev/video5
>>     crw-rw---- 1 root video 81,   6 Nov  8 10:44 /dev/video6
>
> Have the device nodes have been created manually ?
>

No, automatically created by udev.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------

--------------050008020203030108080406
Content-Type: text/plain;
 name="media-ctl.strace"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="media-ctl.strace"

execve("/usr/bin/media-ctl", ["media-ctl", "-p"], [/* 10 vars */]) = 0
brk(0)                                  = 0x13000
uname({sys="Linux", node="cobra3530p73", ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40007000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=8733, ...}) = 0
mmap2(NULL, 8733, PROT_READ, MAP_PRIVATE, 3, 0) = 0x400e7000
close(3)                                = 0
open("/usr/lib/libmediactl.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\340\t\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=8776, ...}) = 0
mmap2(NULL, 40300, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x40182000
mprotect(0x40184000, 28672, PROT_NONE)  = 0
mmap2(0x4018b000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0x4018b000
close(3)                                = 0
open("/usr/lib/libv4l2subdev.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\350\10\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=8220, ...}) = 0
mmap2(NULL, 39692, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x400dd000
mprotect(0x400df000, 28672, PROT_NONE)  = 0
mmap2(0x400e6000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0x400e6000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0hy\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1175744, ...}) = 0
mmap2(NULL, 1217808, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x4018c000
mprotect(0x402a9000, 28672, PROT_NONE)  = 0
mmap2(0x402b0000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x11c) = 0x402b0000
mmap2(0x402b3000, 9488, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x402b3000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x400ea000
set_tls(0x400ea800, 0x400eaed8, 0x400ea800, 0x40042050, 0x40042050) = 0
mprotect(0x402b0000, 8192, PROT_READ)   = 0
mprotect(0x40041000, 4096, PROT_READ)   = 0
munmap(0x400e7000, 8733)                = 0
brk(0)                                  = 0x13000
brk(0x34000)                            = 0x34000
fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(253, 0), ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 opost isig icanon echo ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40045000
write(1, "Opening media device /dev/media0"..., 33) = 33
open("/dev/media0", O_RDWR)             = -1 ENXIO (No such device or address)
write(1, "media_open_debug: Can't open med"..., 54) = 54
write(1, "Failed to open /dev/media0\n", 27) = 27
exit_group(1)                           = ?

--------------050008020203030108080406--
