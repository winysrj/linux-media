Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40913 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab2IXN6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 09:58:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, a.hajda@samsung.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [PATCH RFC] V4L: Add s_rx_buffer subdev video operation
Date: Mon, 24 Sep 2012 15:58:44 +0200
Message-ID: <8816374.onnX7s7R5d@avalon>
In-Reply-To: <20120924134453.GH12025@valkosipuli.retiisi.org.uk>
References: <1348493213-32278-1-git-send-email-s.nawrocki@samsung.com> <20120924134453.GH12025@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 24 September 2012 16:44:54 Sakari Ailus wrote:
> On Mon, Sep 24, 2012 at 03:26:53PM +0200, Sylwester Nawrocki wrote:
> > The s_rx_buffer callback allows the host to set buffer for non-image
> > (meta) data at a subdev. This callback can be implemented by an image
> > sensor or a MIPI-CSI receiver, allowing the host to retrieve the frame
> > embedded data from a subdev.
> > 
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > 
> >  include/media/v4l2-subdev.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 22ab09e..28067ed 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -274,6 +274,10 @@ struct v4l2_subdev_audio_ops {
> > 
> >     s_mbus_config: set a certain mediabus configuration. This operation is
> >     added>  	
> >  	for compatibility with soc-camera drivers and should not be used by 
new
> >  	software.
> > 
> > +
> > +   s_rx_buffer: set a host allocated memory buffer for the subdev. The
> > subdev +	can adjust @size to a lower value and must not write more data
> > to the +	buffer starting at @data than the original value of @size.
> > 
> >   */
> >  
> >  struct v4l2_subdev_video_ops {
> >  
> >  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32
> >  	config);> 
> > @@ -327,6 +331,8 @@ struct v4l2_subdev_video_ops {
> > 
> >  			     struct v4l2_mbus_config *cfg);
> >  	
> >  	int (*s_mbus_config)(struct v4l2_subdev *sd,
> >  	
> >  			     const struct v4l2_mbus_config *cfg);
> > 
> > +	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
> > +			   unsigned int *size);
> > 
> >  };
> >  
> >  /*
> 
> How about useing a separate video buffer queue for the purpose? That would
> provide a nice way to pass it to the user space where it's needed. It'd also
> play nicely together with the frame layout descriptors.

Beside, a void *buf wouldn't support DMA. Only subdevs that use PIO to 
transfer meta data could be supported by this.

-- 
Regards,

Laurent Pinchart

