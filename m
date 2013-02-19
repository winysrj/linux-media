Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700Ab3BSNGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 08:06:22 -0500
Date: Tue, 19 Feb 2013 10:06:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Mr Goldcove <goldcove@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Wrongly identified easycap em28xx
Message-ID: <20130219100614.508af9e2@redhat.com>
In-Reply-To: <51229C2D.8060700@googlemail.com>
References: <512294CA.3050401@gmail.com>
	<51229C2D.8060700@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 18 Feb 2013 22:25:01 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 18.02.2013 21:53, schrieb Mr Goldcove:
> > "Easy Cap DC-60++"
> > Wrongly identified as card 19 "EM2860/SAA711X Reference Design",
> > resulting in no audio.
> > Works perfectly when using card 64 "Easy Cap Capture DC-60"
> 
> Video inputs work fine, right ?
> Does this device has any buttons / LEDs ?
> 
> The driver doesn't handle devices with generic IDs very well.
> In this case we can conclude from the USB PID that the device has audio
> support (which is actually the only difference to board
> EM2860_BOARD_SAA711X_REFERENCE_DESIGN).
> But I would like to think twice about it, because this kind of changes
> has very a high potential to cause regressions for other boards...

While em28xx driver tries to do its best to detect, devices without
EEPROM will always have issues, as there are lots of similar devices
with small differences on how they were wired up.

That's why em28xx has the "card" modprobe parameter.

Ok, it likely makes sense to add an additional hint based on has_audio.

> 
> Regards,
> Frank
> 
> >
> > **Interim solution**
> > load module (before inserting the EasyCap. I'm having trouble if the
> > module is loaded/unloaded with different cards...)
> > modprobe em28xx card=64
> >   or
> > add "options em28xx card=64" to /etc/modprobe.d/local.conf

That is the right thing to do. It makes sense to have it documented at the
Wiki, in order to help others with similar boards.

Regards,
Mauro

> >
> > **hw info**
> > Bus 002 Device 005: ID eb1a:2861 eMPIA Technology, Inc.
> >
> > Chips:
> > Empia EM2860 P7JY8-011 201023-01AG
> > NXP SAA7113H
> > RMC ALC653 89G06K1 G909A

The driver could be detecting if Realtek alc653 is found, in order to
hint it as "EasyCap":

[ 5568.813055] em28xx #0: AC97 vendor ID = 0x414c4761

If I'm not mistaken, someone wrote at the ML that "EasyCap" is actually 
just a generic name used by some Chinese companies to indicate a video
capture USB device. The fact is that there are EasyCap devices using 
even completely different chipsets.

Cheers,
Mauro
