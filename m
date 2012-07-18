Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:19290 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2GROnw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 10:43:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v4] media: coda: Add driver for Coda video codec.
Date: Wed, 18 Jul 2012 16:43:26 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	rob.herring@calxeda.com, grant.likely@secretlab.ca,
	mchehab@infradead.org
References: <1342606895-9028-1-git-send-email-javier.martin@vista-silicon.com> <CACKLOr1L0Z1L8cfX3AVnJacERWHq4YTtWxLebfJY3bhFj-bF0A@mail.gmail.com> <201207181510.41214.hverkuil@xs4all.nl>
In-Reply-To: <201207181510.41214.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207181643.26543.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 18 July 2012 15:10:41 Hans Verkuil wrote:
> On Wed 18 July 2012 14:42:00 javier Martin wrote:
> > Hi Hans,
> > thank you for your review.
> > 
> > On 18 July 2012 13:00, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> <snip>
> 
> > >
> > > Colorspace.
> > 
> > But I don't know how to handle colorspace in this driver. Video
> > encoder from samsung
> > (http://lxr.linux.no/#linux+v3.4.5/drivers/media/video/s5p-mfc/s5p_mfc_enc.c#L844
> > ) does not handle it either.
> 
> That's wrong too :-)
> 
> > This is a video encoder which gets an input video streaming (with its
> > specific colorspace) and encodes it. I understand the sense of this
> > field for a video source but for an encoder?
> 
> An encoder should copy the colorspace of the video it receives to the output
> video format and default to V4L2_COLORSPACE_SMPTE170M (SDTV) or
> V4L2_COLORSPACE_REC709 (HDTV).
> 
> So as long as userspace hasn't told the driver what the colorspace is of the
> video it will encode you can return a default colorspace. Once you know the
> actual colorspace, then that's what should be returned.
> 
> This assumes that the encoder doesn't do any colorspace changes and just encodes
> as is.

Look at my patches for mem2mem_testdev that are here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/m2m

I think that the way I handle colorspace there is quite reasonable. Note that I
just used V4L2_COLORSPACE_REC709 as the default. I think it is unnecessary to
make a distinction between SDTV and HDTV colorspace.

Note that I need to do a bit more work on v4l2-compliance so that it recognizes
and correctly handles mem2mem devices. Some of the tests do not work correctly
at the moment for such devices.

Regards,

	Hans
