Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50007 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2GFMi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 08:38:57 -0400
Date: Fri, 6 Jul 2012 14:38:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	fabio.estevam@freescale.com, mchehab@infradead.org,
	kernel@pengutronix.de
Subject: Re: [PATCH v3][for_v3.5] media: mx2_camera: Fix mbus format handling
In-Reply-To: <CACKLOr1RKcwEqt9E90wbf5peB08erb7nOo+KVQ7m87BbsDJhbA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1207061437470.29809@axis700.grange>
References: <1338543105-20322-1-git-send-email-javier.martin@vista-silicon.com>
 <CACKLOr0J1JjpCMRf4toJ5uBMDAFZT8VGdFuX6MpUpxpNaAO_SA@mail.gmail.com>
 <Pine.LNX.4.64.1207061308300.29809@axis700.grange>
 <CACKLOr0nwKoO4UL9MKZJmD9WN1uyJhpNzAybd7w7x-GnLtM5cw@mail.gmail.com>
 <Pine.LNX.4.64.1207061338170.29809@axis700.grange>
 <CACKLOr1RKcwEqt9E90wbf5peB08erb7nOo+KVQ7m87BbsDJhbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Jul 2012, javier Martin wrote:

> Hi Guennadi,
> 
> On 6 July 2012 13:39, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > On Fri, 6 Jul 2012, javier Martin wrote:
> >
> >> Hi Guennadi,
> >>
> >> On 6 July 2012 13:09, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> >> > On Fri, 6 Jul 2012, javier Martin wrote:
> >> >
> >> >> Hi,
> >> >> can this patch be applied please?
> >> >>
> >> >> It solves a BUG for 3.5. Guennadi, Fabio, could you give me an ack for this?
> >> >
> >> > Sorry? This patch has been applied and proven to break more, than it
> >> > fixed, so, it has been reverted. Am I missing something?
> >>
> >> Patch v1 was the version that broke pass-through mode (which nobody
> >> seems to be using/testing). It was applied, then it was reverted as
> >> you requested in [1].
> >>
> >> Then I sent v2 that didn't break pass-through but was invalid too
> >> because of a merge conflict [2].
> >>
> >> Finally, this is v3 which has the pass-through problem and the merge
> >> problem fixed. It is currently marked as "Under review" and should be
> >> applied as a fix to 3.5.
> >
> > Ah, ok, then, don't you think, that expecting your patch to be applied
> > within 4 minutes of its submission is a bit... overoptimistic? Because
> > it's 4 minutes after your original patch, that you've sent your
> > "reminder"...
> 
> This patch was sent on '2012-06-01 09:31:45', which is more than a
> month ago. Look at patchwork:
> http://patchwork.linuxtv.org/patch/11559/
> 
> I think that a month is a reasonable period to send a reminder and I
> didn't mean to offend anyone with it.

Hrm, right, sorry. Must have been blind. I've looked at v3 of your patch, 
I've got one more question to it, expect a reply in a few minutes.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
