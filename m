Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37491 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0EZOSt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 10:18:49 -0400
Date: Wed, 26 May 2010 16:18:48 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: mt9m111 swap_rgb_red_blue
Message-ID: <20100526141848.GU17272@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The mt9m111 soc-camera driver has a swap_rgb_red_blue variable which is
hardcoded to 1. This results in, well the name says it, red and blue being
swapped in my picture.
Is this value needed on some boards or is it just a leftover from
development?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
