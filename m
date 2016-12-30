Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54133 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753958AbcL3NEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Dec 2016 08:04:45 -0500
Date: Fri, 30 Dec 2016 14:04:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3 4/4] uvcvideo: add a metadata device node
In-Reply-To: <3119423.ZqlLJHYUgu@avalon>
Message-ID: <Pine.LNX.4.64.1612301401360.9905@axis700.grange>
References: <1481541412-1186-1-git-send-email-guennadi.liakhovetski@intel.com>
 <1481541412-1186-5-git-send-email-guennadi.liakhovetski@intel.com>
 <Pine.LNX.4.64.1612300938110.9905@axis700.grange> <3119423.ZqlLJHYUgu@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Dec 2016, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Friday 30 Dec 2016 11:43:02 Guennadi Liakhovetski wrote:
> > Hi Laurent,
> > 
> > I'd like to discuss extending this patch a bit, preferably as an
> > incremental patch.
> > 
> > First let me confirm my current understanding of the way the UVC driver
> > creates its media device topology. Do I understand it correctly, that the
> > driver allocates UVC entities (not media controller entities) for all UVC
> > units and terminals, but then uses subdevices for all such UVC entities,
> > except terminals, i.e. only for UVC units? struct uvc_entity has an
> > embedded struct v4l2_subdev object, but it's unused for UVC terminals.
> > Instead terminals are associated to video devices, which are then linked
> > into the MC topology? Is this my understanding correct?
> 
> That's correct, but looking at the code now, I think the driver should use a 
> struct media_entity directly instead of a struct v4l2_subdev as it doesn't 
> need any of the infrastructure provided by subdevs.
> 
> > I have a problem with the current version of this patch, that there is no
> > way to associate video device nodes with respepctive metadata nodes. Would
> > it be acceptable to use an MC link for this association?
> 
> No, links describe data connections.

Well, it is data - it's metadata, extracted from USB buffers.

> > Is it allowed for video device MC entities to have source pads additionally
> > to their (usually single) sink pad(s) (in case of input video devices)? If
> > that would be acceptable, I could create an additional patch to add a source
> > pad to output terminal video nodes to link it to metadata nodes.
> 
> That's a hack, I don't think it's a good idea.

Ok, would a completely specialised one-off sysfs solution be better? Maybe 
a link under the metadata node to the main node?

Thanks
Guennadi
