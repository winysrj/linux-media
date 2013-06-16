Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:62906 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3FPPTK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jun 2013 11:19:10 -0400
MIME-Version: 1.0
In-Reply-To: <1371236911-15131-16-git-send-email-g.liakhovetski@gmx.de>
References: <1371236911-15131-1-git-send-email-g.liakhovetski@gmx.de> <1371236911-15131-16-git-send-email-g.liakhovetski@gmx.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 16 Jun 2013 20:48:47 +0530
Message-ID: <CA+V-a8uPDDNE4y0NoFrhatQqLD+4S1ARdH4vAru4C3xmt3jmZQ@mail.gmail.com>
Subject: Re: [PATCH v11 15/21] V4L2: add a device pointer to struct v4l2_subdev
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

Hi Guennadi,

Thanks for the patch.

On Sat, Jun 15, 2013 at 12:38 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> It is often useful to have simple means to get from a subdevice to the
> underlying physical device. This patch adds such a pointer to struct
> v4l2_subdev and sets it accordingly in the I2C and SPI cases.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
