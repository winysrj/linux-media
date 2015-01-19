Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51889 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbbASOZn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 09:25:43 -0500
Date: Mon, 19 Jan 2015 15:25:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: Ben Hutchings <ben.hutchings@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@codethink.co.uk,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 5/5] media: rcar_vin: move buffer management to
 .stop_streaming handler
In-Reply-To: <alpine.DEB.2.02.1501191404570.4586@xk120>
Message-ID: <Pine.LNX.4.64.1501191522190.27578@axis700.grange>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
 <1418914215.22813.18.camel@xylophone.i.decadent.org.uk>
 <Pine.LNX.4.64.1501182141400.23540@axis700.grange>
 <1421664620.1222.207.camel@xylophone.i.decadent.org.uk>
 <Pine.LNX.4.64.1501191208490.27578@axis700.grange> <alpine.DEB.2.02.1501191404570.4586@xk120>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, 19 Jan 2015, William Towle wrote:

> 
> On Mon, 19 Jan 2015, Guennadi Liakhovetski wrote:
> 
> > > > On Thu, 18 Dec 2014, Ben Hutchings wrote:
> > > Well, I thought that too.  Will's submission from last week has that
> > > change:
> > > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/87009
> 
> > Anyway, yes, that looks better! But I would still consider keeping buffers
> > on the list in .buf_clean(), in which case you can remove it. And walk the
> > list instead of the VB2 internal buffer array, as others have pointed out.
> 
> Hi Guennadi,
>   Thanks for the clarification. Ian (when he was with us) did say "it
> was particularly difficult to understand WTH this driver was doing".
> 
>   Regarding your first point, if it's safe to skip the actions left
> in rcar_vin_videobuf_release() then I will do a further rework to
> remove it completely.
> 
>   Regarding your second, in the patchset Ben linked to above we think
> we have the appropriate loops: a for loop for queue_buf[], and
> list_for_each_safe() for anything left in priv->capture; this is
> consistent with rcar_vin_fill_hw_slot() setting up queue_buf[] with
> pointers unlinked from priv->capture. This in turn suggests that we
> are right not to call list_del_init() in both of
> rcar_vin_stop_streaming()'s loops ... as long as I've correctly
> interpreted the code and everyone's feedback thus far.

I'm referring to this comment by Hans Verkuil of 14 August last year:

> I'm assuming all buffers that are queued to the driver via buf_queue() are
> linked into priv->capture. So you would typically call vb2_buffer_done
> when you are walking that list:
> 
> 	list_for_each_safe(buf_head, tmp, &priv->capture) {
> 		// usually you go from buf_head to the real buffer struct
> 		// containing a vb2_buffer struct
> 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> 		list_del_init(buf_head);
> 	}
> 
> Please use this rather than looking into internal vb2_queue 
> datastructures.

I think, that's the right way to implement that clean up loop.

Thanks
Guennadi
