Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50417 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeJWV0U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 17:26:20 -0400
Date: Tue, 23 Oct 2018 15:02:54 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Tomasz Figa <tfiga@chromium.org>
Cc: nicolas@ndufresne.ca, Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
Message-ID: <20181023130254.t27fp7gh6gp5uqk4@pengutronix.de>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
 <CAAFQd5BsvtqM3QriFd5vo55ZDKxFcnGAR21Y7ch247jXX6-iQg@mail.gmail.com>
 <20181021162843.ys6eqbbyg5w5ufrv@pengutronix.de>
 <CAAFQd5A3a1o55pcV6Kn5ZWXQFYJvuv4y1+oD4=PEZXoYMhrX0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5A3a1o55pcV6Kn5ZWXQFYJvuv4y1+oD4=PEZXoYMhrX0Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Mon, Oct 22, 2018 at 12:37:57PM +0900, Tomasz Figa wrote:
[...]
> On Mon, Oct 22, 2018 at 1:28 AM Philipp Zabel <pza@pengutronix.de> wrote:
[...]
> > REQBUFS 0 fails if the vb2 buffer is still in use, including from dmabuf
> > attachments: vb2_buffer_in_use checks the num_users memop. The refcount
> > returned by num_users shared between the vmarea handler and dmabuf ops,
> > so any dmabuf attachment counts towards in_use.
> 
> Ah, right. I've managed to completely forget about it, since we have a
> downstream patch that we attempted to upstream earlier [1], but didn't
> have a chance to follow up on the comments and there wasn't much
> interest in it in general.
> 
> [1] https://lore.kernel.org/patchwork/patch/607853/
> 
> Perhaps it would be worth reviving?

Yes, thanks for the pointer. I've completely missed that patch.

I was under the mistaken impression that there was some technical reason
to keep the queue around until after the last dmabuf attachment is gone,
but everything is properly refcounted.

regards
Philipp
