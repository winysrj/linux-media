Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40395 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0EZOMJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 10:12:09 -0400
Date: Wed, 26 May 2010 16:12:08 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: About master clock frequency in soc-camera
Message-ID: <20100526141208.GT17272@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi et all,

On our i.MX27 board we have a wide range of cameras (mt9m001, mt9v022,
mt9m131). Registering all of them and let the probe routines decide
which one is connected works quite good.
The problem I have now is that the mt9m131 allows for a higher master
clock frequency. ATM the mclk is given with the mx2_camera platform data
(same on i.MX31), thus only one mclk frequency is supported per kernel
image. Do you have any hints on how to make the mclk a parameter of the
sensors?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
