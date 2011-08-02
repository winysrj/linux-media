Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52395 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1HBO3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 10:29:01 -0400
Date: Tue, 2 Aug 2011 16:28:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <4E37FFA7.3040508@iki.fi>
Message-ID: <Pine.LNX.4.64.1108021628200.29918@axis700.grange>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
 <201107261305.29863.hverkuil@xs4all.nl> <20110726114427.GC32507@valkosipuli.localdomain>
 <201107261357.31673.hverkuil@xs4all.nl> <Pine.LNX.4.64.1108011031150.30975@axis700.grange>
 <4E36BE4F.7080704@iki.fi> <Pine.LNX.4.64.1108011704290.30975@axis700.grange>
 <4E37B082.4090105@iki.fi> <Pine.LNX.4.64.1108021015460.29918@axis700.grange>
 <4E37D551.8030803@iki.fi> <Pine.LNX.4.64.1108021301410.29918@axis700.grange>
 <4E37FFA7.3040508@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2 Aug 2011, Sakari Ailus wrote:

> Uh, I'm a bit lost now. Do different buffer types (e.g. capture, overlay
> and input) need to be taken into account here, and if so, how? My
> understanding was this is not related to preparing buffers.

They all should be dealt with correctly. If you find any problems, please, 
report.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
