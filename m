Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p0VDELh1022060
	for <video4linux-list@redhat.com>; Mon, 31 Jan 2011 08:14:21 -0500
Received: from mail-ww0-f46.google.com (mail-ww0-f46.google.com [74.125.82.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0VDE8aW004161
	for <video4linux-list@redhat.com>; Mon, 31 Jan 2011 08:14:09 -0500
Received: by wwj40 with SMTP id 40so6595566wwj.27
	for <video4linux-list@redhat.com>; Mon, 31 Jan 2011 05:14:07 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 31 Jan 2011 18:14:07 +0500
Message-ID: <AANLkTim4oUWqOW4xqxL4h2MDVpAhpDv1nUadxp+BBk7E@mail.gmail.com>
Subject: Osprey 440 - volume too low
From: "jeetu.golani@gmail.com" <jeetu.golani@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hello,

First, I'd like to apologize if this is the wrong place for this question.

I have an Osprey 440 video capture card that I'm trying to use with
linux kernel 2.6.32-5 on my debian system. While video is all right.
I'm having trouble with the audio for this device. The volume is very low.

The card itself is plugged into a PCI 32 bit socket.

arecord -L reports the following:

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
 Subdevices: 2/2
 Subdevice #0: subdevice #0
 Subdevice #1: subdevice #1
card 1: Bt878 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x Digital]
 Subdevices: 1/1
 Subdevice #0: subdevice #0
card 2: Bt878_1 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x Digital]
 Subdevices: 1/1
 Subdevice #0: subdevice #0
card 3: Bt878_2 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x Digital]
 Subdevices: 1/1
 Subdevice #0: subdevice #0
card 4: Bt878_3 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x Digital]
 Subdevices: 1/1
 Subdevice #0: subdevice #0

Using the bttv drivers, the card gets detected by the kernel, video
devices get created with the four channels as /dev/video0, 1,2 and 3.
The video shows up fine.

I have audio devices created as /dev/dsp1,2,3 and 4 and on this device
I can get audio though it is quite faint. Is there some option I can use
with the bttv modules or the corresponding snd_bt87x that would help
me set the gain for this device or increase volume?

Has someone managed to use this card (audio and video) successfully
on linux?

Would sincerely appreciate any help and wisdom.

Thanks so much. Any help is sincerely appreciated.

Bye for now

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
