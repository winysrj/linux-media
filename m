Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64667 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab1G1K0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 06:26:53 -0400
Date: Thu, 28 Jul 2011 12:26:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <201107261305.29863.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1107281152010.20737@axis700.grange>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
 <Pine.LNX.4.64.1107201641030.12084@axis700.grange>
 <20110720151946.GH29320@valkosipuli.localdomain> <201107261305.29863.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 Jul 2011, Hans Verkuil wrote:

[snip]

> I am happy with the API. The only thing that's unclear to me is whether you can call
> CREATE_BUFS after REQBUFS. And if not, then why not? It would also be helpful to see
> the full patch series as the last one was from April. It is interesting to see how
> this will interface with vb2.

I think it would be logical to allow both, since we anyway need 
REQBUFS(count=0) for freeing of buffers. This would confirm, that buffers 
vreated with either of these methods are indistinguishable. Then we shall 
define:

CREATE_BUFS after REQBUFS or after earlier CREATE_BUFS adds more buffers
REQBUFS(count=0) frees all buffers
REQBUFS(count > 0) frees all buffers and allocates new ones

Yes, I'll extend the documentation with this.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
