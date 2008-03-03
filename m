Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m236Yr9W022716
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 01:34:53 -0500
Received: from QMTA08.westchester.pa.mail.comcast.net
	(qmta08.westchester.pa.mail.comcast.net [76.96.62.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m236YLTf007091
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 01:34:21 -0500
Message-ID: <47CB9BFA.8070500@personnelware.com>
Date: Mon, 03 Mar 2008 00:34:34 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <47CB2689.3010707@personnelware.com>
	<47CB6801.4060503@personnelware.com>
In-Reply-To: <47CB6801.4060503@personnelware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: vivi.c stuck my CPU
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

Just to be sure my recent hacking wasn't the cause, here is the same problem 
using the stock vivi.

Carl K

++ transcode -i /dev/video0 -x v4l2,null -g 640x480
transcode v1.2.0-cvs (C) 2001-2003 Thomas Oestreich, 2003-2007 Transcode Team
[transcode] V: auto-probing     | /dev/video0 (OK)
[transcode] V: import format    | (null) in  (module=v4l2)
[transcode] A: auto-probing     | /dev/video0 (OK)
[transcode] A: import format    | PCM in  (module=null)
[transcode] V: AV demux/sync    | (1) sync AV at initial MPEG sequence
[transcode] V: import frame     | 640x480  1.33:1  encoded @ UNKNOWN
[transcode] V: bits/pixel       | 0.196
[transcode] V: decoding fps,frc | 29.970,4
[transcode] V: video format     | YUV420 (4:2:0) aka I420
[transcode] A: import format    | 0x1     PCM          [44100,16,2]
[transcode] A: export           | disabled
[transcode] V: encoding fps,frc | 29.970,4
[transcode] A: bytes per frame  | 5884 (5885.880000)
[transcode] A: adjustment       | 1880@1000
[transcode] V: IA32/AMD64 accel | sse2 sse mmx cmove asm
[transcode] warning: no option -o found, encoded frames send to "/dev/null"
[transcode] warning: no option -y found, option -o ignored, writing to "/dev/null"
[transcode] V: video buffer     | 10 @ 640x480 [0x2]
[transcode] A: audio buffer     | 10 @ 44100x2x16
[import_null.so] v0.2.0 (2002-01-19) (video) null | (audio) null
[import_v4l2.so] v1.4.0 (2005-10-08) (video) v4l2 | (audio) pcm
[export_null.so] v0.1.2 (2001-08-17) (video) null | (audio) null
[import_v4l2.so] v4l2 video grabbing
[import_v4l2.so] resync disabled
[import_v4l2.so] video grabbing, driver = vivi, card = vivi
[import_v4l2.so] critical: VIDIOC_S_FMT: : Invalid argument
[import_v4l2.so] critical: Pixel format conversion: YUV420 [planar] -> YUV420 
[planar] (no conversion)
[import_v4l2.so] critical: VIDIOC_S_FMT: : Invalid argument
[import_v4l2.so] critical: Pixel format conversion: YVU420 [planar] -> YUV420 
[planar]
[import_v4l2.so] critical: VIDIOC_S_FMT: : Invalid argument
[import_v4l2.so] critical: Pixel format conversion: YUV422 [planar] -> YUV420 
[planar]
[import_v4l2.so] critical: VIDIOC_S_FMT: : Invalid argument
[import_v4l2.so] critical: Pixel format conversion: YUV411 [planar] -> YUV420 
[planar]
[import_v4l2.so] critical: VIDIOC_S_FMT: : Invalid argument
[import_v4l2.so] critical: Pixel format conversion: UYVY [packed] -> YUV420 [planar]
[import_v4l2.so] Pixel format conversion: YUY2 [packed] -> YUV420 [planar]
[import_v4l2.so] warning: driver does not support setting parameters 
(ioctl(VIDIOC_S_PARM) returns "Invalid argument")
[import_v4l2.so] checking colour & framerate standards:
[import_v4l2.so] [NTSC-M]
[import_v4l2.so] receiving 30 frames / sec
[import_v4l2.so] warning: driver does not support cropping 
(ioctl(VIDIOC_CROPCAP) returns "Invalid argument"), disabled
[import_v4l2.so] 27 buffers available
[import_v4l2.so] critical: VIDIOC_S_CTRL: Invalid argument
[import_v4l2.so] critical: VIDIOC_DQBUF: Input/output error0|11)
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Input/output error
[import_v4l2.so] critical: recover DQBUF: Invalid argument
encoding frames [0-81786],  33.10 fps, CFT: 0:45:28,  ( 9| 0|11)


Mar  2 22:55:52 averatec kernel: [ 6285.287267] Linux video capture interface: v2.00
Mar  2 22:55:52 averatec kernel: [ 6285.365317] videodev: "vivi" has no release 
callback. Please fix your driver for proper sysfs support, see 
http://lwn.net/Articles/36850/
Mar  2 22:55:52 averatec kernel: [ 6285.365332] Video Technology Magazine 
Virtual Video Capture Board (Load status: 0)
Mar  2 23:08:09 averatec -- MARK --
Mar  2 23:17:02 averatec /USR/SBIN/CRON[6050]: (root) CMD (   cd / && run-parts 
--report /etc/cron.hourly)
Mar  2 23:28:09 averatec -- MARK --
Mar  2 23:35:14 averatec kernel: [ 8645.771164] vivi: open called (minor=0)
Mar  2 23:35:20 averatec kernel: [ 8651.424893] vivi/0: [c462c600/21] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424906] vivi/0: [c462c200/22] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424911] vivi/0: [c462c400/23] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424916] vivi/0: [c462cc00/24] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424921] vivi/0: [c462c800/25] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424926] vivi/0: [c462cb00/26] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424932] vivi/0: [cecac500/0] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424937] vivi/0: [cecac180/1] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424942] vivi/0: [cecac200/2] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424947] vivi/0: [cecac480/3] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424952] vivi/0: [cecac900/4] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424957] vivi/0: [cecacb80/5] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424962] vivi/0: [cecacb00/6] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424967] vivi/0: [cecaca00/7] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424971] vivi/0: [cecac980/8] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424976] vivi/0: [cecacf00/9] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424981] vivi/0: [cecace80/10] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424986] vivi/0: [cecacd00/11] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424991] vivi/0: [cecac100/12] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.424996] vivi/0: [cecacd80/13] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.425001] vivi/0: [c462c380/14] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.425006] vivi/0: [c462c900/15] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.425011] vivi/0: [c462c100/16] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.425016] vivi/0: [c462cd80/17] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.425021] vivi/0: [c462c580/18] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.425026] vivi/0: [c462cb80/19] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.425031] vivi/0: [c462ca80/20] timeout
Mar  2 23:35:20 averatec kernel: [ 8651.433110] vivi: close called (minor=0, 
users=0)
Mar  2 23:43:02 averatec kernel: [ 9113.495941] vivi: open called (minor=0)
Mar  2 23:43:02 averatec kernel: [ 9113.497601] vivi: close called (minor=0, 
users=0)
Mar  2 23:43:02 averatec kernel: [ 9113.512104] vivi: open called (minor=0)
Mar  2 23:43:02 averatec kernel: [ 9113.514565] vivi: close called (minor=0, 
users=0)
Mar  2 23:43:34 averatec kernel: [ 9146.016418] vivi: open called (minor=0)
Mar  2 23:43:34 averatec kernel: [ 9146.017994] vivi: close called (minor=0, 
users=0)
Mar  2 23:43:34 averatec kernel: [ 9146.033646] vivi: open called (minor=0)
Mar  2 23:43:34 averatec kernel: [ 9146.035201] vivi: close called (minor=0, 
users=0)
Mar  2 23:44:04 averatec kernel: [ 9175.929944] vivi: open called (minor=0)
Mar  2 23:44:04 averatec kernel: [ 9175.931536] vivi: close called (minor=0, 
users=0)
Mar  2 23:44:04 averatec kernel: [ 9175.948399] vivi: open called (minor=0)
Mar  2 23:44:04 averatec kernel: [ 9175.949935] vivi: close called (minor=0, 
users=0)
Mar  2 23:44:04 averatec kernel: [ 9176.010399] vivi: open called (minor=0)
Mar  2 23:44:04 averatec kernel: [ 9176.012212] vivi: close called (minor=0, 
users=0)
Mar  2 23:44:35 averatec kernel: [ 9206.879978] vivi: open called (minor=0)
Mar  2 23:44:35 averatec kernel: [ 9206.881611] vivi: close called (minor=0, 
users=0)
Mar  2 23:44:35 averatec kernel: [ 9206.897332] vivi: open called (minor=0)
Mar  2 23:44:35 averatec kernel: [ 9206.898868] vivi: close called (minor=0, 
users=0)
Mar  2 23:44:35 averatec kernel: [ 9206.903592] vivi: open called (minor=0)
Mar  3 00:08:09 averatec -- MARK --
Mar  3 00:17:01 averatec /USR/SBIN/CRON[6200]: (root) CMD (   cd / && run-parts 
--report /etc/cron.hourly)
Mar  3 00:20:21 averatec kernel: [11351.719611] vivi/0: [cdb34e00/9] timeout
Mar  3 00:20:21 averatec kernel: [11351.719622] vivi/0: [cdb34680/10] timeout
Mar  3 00:20:21 averatec kernel: [11351.719628] vivi/0: [cdb34400/11] timeout
Mar  3 00:20:21 averatec kernel: [11351.719633] vivi/0: [cdb34c00/12] timeout
Mar  3 00:20:21 averatec kernel: [11351.719638] vivi/0: [cdb34e80/13] timeout
Mar  3 00:20:21 averatec kernel: [11351.719643] vivi/0: [cdb34500/14] timeout
Mar  3 00:20:21 averatec kernel: [11351.719648] vivi/0: [cdb34900/15] timeout
Mar  3 00:20:21 averatec kernel: [11351.719653] vivi/0: [cdb34780/16] timeout
Mar  3 00:20:21 averatec kernel: [11351.719658] vivi/0: [cdb34f00/17] timeout
Mar  3 00:20:21 averatec kernel: [11351.719663] vivi/0: [cdb34700/18] timeout
Mar  3 00:20:21 averatec kernel: [11351.719668] vivi/0: [cdb34800/19] timeout
Mar  3 00:20:21 averatec kernel: [11351.719672] vivi/0: [cdb34d00/20] timeout
Mar  3 00:20:21 averatec kernel: [11351.719677] vivi/0: [cdb34a00/21] timeout
Mar  3 00:20:21 averatec kernel: [11351.719682] vivi/0: [cdb34380/22] timeout
Mar  3 00:20:21 averatec kernel: [11351.719687] vivi/0: [cdb34200/23] timeout
Mar  3 00:20:21 averatec kernel: [11351.719692] vivi/0: [cdb34280/24] timeout
Mar  3 00:20:21 averatec kernel: [11351.719697] vivi/0: [cdb34080/25] timeout
Mar  3 00:20:21 averatec kernel: [11351.719702] vivi/0: [cdb34980/26] timeout
Mar  3 00:20:21 averatec kernel: [11351.719707] vivi/0: [cdb34f80/0] timeout
Mar  3 00:20:21 averatec kernel: [11351.719713] vivi/0: [cdb34300/1] timeout
Mar  3 00:20:21 averatec kernel: [11351.719718] vivi/0: [cdb34600/2] timeout
Mar  3 00:20:21 averatec kernel: [11351.719723] vivi/0: [cdb34b80/3] timeout
Mar  3 00:20:21 averatec kernel: [11351.719727] vivi/0: [cdb34d80/4] timeout
Mar  3 00:20:21 averatec kernel: [11351.719732] vivi/0: [cdb34880/5] timeout
Mar  3 00:20:21 averatec kernel: [11351.719737] vivi/0: [cdb34100/6] timeout
Mar  3 00:20:21 averatec kernel: [11351.719742] vivi/0: [cdb34580/7] timeout
Mar  3 00:20:21 averatec kernel: [11351.719747] vivi/0: [cdb34480/8] timeout

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
