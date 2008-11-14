Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAEGTwA9029501
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 11:29:58 -0500
Received: from tomts33-srv.bellnexxia.net (tomts33.bellnexxia.net
	[209.226.175.107])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAEGTi6O011596
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 11:29:45 -0500
Received: from toip41-bus.srvr.bell.ca ([67.69.240.42])
	by tomts33-srv.bellnexxia.net
	(InterMail vM.5.01.06.13 201-253-122-130-113-20050324) with ESMTP id
	<20081114162944.VBRA1087.tomts33-srv.bellnexxia.net@toip41-bus.srvr.bell.ca>
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 11:29:44 -0500
From: Jonathan Lafontaine <jlafontaine@ctecworld.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 14 Nov 2008 11:29:26 -0500
Message-ID: <09CD2F1A09A6ED498A24D850EB101208165C79D398@Colmatec004.COLMATEC.INT>
Content-Language: fr-CA
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: EM28xx problem
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

Hi, I just bought a new frame grabber
>
>> PInnacle dvc 100
>>
>> supported in the list of em28
>>
>> Problen with driver, my device is not detecting NTSC standard compatibility, I really need this standard to record my fames and do treament on
>>
>>
>> look
>>
>> lafontaine@colmatec231:~/v4l-dvb/v4l2-apps/test$ ./driver-test
>> driver=em28xx, card=Pinnacle Dazzle DVC 100, bus=5-7, version=0.0.1, capabilities=CAPTURE AUDIO READWRITE STREAMING
>> STANDARD: index=0, id=0x00000007, name=PAL-BG, fps=25.000, framelines=625
>> STANDARD: index=1, id=0x00400000, name=SECAM L, fps=25.000, framelines=625
>> STANDARD: index=2, id=0x00800000, name=SECAM LC, fps=25.000, framelines=625
>> STANDARD: index=3, id=0x00200000, name=SECAM K1, fps=25.000, framelines=625
>> INPUT: index=0, name=Composite1, type=2, audioset=0, tuner=0, std=00e00007, status=0
>> INPUT: index=1, name=S-Video, type=2, audioset=0, tuner=0, std=00e00007, status=0
>> FORMAT: index=0, type=1, flags=0, description='Y0-U-Y1-V, 16 bpp'
>>        fourcc=YUYV
>> FORMAT: index=1, type=1, flags=0, description='Y1-U-Y0-V, 16 bpp'
>>        fourcc=YUY1
>> FORMAT: index=2, type=1, flags=0, description='YUV411, 12 bpp'
>>        fourcc=Y41P
>> FORMAT: index=3, type=1, flags=0, description='YUV211, 8 bpp'
>>        fourcc=Y211
>> FORMAT: index=4, type=1, flags=0, description='RGB, 16 bpp, 6-5-6'
>>        fourcc=RGBP
>> FORMAT: index=5, type=1, flags=0, description='RGB, 8bit RGRG'
>>        fourcc=
>> FORMAT: index=6, type=1, flags=0, description='RGB, 8bit GRGR'
>>        fourcc=
>> FORMAT: index=7, type=1, flags=0, description='RGB, 8bit GBGB'
>>        fourcc=
>> FORMAT: index=8, type=1, flags=0, description='RGB, 8bit BGBG'
>>        fourcc=
>> FMT SET: 640x480, fourcc=YUYV, 1280 bytes/line, 614400 bytes/frame, colorspace=0x00000001
>> FMT SET: 640x480, fourcc=YUY1, 1280 bytes/line, 614400 bytes/frame, colorspace=0x00000001
>> FMT SET: 640x480, fourcc=Y41P, 1280 bytes/line, 614400 bytes/frame, colorspace=0x00000001
>> FMT SET: 640x480, fourcc=Y211, 1280 bytes/line, 614400 bytes/frame, colorspace=0x00000001
>> FMT SET: 640x480, fourcc=RGBP, 1280 bytes/line, 614400 bytes/frame, colorspace=0x00000001
>> FMT SET: 640x480, fourcc= , 1280 bytes/line, 614400 bytes/frame, colorspace=0x00000001
>> FMT SET: 640x480, fourcc= , 1280 bytes/line, 614400 bytes/frame, colorspace=0x00000001
>> FMT SET: 640x480, fourcc= , 1280 bytes/line, 614400 bytes/frame, colorspace=0x00000001
>> FMT SET: 640x480, fourcc= , 1280 bytes/line, 614400 bytes/frame, colorspace=0x00000001
>> VIDIOC_G_PARM: Invalid argument
>> 62.5 kHz step
>> board is at freq 121.250 MHz (1940)
>> 62.5 kHz step
>> board set to freq 0.000 MHz (0)
>> 62.5 kHz step
>> board set to freq 121.250 MHz (1940)
>> Preparing for frames...
>> REQBUFS: count=2, type=video-cap, memory=mmap
>> QUERYBUF: 340649:01:50.00427104 index=0, type=video-cap, bytesused=0, flags=0x00000000, field=interlaced, sequence=0, memory=mmap, offset=0x00000000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> QUERYBUF: 340649:01:50.00387105 index=1, type=video-cap, bytesused=0, flags=0x00000000, field=interlaced, sequence=0, memory=mmap, offset=0x00096000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> Activating 2 queues
>> QBUF: 00:00:00.00000000 index=0, type=video-cap, bytesused=0, flags=0x00000000, field=any, sequence=0, memory=mmap, offset=0x00000000, length=0
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> QBUF: 00:00:00.00000000 index=1, type=video-cap, bytesused=0, flags=0x00000000, field=any, sequence=0, memory=mmap, offset=0x00000000, length=0
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> Enabling streaming
>> Waiting for frames...
>> DQBUF: 340651:14:04.00289040 index=0, type=video-cap, bytesused=0, flags=0x00000001, field=interlaced, sequence=1, memory=mmap, offset=0x00000000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> DQBUF: 340651:14:04.00329046 index=1, type=video-cap, bytesused=0, flags=0x00000001, field=interlaced, sequence=2, memory=mmap, offset=0x00096000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> DQBUF: 340651:14:04.00369044 index=0, type=video-cap, bytesused=0, flags=0x00000001, field=interlaced, sequence=3, memory=mmap, offset=0x00000000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> DQBUF: 340651:14:04.00409045 index=1, type=video-cap, bytesused=0, flags=0x00000001, field=interlaced, sequence=4, memory=mmap, offset=0x00096000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> DQBUF: 340651:14:04.00449046 index=0, type=video-cap, bytesused=0, flags=0x00000001, field=interlaced, sequence=5, memory=mmap, offset=0x00000000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> DQBUF: 340651:14:04.00489047 index=1, type=video-cap, bytesused=0, flags=0x00000001, field=interlaced, sequence=6, memory=mmap, offset=0x00096000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> DQBUF: 340651:14:04.00529046 index=0, type=video-cap, bytesused=0, flags=0x00000001, field=interlaced, sequence=7, memory=mmap, offset=0x00000000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> DQBUF: 340651:14:04.00569042 index=1, type=video-cap, bytesused=0, flags=0x00000001, field=interlaced, sequence=8, memory=mmap, offset=0x00096000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> DQBUF: 340651:14:04.00609042 index=0, type=video-cap, bytesused=0, flags=0x00000001, field=interlaced, sequence=9, memory=mmap, offset=0x00000000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> DQBUF: 340651:14:04.00649045 index=1, type=video-cap, bytesused=0, flags=0x00000001, field=interlaced, sequence=10, memory=mmap, offset=0x00096000, length=614400
>>        TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
>> stopping streaming
>>
>>
>>
>> WHERE'S the ntsc or ntsc standard???
>>
>> tell how to get it to work fine with em28 driver, thanks in advance I need this !
>>
>> http://www.empiatech.com.tw/pro_em2820.htm
>>
>> have a look at my chipset ( inside my pinnacle)
>>
>> my kword grabber have the em2860
>>
>> as long as I have standard ntsc signal ( 720x 480 29.97fps) I will do myself the 640x480  process after
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
