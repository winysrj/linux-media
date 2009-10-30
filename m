Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49655 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754179AbZJ3Ubv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 16:31:51 -0400
Date: Fri, 30 Oct 2009 21:31:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: RE: [PATCH 2/9] v4l: add new v4l2-subdev sensor operations, use
 g_skip_top_lines in soc-camera
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155798784@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0910302126060.4378@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0910301403550.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155798784@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Oct 2009, Karicheri, Muralidharan wrote:

> Guennadi,
> 
> 
> > 	mt9m111->rect.left	= MT9M111_MIN_DARK_COLS;
> > 	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
> >diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> >index 6966f64..57e04e9 100644
> >--- a/drivers/media/video/mt9t031.c
> >+++ b/drivers/media/video/mt9t031.c
> >@@ -301,9 +301,9 @@ static int mt9t031_set_params(struct soc_camera_device
> >*icd,
> > 		ret = reg_write(client, MT9T031_WINDOW_WIDTH, rect->width - 1);
> > 	if (ret >= 0)
> > 		ret = reg_write(client, MT9T031_WINDOW_HEIGHT,
> >-				rect->height + icd->y_skip_top - 1);
> >+				rect->height - 1);

> Why y_skip_top is removed?

Because noone ever said they needed it?

> When I connect the sensor output to our SOC 
> input and do format conversion and resize on the fly (frame by frame 
> conversion before writing to SDRAM) I have found that the frame 
> completion interrupt fails to get generated with zero value for 
> y_skip_top. I have used a value
> of 10 and it worked fine for me. So I would like to have a 
> s_skip_top_lines() in the sensor operations which can be called to 
> update this value from the host/bridge driver.

Hm, strange, that's actually not the purpose of this parameter. Wouldn't 
it work for you just as well, if you just request 10 more lines when 
sending s_fmt from your bridge driver?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
