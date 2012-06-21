Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55943 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab2FUIqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 04:46:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jesse Barker <jesse.barker@linaro.org>
Cc: linux-fbdev@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [RFC/PATCH] fb: Add dma-buf support
Date: Thu, 21 Jun 2012 10:46:15 +0200
Message-ID: <2493661.GRYQti1C6z@avalon>
In-Reply-To: <CAC57bwtvfYDGO91r3zRry+WENm7x=UZ6TdOkXpmHDbQWT0feRA@mail.gmail.com>
References: <1340201368-20751-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAC57bwtvfYDGO91r3zRry+WENm7x=UZ6TdOkXpmHDbQWT0feRA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jesse,

Thank you for the review.

On Wednesday 20 June 2012 08:09:19 Jesse Barker wrote:
> Laurent,
> 
> Your recent documentation efforts are extremely commendable.  Just a
> couple of small nits below...
> 
> On Wed, Jun 20, 2012 at 7:09 AM, Laurent Pinchart
> 
> <laurent.pinchart@ideasonboard.com> wrote:
> > Add support for the dma-buf exporter role to the frame buffer API. The
> > importer role isn't meaningful for frame buffer devices, as the frame
> > buffer device model doesn't allow using externally allocated memory.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  Documentation/fb/api.txt |   36 ++++++++++++++++++++++++++++++++++++
> >  drivers/video/fbmem.c    |   36 ++++++++++++++++++++++++++++++++++++
> >  include/linux/fb.h       |   12 ++++++++++++
> >  3 files changed, 84 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/fb/api.txt b/Documentation/fb/api.txt
> > index d4ff7de..f0b2173 100644
> > --- a/Documentation/fb/api.txt
> > +++ b/Documentation/fb/api.txt
> > @@ -304,3 +304,39 @@ extensions.
> >  Upon successful format configuration, drivers update the
> > fb_fix_screeninfo
> >  type, visual and line_length fields depending on the selected format. The
> > type and visual fields are set to FB_TYPE_FOURCC and FB_VISUAL_FOURCC
> > respectively. +
> > +
> > +5. DMA buffer sharing
> > +---------------------
> > +
> > +The dma-buf kernel framework allows DMA buffers to be shared across
> > devices +and applications. Sharing buffers across display devices and
> > video capture or +video decoding devices allow zero-copy operation when
> > displaying video content +produced by a hardware device such as a camera
> > or a hardware codec. This is +crucial to achieve optimal system
> > performances during video display. +
> > +While dma-buf supports both exporting internally allocated memory as a
> > dma-buf +object (known as the exporter role) and importing a dma-buf
> > object to be used +as device memory (known as the importer role), the
> > frame buffer API only +supports the exporter role, as the frame buffer
> > device model doesn't support +using externally-allocated memory.
> > +
> > +The export a frame buffer as a dma-buf file descriptors, applications
> > call the
> s/The/To
> s/descriptors/descriptor

Fixed, thanks.

-- 
Regards,

Laurent Pinchart

