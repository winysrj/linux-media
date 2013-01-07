Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab3AGQNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 11:13:35 -0500
Date: Mon, 7 Jan 2013 14:13:02 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some IR fixes for I2C devices on em28xx
Message-ID: <20130107141302.642f5875@redhat.com>
In-Reply-To: <50E9DE06.2000205@googlemail.com>
References: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
	<50E82900.9060701@googlemail.com>
	<50E82DB2.4070405@googlemail.com>
	<20130105133511.325fda1d@redhat.com>
	<50E9DE06.2000205@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 06 Jan 2013 21:26:46 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 05.01.2013 16:35, schrieb Mauro Carvalho Chehab:
> > Em Sat, 05 Jan 2013 14:42:10 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Am 05.01.2013 14:22, schrieb Frank Schäfer:
> >>> Am 04.01.2013 22:15, schrieb Mauro Carvalho Chehab:
> >>>> Frank pointed that IR was not working with I2C devices. So, I took some
> >>>> time to fix them.
> >>>>
> >>>> Tested with Hauppauge WinTV USB2.
> >>>>
> >>>> Mauro Carvalho Chehab (4):
> >>>>   [media] em28xx: initialize button/I2C IR earlier
> >>>>   [media] em28xx: autoload em28xx-rc if the device has an I2C IR
> >>>>   [media] em28xx: simplify IR names on I2C devices
> >>>>   [media] em28xx: tell ir-kbd-i2c that WinTV uses an RC5 protocol
> >>>>
> >>>>  drivers/media/usb/em28xx/em28xx-cards.c |  2 +-
> >>>>  drivers/media/usb/em28xx/em28xx-input.c | 29 ++++++++++++++++-------------
> >>>>  2 files changed, 17 insertions(+), 14 deletions(-)
> >>>>
> >>> While these patches make I2C IR remote controls working again, they
> >>> leave several issues unaddressed which should really be fixed:
> >>> 1) the i2c client isn't unregistered on module unload. This was the
> >>> reason for patch 2 in my series. There is also a FIXME comment about
> >>> this in em28xx_release_resources() (although this is the wrong place to
> >>> do it).
> >>> 2) there is no error checking in em28xx_register_i2c_ir().
> >>> em28xx_ir_init should really bail out if no i2c device is found.
> >>> 3) All RC maps should be assigned at the same place, no matter if the
> >>> receiver/demodulator is built in or external. Spreading them over the
> >>> code is inconsistent and makes the code bug prone.
> >>> 4) the list of known i2c devices in em28xx-i2c.c misses client address
> >>> 0x3e >> 1 = 0x1f. See client list in em28xx_register_i2c_ir().
> >>> 5) there should be a warning message for the case that we call
> >>> ir-kbd-i2c with an unknown rc device.
> >>> 6) because we use our own key polling functions with ir-kbd-i2c, we
> >>> should also select the polling interval value manually. That makes
> >>> things consistent and avoids confusion.
> >>>
> >>> The rest is a matter of taste / prefered code layout. I'm fine with it.
> >>>
> >>> Regards,
> >>> Frank
> >> It seems like already applied them... :(
> >>
> >> While I certainly appreciate patches beeing applied as soon as possible,
> >> I think there should really be a chance to review them before this happens.
> >> Especially when the changes are non-trivial and someone else has posted
> >> patches addressing the same issues before (other contributers might feel
> >> offended ;) ).
> > All the 4 applied patches are really trivial:
> > 	- patch 1: just reorder existing code;
> > 	- patch 2: one-line patch adding another condition to an existing if;
> > 	- patch 3: pure string rename;
> > 	- patch 4: one line patch properly reporting the RC5 protocol on WinTV.
> 
> Just because a patch "just reorders existing code" or "just changes a
> single line" it's not automatically trivial.

True, but this is not the case of all the above ones: all of them are obvious,
and do what are described there.

> I'm sure you have seen more cases than me in which it were patches like
> this who caused big trouble. ;)

Trivial patches are known to cause troubles, just like any other code change.

The thing is that trivial patches are:
	1) easy to review, especially when properly described;
	2) when they're wrong, easy to fix;
	3) easy to get them accepted/merged at stable kernels.

In any case, if you found any breakage caused by the above patches, feel
free to send a patch fixing it.

If you're concerned with other things that aren't there, send in separate.

The rule is one patch by each logical change.

> Yeah, I understand your time problems and I really appreciate patches
> beeing applied as soon as possible (after they have been reviewed).
> But delaying a patch for a few days really shouldn't cause too much
> extra work.

It causes, as my main work is unrelated to drivers/media maintenance.
So, it may take weeks for me to be able to get a time slice big enough
for installing a kernel on my test machines and re-test some code.

Cheers,
Mauro
