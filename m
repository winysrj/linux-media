Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56341 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaE1Ju2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 05:50:28 -0400
Message-ID: <1401270626.3054.13.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC PATCH] [media] mt9v032: Add support for mt9v022 and mt9v024
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Wed, 28 May 2014 11:50:26 +0200
In-Reply-To: <Pine.LNX.4.64.1405272146260.24747@axis700.grange>
References: <1401112985-32338-1-git-send-email-p.zabel@pengutronix.de>
	 <Pine.LNX.4.64.1405272146260.24747@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Am Dienstag, den 27.05.2014, 21:48 +0200 schrieb Guennadi Liakhovetski:
> Hi Philipp,
> 
> On Mon, 26 May 2014, Philipp Zabel wrote:
> 
> > >From the looks of it, mt9v022 and mt9v032 are very similar,
> > as are mt9v024 and mt9v034. With minimal changes it is possible
> > to support mt9v02[24] with the same driver.
> 
> Are you aware of drivers/media/i2c/soc_camera/mt9v022.c?

Yes. Unfortunately this driver can't be used in a system without
soc_camera. It uses soc_camera helpers and doesn't implement pad ops
among others.

> With this patch you'd duplicate support for both mt9v022 and mt9v024,
> which doesn't look like a good idea to me.

While this is true, given that the mt9v02x/3x sensors are so similar,
the support is already duplicated in all but name.
Would you suggest we should try to merge the mt9v032 and mt9v022
drivers?

regards
Philipp


