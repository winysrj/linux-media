Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7R1MOP6021282
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 21:22:25 -0400
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7R1M9P5027534
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 21:22:10 -0400
Received: by wa-out-1112.google.com with SMTP id j32so1551162waf.7
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 18:22:09 -0700 (PDT)
Message-ID: <151f42ba0808261822i7bf0287eye62d71103bffd4af@mail.gmail.com>
Date: Tue, 26 Aug 2008 15:22:08 -1000
From: "Stephan Fabel" <stephan.fabel@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: VIDIO_DQBUF error 5
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

Hi ppl,

I am getting this error addressing the v4l2 /dev/video0 device with
OpenCV. Sometimes the program won't even start, sometimes this error
occurs after a seemingly random amount of time (but sooner or later it
always occurs, never later than 10 secs).

BUT: tvtime works without a problem....?

According to this website:

http://robolab.tek.sdu.dk/mediawiki/index.php/Using_OpenCV_on_live_video
it is supposed to be a bug in the bttv driver but I am not sure, since
the tvtime program works.

I am using linux kernel 2.6.24-19-generic, ubuntu packaged.

Since I am not sure about this bug (and I couldn't find it anywhere on
the web), could it be that the above error comes due to a
configuration fault? I set the input to S-Video, which is correct.
This is what v4l2-ctl --all gives:

Driver Info:
	Driver name   : bttv
	Card type     : BT878 video (Hauppauge (bt878))
	Bus info      : PCI:0000:02:01.0
	Driver version: 2321
	Capabilities  : 0x05010015
		Video Capture
		Video Overlay
		VBI Capture
		Tuner
		Read/Write
		Streaming
Format Video Capture:
	Width/Height  : 640/480
	Pixel Format  : BGR3
	Field         : Interlaced
	Bytes per Line: 1920
	Size Image    : 921600
	Colorspace    : Unknown (00000000)
Format Video Overlay:
	Left/Top    : 0/0
	Width/Height: 320/240
	Field       : Any
	Chroma Key  : 0x00000000
	Global Alpha: 0x00
	Clip Count  : 0
	Clip Bitmap : No
Format VBI Capture:
	Sampling Rate   : 28636363 Hz
	Offset          : 244 samples (8.52064e-06 secs after leading edge)
	Samples per Line: 2048
	Sample Format   : GREY
	Start 1st Field : 10
	Count 1st Field : 16
	Start 2nd Field : 273
	Count 2nd Field : 16
Framebuffer Format:
	Capability    : Clipping List
	Flags         :
	Width         : 0
	Height        : 0
	Pixel Format  : YU12
	Bytes per Line: 0
	Size image    : 0
	Colorspace    : Unknown (00000000)
Crop Capability Video Capture:
	Bounds      : Left 68, Top 22, Width 838, Height 504
	Default     : Left 128, Top 46, Width 768, Height 480
	Pixel Aspect: 910/780
Crop: Left 128, Top 46, Width 768, Height 480
Video input : 2 (S-Video)
Frequency: 0 (0.000000 MHz)
Video Standard = 0x00009000
	NTSC-M/M-KR
Tuner:
	Capabilities         : 62.5 kHz multi-standard
	Frequency range      : 0.0 MHz - 0.0 MHz
	Signal strength      : 99%
	Current audio mode   : mono
	Available subchannels: mono

I would like to capture 640x480, which apparently is the right format
according to the output above.

Any help is greatly appreciated.

Thanks,
Stephan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
