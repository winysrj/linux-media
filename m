Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51073 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727763AbeJVAng (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Oct 2018 20:43:36 -0400
Date: Sun, 21 Oct 2018 18:28:43 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Tomasz Figa <tfiga@chromium.org>
Cc: nicolas@ndufresne.ca, Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
Message-ID: <20181021162843.ys6eqbbyg5w5ufrv@pengutronix.de>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
 <CAAFQd5BsvtqM3QriFd5vo55ZDKxFcnGAR21Y7ch247jXX6-iQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5BsvtqM3QriFd5vo55ZDKxFcnGAR21Y7ch247jXX6-iQg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 03, 2018 at 05:24:39PM +0900, Tomasz Figa wrote:
[...]
> > Yes, but that would fall in a complete redesign I guess. The buffer
> > allocation scheme is very inflexible. You can't have buffers of two
> > dimensions allocated at the same time for the same queue. Worst, you
> > cannot leave even 1 buffer as your scannout buffer while reallocating
> > new buffers, this is not permitted by the framework (in software). As a
> > side effect, there is no way to optimize the resolution changes, you
> > even have to copy your scannout buffer on the CPU, to free it in order
> > to proceed. Resolution changes are thus painfully slow, by design.
[...]
> Also, I fail to understand the scanout issue. If one exports a vb2
> buffer to a DMA-buf and import it to the scanout engine, it can keep
> scanning out from it as long as it want, because the DMA-buf will hold
> a reference on the buffer, even if it's removed from the vb2 queue.

REQBUFS 0 fails if the vb2 buffer is still in use, including from dmabuf
attachments: vb2_buffer_in_use checks the num_users memop. The refcount
returned by num_users shared between the vmarea handler and dmabuf ops,
so any dmabuf attachment counts towards in_use.

regards
Philipp
