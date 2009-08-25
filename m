Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60866 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756154AbZHYTxy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 15:53:54 -0400
Date: Tue, 25 Aug 2009 21:53:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] v4l: add new v4l2-subdev sensor operations, use
 skip_top_lines in soc-camera
In-Reply-To: <200908252147.49843.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.0908252153080.4810@axis700.grange>
References: <Pine.LNX.4.64.0908251855160.4810@axis700.grange>
 <A24693684029E5489D1D202277BE89444BC96E38@dlee02.ent.ti.com>
 <200908252117.45230.hverkuil@xs4all.nl> <200908252147.49843.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 25 Aug 2009, Laurent Pinchart wrote:

> On Tuesday 25 August 2009 21:17:45 Hans Verkuil wrote:
> >
> > This has nothing to do with a valid region. No matter what region you
> > capture, the first X lines will always be corrupt for some sensors.
> > Something that clearly needs to be clarified in the comments.
> 
> Could such sensors corrupt the bottom Y lines too, and maybe some columns on 
> the sides ? In that case a "non-corrupted" region would make sense (but would 
> be more difficult to handle).

Never seen any personally.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
