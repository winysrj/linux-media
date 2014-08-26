Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34583 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934092AbaHZJNr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 05:13:47 -0400
Message-ID: <1409044417.2911.29.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC] [media] v4l2: add V4L2 pixel format array and helper
 functions
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date: Tue, 26 Aug 2014 11:13:37 +0200
In-Reply-To: <3263560.xPJs935yYQ@avalon>
References: <1408962839-25165-1-git-send-email-p.zabel@pengutronix.de>
	 <1794623.zNambAqeEh@avalon>
	 <1408981277.3191.80.camel@paszta.hi.pengutronix.de>
	 <3263560.xPJs935yYQ@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Montag, den 25.08.2014, 17:47 +0200 schrieb Laurent Pinchart:
> > Yes, I think this is slightly over the edge. Is room for a function to
> > accompany the preexisting v4l2_fill_pix_format (say,
> > v4l2_fill_pix_format_size) to set both the bytesperline and sizeimage
> > values in a struct v4l2_pix_format?
> 
> That sounds sensible to me, provided it would be used by drivers of course. I 
> wouldn't remove v4l2_bytesperline() and v4l2_sizeimage(), as the values might 
> be needed by drivers in places where a v4l2_pix_format structure isn't 
> available.

I think about four of the drivers I've looked at so far could use such a
function, but it probably won't be useful for the majority.

> > Also, is anybody bothered by the v4l2_pix_format / v4l2_pixfmt
> > similarity in name?
> 
> How about renaming v4l2_pixfmt to v4l2_pix_format_info ?

Thanks, but v4l2_pix_format is a userspace API structure. I fear
renaming v4l2_pixfmt to v4l2_pix_format_anything would rather strengthen
that association, while I'd like to achieve the opposite.

regards
Philipp

