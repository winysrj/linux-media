Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46885 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbeJVAcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Oct 2018 20:32:06 -0400
Date: Sun, 21 Oct 2018 18:17:14 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
Message-ID: <20181021161714.s3wcfwluvvldcbg6@pengutronix.de>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2018 at 02:14:07PM -0400, Nicolas Dufresne wrote:
> > Do we have more ioctls that could use a refresh? S/G/TRY_FMT perhaps, again in
> > order to improve single vs multiplanar handling.
> 
> Yes, but that would fall in a complete redesign I guess. The buffer
> allocation scheme is very inflexible. You can't have buffers of two
> dimensions allocated at the same time for the same queue. Worst, you
> cannot leave even 1 buffer as your scannout buffer while reallocating
> new buffers, this is not permitted by the framework (in software). As a
> side effect, there is no way to optimize the resolution changes, you
> even have to copy your scannout buffer on the CPU, to free it in order
> to proceed. Resolution changes are thus painfully slow, by design.

I've seen the same issue when exporting dmabufs from a V4L2 decoder and
importing them into OpenGL textures. Mesa caches state so aggressively,
even destroying all textures and flushing OpenGL is not enough to remove
all references to the imported resource. Only after another render step
the dmabuf fds are closed and thus make REQBUFS 0 possible on the
exporting capture queue.
This leads to a catch-22 situation during a resolution change, because
we'd already need the new buffers to do an OpenGL render without the old
buffers, so that the old buffers can be released back to V4L2, so that
V4L2 can allocate the new buffers...
It would be very helpful in this situation if exported dmabufs could
just be orphaned by REQBUFS 0.

regards
Philipp
