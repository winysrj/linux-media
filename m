Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56463 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678AbcAYQQM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 11:16:12 -0500
Date: Mon, 25 Jan 2016 17:15:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2] V4L: add Y12I, Y8I and Z16 pixel format documentation
In-Reply-To: <569E37E6.9080802@linux.intel.com>
Message-ID: <Pine.LNX.4.64.1601251706240.20896@axis700.grange>
References: <Pine.LNX.4.64.1601181336520.9140@axis700.grange>
 <569E37E6.9080802@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tue, 19 Jan 2016, Sakari Ailus wrote:

> Hi Guennadi,
> 
> Guennadi Liakhovetski wrote:
> > Add documentation for 3 formats, used by RealSense cameras like R200.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---

[snip]

> > +    <para>This is a 16-bit format, representing depth data. Each pixel is a
> > +distance to the respective point in the image coordinates. Distance unit can
> > +vary and has to be negotiated with the device separately. Each pixel is stored
> > +in a 16-bit word in the little endian byte order.
> 
> I think we really need a way to convey the unit (and prefix) information
> to the user. Considering the same should be done to controls, it'd be
> logical to do that at the same time with the controls.

Do I understand you correctly, that you'd like to add a control to specify 
distance units for this format? If yes - I don't think you want a separate 
control just for this format, right? And you mention, you also want to be 
able to specify units for other controls. But I would've thought, that 
controls themselves should define, what unit they are using. E.g. 
V4L2_CID_EXPOSURE_ABSOLUTE specifies, that it's unit is 100us. I would 
expect the same from other controls too. "Legacy" controls like 
V4L2_CID_EXPOSURE don't specify units, so, I would expect, that their use 
should be discouraged.

> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> I'd like to have Hans's and/or Laurent's ack on this as well.
> 
> Unless the original patch requires changes, it could be re-applied if no
> changes are requested to it. My understanding is that the issue mainly
> was the missing documentation, i.e. this patch.

Yes, I'll repost both patches as a series, maybe let's try to get some 
understanding on the units question first.

Thanks
Guennadi
