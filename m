Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:54809 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965184AbcAZPAP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 10:00:15 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: Support Intersil/Techwell TW686x-based video capture cards
References: <1451183213-2733-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<569CE27F.6090702@xs4all.nl>
	<CAAEAJfCs1fipSadLj8WyxiJd9g7MCJj1KX5UdAPx1hPt16t0VA@mail.gmail.com>
	<m31t96j8u4.fsf@t19.piap.pl>
	<CAAEAJfBM_vVBVRd3P0kJ1QLzk-M==L=x6CS0ggXgRX=7K_aK_A@mail.gmail.com>
	<m3si1kioa9.fsf@t19.piap.pl>
	<CAAEAJfC_Sa_6opADoz0Ab8NrmhX+cjNmSK_Nw_Ne9nk-ROaj0Q@mail.gmail.com>
Date: Tue, 26 Jan 2016 16:00:11 +0100
In-Reply-To: <CAAEAJfC_Sa_6opADoz0Ab8NrmhX+cjNmSK_Nw_Ne9nk-ROaj0Q@mail.gmail.com>
	(Ezequiel Garcia's message of "Tue, 26 Jan 2016 09:35:27 -0300")
Message-ID: <m3io2gfksk.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> writes:

> I reviewed the driver as soon as it was sent, and planned to submit
> changes to support my setup once your driver was merged, but that
> never happened.

This was because you, shortly thereafter, stated:

> I'm working on an improved version of the tw686x driver. I've started
> with the patches
> you posted and made a significant number of changes:

> * Handling events in the top-half (removed bottom halves).
> * Audio support
> * Added CIF and D1 size support
> * some other goodies
> * a lot of code refactoring

> I'm now working on supporting both S-G and frame modes,
> so the driver will support INTERLACED and SEQ frames, and the
> user will have both options.

> I'll post a patchset as soon as it's working. Since I've started with
> your patch,
> your authorship will be retained and I'll add only my Signed-off-by.

And, when I asked about merging the combined work properly:

> Problem is I've re-written the driver, taking yours as a starting point
> and reference.

> In other words, I don't have a proper git branch with a history, starting
> from the patch you submitted. Instead, I would be submitting a new
> patch for Hans and Mauro to review.

> This patch is based in yours, so AFAIK should have your signature.

The latter was obviously not true - the code may retain the original
authors and copyrights (if it hasn't been rewritten completely), but
you have to remove the original S-O-B when you are submitting heavily
modified code - see the rules. Signature is not copyright/authorship,
it's who posts the code.


This is also why separating the work helps (especially in such
non-trivial cases) - the original code bears the original signature,
and the subsequent changes have their own. These things are invented
for a reason.


I really thought you have rewritten the driver from scratch, so my
inferior driver was of no use. In this situation submitting v2 didn't
make sense, though obviously I haven't written a driver for nothing -
I'm using it for my purposes.


What other options did I have at that time?

> If you want your driver merged, then you would have to submit it
> again, addressing
> my review comments.

Well, then this is something I can do. I wonder if it would be better
to post the raw code as a single patch, or to repost the original
version (already reviewed) and the subsequent patches (much smaller)
instead. Hans?

> However, I have just posted a v2 and it would be nice if
> you can review it and test it.

I can review it, however I can't really test it, because my ARM-based
systems require DMA to buffer functionality. Also, please not I'm not
a V4L2 expert, though I have a bit of experience with low level hw.


However, it would be much easier if you had posted an incremental patch
set instead. Also, WRT the merging, since this turns out to be in fact
my driver with your subsequent modifications (most of them very
valuable, I'm sure), I'd really think we should merge the original
driver first, and add the modifications, perhaps one-by-one, next.


This doesn't mean it has to wait. I can even do it all myself, simply
send your patches against my code and I'll merge them properly in my git
tree once they are positively reviewed. Hans could then merge it all
easily.


Does this make any sense?

Thanks in advance.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
