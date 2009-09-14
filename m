Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:46699 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117AbZINVrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 17:47:20 -0400
Date: Mon, 14 Sep 2009 14:47:22 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andreas Mohr <andi@lisas.de>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: V4L2 drivers: potentially dangerous and inefficient	msecs_to_jiffies()
 calculation
In-Reply-To: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
Message-ID: <Pine.LNX.4.58.0909141443090.17485@shell2.speakeasy.net>
References: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Sep 2009, Andreas Mohr wrote:
>                             cam->module_param.frame_timeout *
>                             1000 * msecs_to_jiffies(1) );
> multiple times each.
> What they should do instead is
> frame_timeout * msecs_to_jiffies(1000), I'd think.
> msecs_to_jiffies(1) is quite a bit too boldly assuming
> that all of the msecs_to_jiffies(x) implementation branches
> always round up.

It might also wait far longer than desired.  On a 100 Hz kernel a jiffie is
10 ms.  1000 * msecs_to_jiffies(1) will wait 10 seconds instead of 1.

But, I believe there is an issue with msecs_to_jiffies(x) overflowing for
very high values of x.  I'm not sure where that point is though.
