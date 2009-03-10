Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:40373 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZCJSdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 14:33:06 -0400
Date: Tue, 10 Mar 2009 11:33:02 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
In-Reply-To: <874oy2tsph.fsf@free.fr>
Message-ID: <Pine.LNX.4.58.0903101131380.28292@shell2.speakeasy.net>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903080115090.6783@axis700.grange> <874oy2tsph.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 9 Mar 2009, Robert Jarzmik wrote:
> > Ok, this one will change I presume - new alignment calculations and
> > line-breaking. In fact, if you adjust width and height earlier in set_fmt,
> > maybe you'll just remove any rounding here completely.
> Helas, not fully.
> The problem is with passthrough and rgb formats, where I don't enforce
> width/height. In the newest form of the patch I have this :
> 	if (pcdev->channels == 3)
> 		*size = icd->width * icd->height * 2;
> 	else
> 		*size = roundup(icd->width * icd->height *
> 				((icd->current_fmt->depth + 7) >> 3), 8);

If icd->current_fmt->depth could be set to 16 for planar formats, then you
could get rid of the special case here.
