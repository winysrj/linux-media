Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:52549 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbZIMUpu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 16:45:50 -0400
Date: Sun, 13 Sep 2009 22:45:51 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/8] drivers/media/video/uvc: introduce missing kfree
In-Reply-To: <200909132239.21806.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.0909132245220.31000@ask.diku.dk>
References: <Pine.LNX.4.64.0909111821010.10552@pc-004.diku.dk>
 <200909132239.21806.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > -	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) && query == UVC_GET_DEF)
> > -		return -EIO;
> > +	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
> > +			query == UVC_GET_DEF) {
> > +		ret = -EIO;
> > +		goto out;
> > +	}
> 
> This check can be moved before kmalloc(), removing the need to free memory in 
> case of error.
> 
> Julia, do you want to submit a modified patch or should I do it myself ?

I can do it.  I will send a revised patch shortly.

julia
