Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:19969 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220Ab0IHICG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 04:02:06 -0400
Date: Wed, 8 Sep 2010 10:59:03 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Eino-Ville Talvala <talvala@stanford.edu>
Cc: Andy Walls <awalls@md.metrocast.net>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Illuminators and status LED controls
Message-ID: <20100908075903.GE29776@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>
 <4C86F210.2060605@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4C86F210.2060605@stanford.edu>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

On Wed, Sep 08, 2010 at 04:16:48AM +0200, ext Eino-Ville Talvala wrote:
> 
>  This is probably a bit OT, but these sorts of indicator LEDs can get quite complicated.
> 
> As part of our FCamera sample program on the Nokia N900 (which uses V4L2 way down there), we wanted to reprogram the front indicator LED to flash exactly when a picture is taken.  The N900 front LED is quite a programmable beast [1], with a dedicated microcontroller (the lp5521) that runs little programs that define the blink patterns for the RGB LED.
> 
> I'm not really suggesting that the V4L2 control should be able to handle this sort of an LED, but as these sorts of things get cheaper, it may become a case of 'why not?' for manufacturers putting in more complex RGB LEDs.   And if you don't want to encapsulate all that in V4L2, it may be better to leave it to other APIs at some point of complexity (the current lp5521 driver seems to have a sysfs-only interface for now for the programmable patterns, and the standard LED API otherwise)
> 
> [1] http://wiki.maemo.org/LED_patterns

Well, that's exactly why duplicating API's is usually a bad idea. If the thing start to get complex, having only one place to hold
the mess is better than keeping it into two (or more) different places. This will become worst and worst. I mean, why do we want two
different APIs to control same stuff?

And yes, application developers must use the correct API to control stuff. Why should kernel duplicate interfaces just because
user land don't want to use two different interfaces? Doesn't this sound a bit ... strange at least?

> 
> Eino-Ville Talvala
> Computer Graphics Lab
> Stanford University
> 
> On 9/7/2010 1:33 PM, Andy Walls wrote:
> > It has already been discussed.  Please check the list archives for the past few days.


OK, will search the logs. But you should probably add some sort of reasoning in your patch
description, explaining why you are duplicating interfaces.

> >
> > Do you know of any V4L2 application developer or development team that prefers to use a separate API just to turn lights on and off, when all other aspects of the incoming video are controlled with the V4L2 control API?
> >
> > (That question is mostly rhetorical, but I'd still actually be interested from video app developers.)
> >
> > Regards,
> > Andy
> >
> > Eduardo Valentin <eduardo.valentin@nokia.com> wrote:
> >
> >> Hello,
> >>
> >> On Mon, Sep 06, 2010 at 08:11:05PM +0200, ext Jean-Francois Moine wrote:
> >>> Hi,
> >>>
> >>> This new proposal cancels the previous 'LED control' patch.
> >>>
> >>> Cheers.
> >>>
> >>> -- 
> >>> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> >>> Jef		|		http://moinejf.free.fr/
> >> Apologies if this has been already discussed but,
> >> doesn't this patch duplicates the same feature present
> >> nowadays under include/linux/leds.h ??
> >>
> >> I mean, if you want to control leds, I think we already have that API, no?
> >>
> >> BR,
> >>
> >> ---
> >> Eduardo Valentin
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
> 

-- 
---
Eduardo Valentin
