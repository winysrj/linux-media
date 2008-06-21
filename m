Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5LIXZmo023894
	for <video4linux-list@redhat.com>; Sat, 21 Jun 2008 14:33:35 -0400
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5LIXNgF005039
	for <video4linux-list@redhat.com>; Sat, 21 Jun 2008 14:33:23 -0400
Received: from smtp2-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp2-g19.free.fr (Postfix) with ESMTP id B018912B6D4
	for <video4linux-list@redhat.com>;
	Sat, 21 Jun 2008 20:33:22 +0200 (CEST)
Received: from [192.168.0.3] (cac94-1-81-57-151-96.fbx.proxad.net
	[81.57.151.96])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 6E14D12B6BC
	for <video4linux-list@redhat.com>;
	Sat, 21 Jun 2008 20:33:22 +0200 (CEST)
Message-ID: <485D4972.2070801@free.fr>
Date: Sat, 21 Jun 2008 20:33:22 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Video 4 Linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: application hanging with 2.6.25 and bttv
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I have got a tv application that doesn't work anymore with 2.6.25 : it 
hangs.

Strace :

open("/dev/video0", O_RDWR)             = 3
ioctl(3, EXT2_IOC_GETVERSION or VIDIOCGCAP, 0x8674e80) = 0
ioctl(3, EXT2_IOC_SETVERSION or SONYPI_IOCGBAT1CAP or VIDIOCGCHAN, 
0x8674ec0) = 0
ioctl(3, EXT2_IOC_SETVERSION or SONYPI_IOCGBAT1CAP or VIDIOCGCHAN, 
0x8674ec0) = 0
ioctl(3, EXT2_IOC_SETVERSION or SONYPI_IOCGBAT1CAP or VIDIOCGCHAN, 
0x8674ec0) = 0
ioctl(3, SONYPI_IOCGBAT1REM or VIDIOCSCHAN, 0x8674ec0) = 0
ioctl(3, EXT2_IOC_SETVERSION or SONYPI_IOCGBAT1CAP or VIDIOCGCHAN, 
0x8674ec0) = 0
ioctl(3, SONYPI_IOCGBAT2CAP or VIDIOCGTUNER, 0x8672fc0) = 0
ioctl(3, SONYPI_IOCGBAT2REM or VIDIOCSTUNER, 0x8672fc0) = 0
ioctl(3, SONYPI_IOCGBAT1REM or VIDIOCSCHAN, 0x8674ec0) = 0
ioctl(3, VIDIOCGPICT, 0x8672f9e)        = 0
ioctl(3, SONYPI_IOCGBATFLAGS or VIDIOCSPICT, 0x8672f9e) = 0
ioctl(3, VIDIOCSWIN, 0x8674be0)         = 0
ioctl(3, VIDIOCGMBUF
<----- here hang


echo w > /proc/sysrq-trigger

[ 3838.478636] SysRq : Show Blocked State
[ 3838.478636]   task                PC stack   pid father
[ 3838.478636] mytv         D 00000095     0  9377   9375
[ 3838.478636]        f7edb930 00200082 f8c92216 00000095 f7edbab0 
c180b920 00000000 000d0f6e
[ 3838.478636]        f679fdd4 c180b920 000000ff 00000000 00000000 
00000000 f7e03010 f7e03018
[ 3838.478636]        f7e03014 f7edb930 c02b47e9 f7e03018 f7e03018 
f7edb930 f7e03010 00208000
[ 3838.478636] Call Trace:
[ 3838.478636]  [<f8c92216>] i2c_transfer+0x66/0x6d [i2c_core]
[ 3838.478636]  [<c02b47e9>] __mutex_lock_slowpath+0x50/0x7b
[ 3838.478636]  [<c02b467f>] mutex_lock+0xa/0xb
[ 3838.478636]  [<f8cece8d>] videobuf_mmap_setup+0xe/0x2d [videobuf_core]
[ 3838.478636]  [<f8d97d6b>] vidiocgmbuf+0x24/0x83 [bttv]
[ 3838.478636]  [<f8d97d47>] vidiocgmbuf+0x0/0x83 [bttv]
[ 3838.478636]  [<f8d317fd>] __video_do_ioctl+0x93/0x2cca [videodev]
[ 3838.478636]  [<c011a94d>] __wake_up_common+0x2e/0x58
[ 3838.478636]  [<c011cbe2>] __wake_up_sync+0x2a/0x3e
[ 3838.478636]  [<c011b203>] __dequeue_entity+0x1f/0x71
[ 3838.478636]  [<c0106970>] __switch_to+0xa3/0x12f
[ 3838.478636]  [<f8d3469d>] video_ioctl2+0x16d/0x233 [videodev]
[ 3838.478636]  [<c012e847>] ptrace_notify+0x7d/0xa4
[ 3838.478636]  [<c017f70b>] vfs_ioctl+0x47/0x5d
[ 3838.478636]  [<c017f966>] do_vfs_ioctl+0x245/0x258
[ 3838.478636]  [<c017f9ba>] sys_ioctl+0x41/0x5b
[ 3838.478636]  [<c0107862>] syscall_call+0x7/0xb
[ 3838.478636]  =======================

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
