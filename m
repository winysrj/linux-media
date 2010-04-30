Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:54368 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933610Ab0D3R50 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 13:57:26 -0400
Subject: Re: [PATCH] TT S2-1600 allow more current for diseqc
From: hermann pitton <hermann-pitton@arcor.de>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Guy Martin <gmsoft@tuxicoman.be>,
	=?ISO-8859-1?Q?Andr=E9?= Weidemann <Andre.Weidemann@web.de>,
	linux-media@vger.kernel.org
In-Reply-To: <r2y1a297b361004280613s10585a6we3d14ddb9de5bcfc@mail.gmail.com>
References: <20100411231805.4bc7fdef@borg.bxl.tuxicoman.be>
	 <4BD7E7A3.2060101@web.de> <20100428103303.2fe4c9ea@zombie>
	 <r2y1a297b361004280613s10585a6we3d14ddb9de5bcfc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Apr 2010 02:31:05 +0200
Message-Id: <1272587465.3305.34.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 28.04.2010, 17:13 +0400 schrieb Manu Abraham:
> On Wed, Apr 28, 2010 at 12:33 PM, Guy Martin <gmsoft@tuxicoman.be> wrote:
> > On Wed, 28 Apr 2010 09:45:39 +0200
> > André Weidemann <Andre.Weidemann@web.de> wrote:
> >
> >> I advise not to pull this change into the kernel sources.
> >> The card has only been testet with the a maximum current of 515mA.
> >> Anything above is outside the specification for this card.
> >
> >
> > I'm currently running two of these cards in the same box with this
> > patch.
> > Actually, later on I've even set curlim = SEC_CURRENT_LIM_OFF because
> > sometimes diseqc wasn't working fine and that seemed to solve the
> > problem.
> 
> I would advise to not do this: since disabling current limiting etc
> will cause a large problem in the case of a short circuit thereby no
> protection to the hardware. In such an event, it could probably damage
> the tracks carrying power on the card as well as the tracks on the
> motherboard, and in some cases the gold finches themselves and or the
> PCI connector.
> 
> Generally, there are only a few devices capable of sourcing > 0.5A, So
> I wonder ....
> 
> Regards,
> Manu

for the few devices I do have, you seem to be for sure right.

All the Creatix stuff drawing up to 900mA on a potentially dual isl6405
has direct voltage from the PSU over an extra floppy connector.

Max. 500mA should be sufficient with a DiSEqC 1.2 compliant rotor.
Nothing else should come above that limit.

I wonder, if someone close in reading specs just now, can tell if 900mA
can be sufficient for two rotors ;)

Andre, BTW, assuming you still have a CTX944 (md8800 Quad), can you
measure if the 16be:0008 device really does switch between 13 and 18V.

Mine does not, but is also not in the original PC and the 0007 and 0008
devices are swapped on the PCI bus compared to that one.

Seen from my limited skills, it should not make any difference. So I
don't know why some did report all is fine on 0008 and I can only say it
hangs on 18V after init from the i2c capable 0007 device and on exit it
powers down properly, that's all, but _never_ is on 13V.

Be aware, that RF loopthrough between the two DVB-S tuners is
enabled ...

Thanks,
Hermann







