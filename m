Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab1HYMg7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 08:36:59 -0400
Date: Thu, 25 Aug 2011 14:36:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Uwe =?iso-8859-15?q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>, Marin Mitov <mitov@issp.bas.bg>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2/RFC] media: vb2: change queue initialization order
In-Reply-To: <201108251312.23728.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1108251430440.17190@axis700.grange>
References: <1314269531-30080-1-git-send-email-m.szyprowski@samsung.com>
 <201108251312.23728.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 25 Aug 2011, Hans Verkuil wrote:

> On Thursday, August 25, 2011 12:52:11 Marek Szyprowski wrote:

[snip]

> > @@ -1110,6 +1110,8 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_dqbuf);
> >  
> > +static void __vb2_queue_cancel(struct vb2_queue *q);
> > +
> 
> Is it possible to move __vb2_queue_cancel forward instead of having to add a
> forward declaration? In general you don't want forward declarations unless
> you have some sort of circular dependency.

IMHO, adding a forward declaration has the advantages of making the patch 
smaller and showing clearly, that the function has not changed, or making 
any changes directly visible. If such forward declarations should really 
be avoided, moving of affected functions could be done in a separate 
patch, clearly stating, that the function contents have not changed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
