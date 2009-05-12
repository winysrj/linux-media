Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53225 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413AbZEMLU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 07:20:56 -0400
Received: by ewy24 with SMTP id 24so686417ewy.37
        for <linux-media@vger.kernel.org>; Wed, 13 May 2009 04:20:55 -0700 (PDT)
Date: Wed, 13 May 2009 07:21:14 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] FM1216ME_MK3 some changes
Message-ID: <20090513072114.39b3a929@glory.loctelecom.ru>
In-Reply-To: <4A07FBA9.4010306@redhat.com>
References: <20090422174848.1be88f61@glory.loctelecom.ru>
	<1240452534.3232.70.camel@palomino.walls.org>
	<20090423203618.4ac2bc6f@glory.loctelecom.ru>
	<1240537394.3231.37.camel@palomino.walls.org>
	<20090427192905.3ad2b88c@glory.loctelecom.ru>
	<20090428151832.241fa9b4@pedra.chehab.org>
	<20090428195922.1a079e46@glory.loctelecom.ru>
	<1240974643.4280.24.camel@pc07.localdom.local>
	<20090429201225.6ba681cf@glory.loctelecom.ru>
	<1241050556.3710.109.camel@pc07.localdom.local>
	<20090506044231.31f2d8aa@glory.loctelecom.ru>
	<1241654513.5862.37.camel@pc07.localdom.local>
	<1241665384.3147.53.camel@palomino.walls.org>
	<1241741304.4864.29.camel@pc07.localdom.local>
	<1241834493.3482.140.camel@palomino.walls.org>
	<1241836025.3717.9.camel@pc07.localdom.local>
	<1241916185.3694.8.camel@pc07.localdom.local>
	<20090510085258.03068a1e@glory.loctelecom.ru>
	<1242012951.3753.21.camel@pc07.localdom.local>
	<4A07FBA9.4010306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi 

> >> 1. AGC TOP of RF part - I think need support for MK3
> >> 2. Changing to 441MHz is not critical. We can write some
> >> information about this case to Wiki or docs.
> > 
> > for 2.: Discussed to the end if you stay at 441MHz. If you still
> > want to have it in, just send  a patch and no more info is needed.
> > (Likely Andy is giving only examples for more difficult cases,
> > sorry.)
> > 
> > for 1.: I would like to be absolutely sure, that we are talking
> > about the same tuner. I want to have the exact filters on it at
> > least.
> 
> I would also say that, if we need to implement AGC TOP 
> control, it would be better to add it at struct v4l2_tuner 
> (VIDIOC_G_TUNER and VIDIOC_S_TUNER), instead 
> of adding it as a control.

Good idea. 

For MK3 need control AGC TOP and TOP of TDA9887
For MK5 need control only TOP of TDA9887

With my best regards, Dmitry.

> > 
> > 3.: That is what Andy noted. Following the Philips datasheet for
> > TOP, it should be added for negative modulation, positive
> > modulation and FM accordingly. (2 and 3 are out of discussion)
> > 
> > If you still have some sort of Secam fire and can improve it, we
> > must know the tuner you are on "exactly". If it is the original
> > Philips, without any such TOP suggestions over the full range in
> > recent datasheets (???), I assume you might have them, I would say
> > you can proceed, if you have shown that you are really still on the
> > same tuner.
> > 
> > Cheers,
> > Hermann
> > 
> > 
> > 
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-media" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
