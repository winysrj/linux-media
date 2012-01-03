Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61302 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab2ACPFr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 10:05:47 -0500
Date: Tue, 3 Jan 2012 16:05:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
In-Reply-To: <CACKLOr2hQnEteOey3kt2zv8Wrr12+b9DU-Zk66+c-k-F=9pqNw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1201031557130.7204@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
 <201112191105.25855.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1112191113230.23694@axis700.grange>
 <201112191120.40084.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1112191139560.23694@axis700.grange>
 <CACKLOr0Z4BnB3bHCs8BjhwpwcHBHsZA1rDNrxzDW+z3+-qSRgQ@mail.gmail.com>
 <Pine.LNX.4.64.1112191155340.23694@axis700.grange>
 <CACKLOr1=vFs8xDaDMSX146Y1h18q=+fPEBGHekgNq2xRVCOGsA@mail.gmail.com>
 <4EEF66C2.7030003@infradead.org> <CACKLOr2hQnEteOey3kt2zv8Wrr12+b9DU-Zk66+c-k-F=9pqNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Tue, 3 Jan 2012, javier Martin wrote:

> Guennadi,
> probably you could answer me some question:
> 
> as we agreed I'm trying to implement ENUM_INPUT support to soc-camera
> through pads.

No, you probably mean in the subdev driver, not in soc-camera core.

> This means I must be able to pass the tvp5150 decoder
> some platform_data in order to configure what inputs are really routed
> in my board.
> 
> For that purpose I do the following in my board specific code:
> 
>  static struct tvp5150_platform_data visstrim_tvp5150_data = {
> 	.inputs = 55,
> };
> 
> static struct i2c_board_info visstrim_i2c_camera =  {
> 	.type = "tvp5150",
> 	.addr = 0x5d,
> 	.platform_data = &visstrim_tvp5150_data,
> };
> 
> static struct soc_camera_link iclink_tvp5150 = {
> 	.bus_id         = 0,            /* Must match with the camera ID */
> 	.board_info     = &visstrim_i2c_camera,
> 	.i2c_adapter_id = 0,
> 	.power = visstrim_camera_power,
> 	.reset = visstrim_camera_reset,
> };
> 
> static struct platform_device visstrim_tvp5150_soc = {
> 	.name   = "soc-camera-pdrv",
> 	.id     = 0,
> 	.dev    = {
> 		.platform_data = &iclink_tvp5150,
> 	},
> };
> 
> 
> However, it seems soc-camera ignores "board_info.platform_data" field
> and assigns a value of its own:
> 
> http://lxr.linux.no/#linux+v3.1.6/drivers/media/video/soc_camera.c#L1006
> 
> 
> How am I suppose to pass that information to the tvp5150 then?

Have a look at some examples, e.g., arch/sh/boards/mach-migor/setup.c:

static struct soc_camera_link ov7725_link = {
	.power		= ov7725_power,
	.board_info	= &migor_i2c_camera[0],
	.i2c_adapter_id	= 0,
	.priv		= &ov7725_info,
};

I.e., soc-camera expects you to use the struct soc_camera_link::priv field 
for subdevice private platform data.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
