Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46712 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab2ACOu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 09:50:57 -0500
Received: by werm1 with SMTP id m1so7908905wer.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 06:50:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EEF66C2.7030003@infradead.org>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
	<201112191105.25855.laurent.pinchart@ideasonboard.com>
	<Pine.LNX.4.64.1112191113230.23694@axis700.grange>
	<201112191120.40084.laurent.pinchart@ideasonboard.com>
	<Pine.LNX.4.64.1112191139560.23694@axis700.grange>
	<CACKLOr0Z4BnB3bHCs8BjhwpwcHBHsZA1rDNrxzDW+z3+-qSRgQ@mail.gmail.com>
	<Pine.LNX.4.64.1112191155340.23694@axis700.grange>
	<CACKLOr1=vFs8xDaDMSX146Y1h18q=+fPEBGHekgNq2xRVCOGsA@mail.gmail.com>
	<4EEF66C2.7030003@infradead.org>
Date: Tue, 3 Jan 2012 15:50:55 +0100
Message-ID: <CACKLOr2hQnEteOey3kt2zv8Wrr12+b9DU-Zk66+c-k-F=9pqNw@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
From: javier Martin <javier.martin@vista-silicon.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,
probably you could answer me some question:

as we agreed I'm trying to implement ENUM_INPUT support to soc-camera
through pads. This means I must be able to pass the tvp5150 decoder
some platform_data in order to configure what inputs are really routed
in my board.

For that purpose I do the following in my board specific code:

 static struct tvp5150_platform_data visstrim_tvp5150_data = {
	.inputs = 55,
};

static struct i2c_board_info visstrim_i2c_camera =  {
	.type = "tvp5150",
	.addr = 0x5d,
	.platform_data = &visstrim_tvp5150_data,
};

static struct soc_camera_link iclink_tvp5150 = {
	.bus_id         = 0,            /* Must match with the camera ID */
	.board_info     = &visstrim_i2c_camera,
	.i2c_adapter_id = 0,
	.power = visstrim_camera_power,
	.reset = visstrim_camera_reset,
};

static struct platform_device visstrim_tvp5150_soc = {
	.name   = "soc-camera-pdrv",
	.id     = 0,
	.dev    = {
		.platform_data = &iclink_tvp5150,
	},
};


However, it seems soc-camera ignores "board_info.platform_data" field
and assigns a value of its own:

http://lxr.linux.no/#linux+v3.1.6/drivers/media/video/soc_camera.c#L1006


How am I suppose to pass that information to the tvp5150 then?

Thank you.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
