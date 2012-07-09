Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35105 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2GIIaE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 04:30:04 -0400
Subject: Re: [PATCH 2/3] media: coda: Add driver for Coda video codec.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	shawn.guo@linaro.org, fabio.estevam@freescale.com,
	richard.zhu@linaro.org, arnaud.patard@rtp-net.org,
	kernel@pengutronix.de, mchehab@infradead.org
In-Reply-To: <CACKLOr0UrZ2bi01L+xub7ARwfnoN7kriGpwWfwWzx-MYgS-H8w@mail.gmail.com>
References: <1341579471-25208-1-git-send-email-javier.martin@vista-silicon.com>
	 <1341579471-25208-3-git-send-email-javier.martin@vista-silicon.com>
	 <1341816350.2489.1.camel@pizza.hi.pengutronix.de>
	 <CACKLOr0UrZ2bi01L+xub7ARwfnoN7kriGpwWfwWzx-MYgS-H8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jul 2012 10:29:53 +0200
Message-ID: <1341822593.2489.26.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 09.07.2012, 10:14 +0200 schrieb javier Martin:
[...]
> >> +enum coda_platform {
> >> +     CODA_INVALID = 0,
> >
> > I don't think CODA_INVALID is useful.
> 
> It is, otherwise the following will fail since CODA_IMX27 is 0:
> 
> 	if (of_id)
> 		dev->devtype = of_id->data;
> 	else if (pdev_id && pdev_id->driver_data)  <-----
> pdev_id->driver_data = CODA_IMX27 = 0
> 		dev->devtype = &coda_devdata[pdev_id->driver_data];
> 	else
> 		return -EINVAL;

Oh, right. I think it should be ok to just remove the
pdev_id->driver_data check.
Since it's all in the same source file, it's unlikely that somebody adds
a platform_device_id to coda_platform_ids array but forgets to set
the .driver_data field.

regards
Philipp

