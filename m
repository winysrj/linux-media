Return-path: <linux-media-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:40311 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZINVja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 17:39:30 -0400
Date: Mon, 14 Sep 2009 23:39:33 +0200
From: Andreas Mohr <andi@lisas.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: V4L2 drivers: potentially dangerous and inefficient
	msecs_to_jiffies() calculation
Message-ID: <20090914213933.GA5468@rhlx01.hs-esslingen.de>
References: <20090914210741.GA16799@rhlx01.hs-esslingen.de> <4AAEB6F0.4080706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAEB6F0.4080706@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Sep 14, 2009 at 11:34:40PM +0200, Jiri Slaby wrote:
> On 09/14/2009 11:07 PM, Andreas Mohr wrote:
> > ./drivers/media/video/zc0301/zc0301_core.c
> > do
> >                             cam->module_param.frame_timeout *
> >                             1000 * msecs_to_jiffies(1) );
> > multiple times each.
> > What they should do instead is
> > frame_timeout * msecs_to_jiffies(1000), I'd think.
> 
> In fact, msecs_to_jiffies(frame_timeout * 1000) makes much more sense.

Heh, right, even a bit better ;)

> > msecs_to_jiffies(1) is quite a bit too boldly assuming
> > that all of the msecs_to_jiffies(x) implementation branches
> > always round up.
> 
> They do, don't they?

I'd hope so, but a slight risk remains, you never know,
especially with 4+ or so variants...

Andreas Mohr
