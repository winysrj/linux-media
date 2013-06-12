Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41426 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab3FLRQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 13:16:50 -0400
MIME-Version: 1.0
In-Reply-To: <1370939028-8352-16-git-send-email-g.liakhovetski@gmx.de>
References: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de> <1370939028-8352-16-git-send-email-g.liakhovetski@gmx.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 12 Jun 2013 22:46:29 +0530
Message-ID: <CA+V-a8tmf3Cm04gNa=+2sKrW6kiqVoRgBmGKJMqJgp6wAtepRQ@mail.gmail.com>
Subject: Re: [PATCH v10 15/21] V4L2: add a device pointer to struct v4l2_subdev
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 11, 2013 at 1:53 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> It is often useful to have simple means to get from a subdevice to the
> underlying physical device. This patch adds such a pointer to struct
> v4l2_subdev and sets it accordingly in the I2C and SPI cases.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
