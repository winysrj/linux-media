Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152Ab3BSSal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 13:30:41 -0500
Date: Tue, 19 Feb 2013 15:30:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mr Goldcove <goldcove@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Wrongly identified easycap em28xx
Message-ID: <20130219153024.6f468d43@redhat.com>
In-Reply-To: <5123ACA0.2060503@googlemail.com>
References: <512294CA.3050401@gmail.com>
	<51229C2D.8060700@googlemail.com>
	<5122ACDF.1020705@gmail.com>
	<5123ACA0.2060503@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Feb 2013 17:47:28 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 18.02.2013 23:36, schrieb Mr Goldcove:
> > I've only tried composite video input.
> > The video/ audio output is good.
> >  
> > It has the following input:
> > RCA stereo sound
> > RCA video
> > S-video
> >
> > It has no push button but has a green led which illuminates when the
> > device is in use.
> >
> >
> > On 18. feb. 2013 22:25, Frank Schäfer wrote:
> >> Am 18.02.2013 21:53, schrieb Mr Goldcove:
> >>> "Easy Cap DC-60++"
> >>> Wrongly identified as card 19 "EM2860/SAA711X Reference Design",
> >>> resulting in no audio.
> >>> Works perfectly when using card 64 "Easy Cap Capture DC-60"
> >> Video inputs work fine, right ?
> >> Does this device has any buttons / LEDs ?
> >>
> >> The driver doesn't handle devices with generic IDs very well.
> >> In this case we can conclude from the USB PID that the device has audio
> >> support (which is actually the only difference to board
> >> EM2860_BOARD_SAA711X_REFERENCE_DESIGN).
> >> But I would like to think twice about it, because this kind of changes
> >> has very a high potential to cause regressions for other boards...
> >>
> >> Regards,
> >> Frank
> 
> After thinking about this for some minutes:
> The easiest soulution would be, to add .amux = EM28XX_AMUX_LINE_IN lines
> to input definitions of board EM2860_BOARD_SAA711X_REFERENCE_DESIGN.
> No additional code lines (check for audio support etc.) would be needed
> and (as side effect) board EM2860_BOARD_EASYCAP would become obsolete.
> 
> The last modification of board EM2860_BOARD_SAA711X_REFERENCE_DESIGN was
> commit 3ed58baf5db4eab553803916a990a3dbca4dc611 from Devin.
> The commit message says
> 
> "The device provides the audio through a pass-thru cable, so we don't need
>  an actual audio capture profile (neither the K-World device nor the
> Pointnix
>  have an onboard audio decoder)"
> 
> Changing the .amux settings doesn't cause any trouble for devices
> without audio support
> (there is actually no way to define _no_ amux, without this line in the
> input definition .amux is 0 = EM28XX_AMUX_VIDEO).
> 
> BUT: as we are talking about devices with generic USB IDs, we don't (and
> will never) know about all other existing devices.
> There _might_ be some unknown devices with audio support, which are
> working silently with the current audio settings for board
> EM2860_BOARD_SAA711X_REFERENCE_DESIGN.
> 
> OTOH: if we keep the two separate boards and switch from board
> EM2860_BOARD_SAA711X_REFERENCE_DESIGN to board EM2860_BOARD_EASYCAP when
> the device has audio support,
> the same shit can happen.
> 
> Thoughts ?
>
> Does anyone know how the Empia-driver handles devices with generic IDs ?
> Do you think we can assume their driver uses a single reference board
> design for the detected combination of USB-ID and subdevices ?
> 

I don't like the idea of merging those two entries. As far as I remember
there are devices that works out of the box with
EM2860_BOARD_SAA711X_REFERENCE_DESIGN. A change like that can break
the driver for them.


Regards,
Mauro
