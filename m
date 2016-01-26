Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:47210 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbcAZLQd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 06:16:33 -0500
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
Date: Tue, 26 Jan 2016 12:16:30 +0100
In-Reply-To: <CAAEAJfBM_vVBVRd3P0kJ1QLzk-M==L=x6CS0ggXgRX=7K_aK_A@mail.gmail.com>
	(Ezequiel Garcia's message of "Mon, 25 Jan 2016 09:03:12 -0300")
Message-ID: <m3si1kioa9.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> writes:

> Well, I plan to add SG mode as soon as this driver is merged, so hopefully you
> won't have to use an out of tree driver anymore.

So why don't you want to do it the normal way, i.e., add your specific
changes on top of my driver?

This way you don't have to add SG mode. It's already there. Also, this
means I (and others) don't have to hope. And, your changes can be much
better examined, bisected etc.

For now, there is no in-tree driver, all versions are out of tree.

At the moment, from my POV it all looks this way:
- I have written a driver and posted it for inclusion
- it works on my systems, complies with the LK, V4L standards etc.,
  though it probably still needs some small changes
- you took it, (I guess) added the needed changes (and others), removed
  the critical functionality, and want it merged instead of the
  original, working version.

I can only see two ways out (which make sense) from this. The first is:
we add my driver first and then your specific changes on top of it.

The other one: I add required changes (e.g. the one that sets default
mode on start, or something alike, I don't remember exactly) and then we
add the driver. Then I'll also add the non-SG CMA DMA frame and field
mode (DMA to buffers), since it seems I will need it (and it was a bit
overlooked).
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
