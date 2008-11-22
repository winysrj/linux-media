Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAM00V8A015533
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 19:00:31 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.237])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAM00KmY008931
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 19:00:20 -0500
Received: by rv-out-0506.google.com with SMTP id f6so1248396rvb.51
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 16:00:20 -0800 (PST)
Message-ID: <d7e40be30811211600u354bf1ebg57567ebd3cd375a@mail.gmail.com>
Date: Sat, 22 Nov 2008 11:00:20 +1100
From: "Ben Klein" <shacklein@gmail.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>,
	V4L <video4linux-list@redhat.com>
In-Reply-To: <412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
MIME-Version: 1.0
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
	<412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
	<alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
	<412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: Re: [video4linux] Attention em28xx users
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

2008/11/20 Devin Heitmueller <devin.heitmueller@gmail.com>

> Playing with the "card=" argument is probably not such a good idea.
> I should consider taking that functionality out, since setting to the
> wrong card number can damage the device (by setting the wrong GPIOs).
>

What about us folk who currently can't get em28xx working without the
"card=" option? With no card= option, my "Tevion High Speed DVD Maker"
device (eb1a:2861) is detected but reports no inputs (the inputs should be
S-Video and Composite). dmesg snippet:

em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (eb1a:2861): interface 0, class 255
em28xx Has usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: chip ID is em2860
em28xx #0: found i2c device @ 0xb8 [tvp5150a]
em28xx #0: Your board has no unique USB ID and thus need a hint to be
detected.
em28xx #0: You may try to use card=<n> insmod option to workaround that.
em28xx #0: Please send an email with this log to:
em28xx #0:     V4L Mailing List <video4linux-list@redhat.com>
em28xx #0: Board eeprom hash is 0x00000000
em28xx #0: Board i2c devicelist hash is 0x77800080
em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
-- snip --
tvp5150 7-005c: tvp5150am1 detected.
em28xx #0: V4L2 device registered as /dev/video2 and /dev/vbi1
em28xx #0: Found Unknown EM2750/28xx video grabber
usbcore: registered new interface driver em28xx
tvp5150 7-005c: tvp5150am1 detected.

So far, the only card= values I've found also report a TV tuner (10, 13, 38,
39, 58), but I haven't tested every single value.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
