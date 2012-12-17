Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:65195 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2LQLsh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 06:48:37 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MF600BD9BK3MG90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Dec 2012 11:51:11 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MF600BSEBGQPP90@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Dec 2012 11:48:34 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>
Cc: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <20121115220627.GB29863@valkosipuli.retiisi.org.uk>
 <1353017207-370-4-git-send-email-sakari.ailus@iki.fi>
 <201211161455.20781.hverkuil@xs4all.nl>
 <000101cddc48$6fe977e0$4fbc67a0$%debski@samsung.com>
 <20121217113447.GE4738@valkosipuli.retiisi.org.uk>
In-reply-to: <20121217113447.GE4738@valkosipuli.retiisi.org.uk>
Subject: RE: [PATCH 4/4] v4l: Tell user space we're using monotonic timestamps
Date: Mon, 17 Dec 2012 12:48:25 +0100
Message-id: <000201cddc4c$6cf1e5f0$46d5b1d0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: 'Sakari Ailus' [mailto:sakari.ailus@iki.fi]
> Sent: Monday, December 17, 2012 12:35 PM
> Subject: Re: [PATCH 4/4] v4l: Tell user space we're using monotonic
> timestamps
> 
> Hi Kamil,
> 
> On Mon, Dec 17, 2012 at 12:19:51PM +0100, Kamil Debski wrote:
> ...
> > > > @@ -367,7 +368,8 @@ static void __fill_v4l2_buffer(struct
> > > > vb2_buffer
> > > *vb, struct v4l2_buffer *b)
> > > >  	/*
> > > >  	 * Clear any buffer state related flags.
> > > >  	 */
> > > > -	b->flags &= ~V4L2_BUFFER_STATE_FLAGS;
> > > > +	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
> > > > +	b->flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> >
> > As far as I know, after __fill_v4l2_buffer is run driver has no means
> > to change flags. Right?
> 
> Correct. Querybuf, for example, is implemented in vb2 and no driver
> involvement is required. And we sure don't want to add it. ;)

I did not suggest that it should be added.

> 
> > So how should a driver, which is not using the MONOTONIC timestamps
> > inform the user space about it?
> 
> We currently support only monotonic timestamps. Support for different
> kind of timestamps should be added to videobuf2 when they are needed.
> The drivers would then be using a videobuf2 equivalent of
> v4l2_get_timestamp().

Just as I though.
Mind you - v4l2_get_timestamp() does not apply if the timestamp are simply
copied.
This is the case of some of the mem2mem devices, remember?

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


