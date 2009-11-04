Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45180 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751361AbZKDTLW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2009 14:11:22 -0500
Date: Wed, 4 Nov 2009 20:11:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: RE: [PATCH 2/9] v4l: add new v4l2-subdev sensor operations, use
 g_skip_top_lines in soc-camera
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155798D72@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0911042009120.4837@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301403550.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155798784@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0910302126060.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155798D72@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Nov 2009, Karicheri, Muralidharan wrote:

> >> >@@ -301,9 +301,9 @@ static int mt9t031_set_params(struct
> >soc_camera_device
> >> >*icd,
> >> > 		ret = reg_write(client, MT9T031_WINDOW_WIDTH, rect->width - 1);
> >> > 	if (ret >= 0)
> >> > 		ret = reg_write(client, MT9T031_WINDOW_HEIGHT,
> >> >-				rect->height + icd->y_skip_top - 1);
> >> >+				rect->height - 1);
> >
> >> Why y_skip_top is removed?
> >
> >Because noone ever said they needed it?
> >
> I suggest you keep it. It can have default 0. I have not viewed the 
> resulting image for the top line to see if it is corrupted. I just
> use it to display it to my display device and I am not seeing any
> corruption. I need to view the image at some point to check if it has
> any corruption.

Ok, I preserved it, although I'm not convinced it is indeed needed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
