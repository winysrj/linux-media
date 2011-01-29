Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49805 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1A2U1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jan 2011 15:27:22 -0500
Received: by wwi17 with SMTP id 17so2226383wwi.1
        for <linux-media@vger.kernel.org>; Sat, 29 Jan 2011 12:27:21 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 30 Jan 2011 01:57:21 +0530
Message-ID: <AANLkTi=TA1a4J4PGK6Q08-2P=T5kyy0qdETaE0CdPhG3@mail.gmail.com>
Subject: Osprey 440
From: "jeetu.golani@gmail.com" <jeetu.golani@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

First, I'd like to apologize if this is the wrong place for this question.

I have an Osprey 440 video capture card that I'm trying to use with
linux kernel 2.6.32-5 on my debian system.  I'm having trouble
capturing the sound off the device. Has anyone managed to get both
audio and video to work on this card on all four channels?

The card itself is plugged into a PCI 32 bit socket.

Using the bttv drivers, the card gets detected by the kernel, video
devices get created with the four channels as /dev/video0, 1,2 and 3.
The video shows up fine.

On one of my setups I have audio devices created as /dev/dsp1,2,3 and
4 and on this device I can get audio though very feeble and with
distortion.

On another similar setup but with Alsa, I am unable to get any sound.
arecord -l shows the following output for this device:

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

Would sincerely appreciate any help and wisdom from someone who has
managed to get audio off this device under linux.

Thanks so much. Any help is sincerely appreciated.

Bye for now
