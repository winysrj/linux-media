Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49223 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751117AbdKIHho (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Nov 2017 02:37:44 -0500
Date: Thu, 9 Nov 2017 08:37:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6 v5] V4L: Add a UVC Metadata format
In-Reply-To: <1861262.E5lR5RDANx@avalon>
Message-ID: <alpine.DEB.2.20.1711090834220.23569@axis700.grange>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de> <17991420.GWclfaas9a@avalon> <alpine.DEB.2.20.1711081126370.20370@axis700.grange> <1861262.E5lR5RDANx@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, 9 Nov 2017, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Wednesday, 8 November 2017 12:43:46 EET Guennadi Liakhovetski wrote:

[snip]

> > To recall the metadata buffer layout should be
> > 
> > struct uvc_meta_buf {
> > 	uint64_t ns;
> > 	uint16_t sof;
> > 	uint8_t length;
> > 	uint8_t flags;
> > 	uint8_t buf[];
> > } __attribute__((packed));
> > 
> > where all the fields, beginning with "length" are a direct copy from the
> > UVC payload header. If multiple such payload headers have arrived for a
> > single frame, they will be appended and .bytesused will as usually have
> > the total byte count, used up in this frame. An application would then
> > calculate lengths of those individual metadata blocks as
> > 
> > sizeof(.ns) + sizeof(.sof) + .length
> > 
> > But this won't work with the "standard" UVC metadata format where any
> > private data, following standard fields, are dropped. In that case
> > applications would have to look at .flags and calculate the block length
> > based on them. Another possibility would be to rewrite the .length field
> > in the driver to only include standard fields, but I really don't think
> > that would be a good idea.
> 
> For the standard header the length can indeed be easily computed from the 
> flags. I wonder, however, why you think rewriting length would be a bad idea ?

Because I like the guarantee of the least intrusion. We (so far) 
guarantee, that the buffer contents beyond the system and the USB 
timestamps are a direct unmodified copy from the camera. This seems to be 
a good principle to stick to.

Thanks
Guennadi
