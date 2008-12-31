Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBVMP30E000895
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 17:25:03 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.239])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBVMOm5J019651
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 17:24:48 -0500
Received: by rv-out-0506.google.com with SMTP id f6so6156648rvb.51
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 14:24:46 -0800 (PST)
Message-ID: <c785bba30812311424r87bd070v9a01828c77d6a2a6@mail.gmail.com>
Date: Wed, 31 Dec 2008 15:24:46 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <412bdbff0812311420n3f42e13ew899be73cd855ba5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<412bdbff0812311142k46fed3adtd152498a0e391715@mail.gmail.com>
	<c785bba30812311203t405b7a98j42f139e3c3b8134a@mail.gmail.com>
	<412bdbff0812311206h435e64f2qed62499b339c53d7@mail.gmail.com>
	<c785bba30812311209k16ef6f04jc3d8867a64d4cb93@mail.gmail.com>
	<c785bba30812311220pc0a5143i67101e896b62e870@mail.gmail.com>
	<c785bba30812311258v1349ecb2pa95cd4ffbcf523c1@mail.gmail.com>
	<412bdbff0812311323rd83eac8l35f29195b599d3e@mail.gmail.com>
	<c785bba30812311330w26ce5817l10db52d5be98d175@mail.gmail.com>
	<412bdbff0812311420n3f42e13ew899be73cd855ba5d@mail.gmail.com>
Subject: Re: em28xx issues
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

Here it is,

em28xx: New device @ 480 Mbps (eb1a:2860, interface 0, class 0)
em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
em28xx #0: chip ID is em2860
saa7115' 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
em28xx #0: board has no eeprom
em28xx #0: found i2c device @ 0x4a [saa7113h]
em28xx #0: Your board has no unique USB ID.
em28xx #0: A hint were successfully done, based on i2c devicelist hash.
em28xx #0: This method is not 100% failproof.
em28xx #0: If the board were missdetected, please email this log to:
em28xx #0:      V4L Mailing List  <video4linux-list@redhat.com>
em28xx #0: Board detected as PointNix Intra-Oral Camera
em28xx #0: Registering snapshot button...
input: em28xx snapshot button as
/devices/pci0000:00/0000:00:02.1/usb1/1-1/1-1.4/input/input15
em28xx #0: Config register raw data: 0x00
em28xx #0: No AC97 audio processor
em28xx #0: v4l2 driver version 0.1.1
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
usb 1-1.4: New USB device found, idVendor=eb1a, idProduct=2860
usb 1-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0

thanks,
Paul

On Wed, Dec 31, 2008 at 3:20 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Wed, Dec 31, 2008 at 4:30 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
>> Devin,
>>
>> Thanks for your response. There isn't much in dmesg, this is all I get
>> camstream[5910]: segfault at 0 ip 000000000043ea76 sp 00007fff7724f908
>> error 6 in camstream[400000+5a000]
>>
>> Yeah, it says "Your board has no unique USB ID" and I don't see
>> pointnix intra-oral camera anywhere else. How do I figure out what
>> configuration "DVD Maker USB 2.0" should use? And how to I tell em28xx
>> to use that configuration?
>
> When the device doesn't have it's own USB ID (using Empia's USB ID
> instead), we use a heuristic based on either a hash of the eeprom or a
> hash of the list of i2c devices.  It's not surprising that the i2c
> hash would match in your case, since both devices only have a single
> saa7113 and no tuner.
>
> Could you please send the dmesg output, now that you have the latest
> v4l-dvb code compiled, which should include the eeprom hash?  From
> this, we can build a profile for your device that includes the proper
> saa7113 configuration (in particular the different inputs your device
> has).
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
