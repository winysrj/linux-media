Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50929 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1FHL5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 07:57:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v7 1/2] Add driver for Aptina (Micron) mt9p031 sensor.
Date: Wed, 8 Jun 2011 13:57:51 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	mch_kot@yahoo.com.cn
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106081357.51578.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

I'm testing your patch on a 2.6.39 kernel. Here's what I get when loading the 
omap3-isp module.

root@arago:~# modprobe omap3-isp
[  159.523681] omap3isp omap3isp: Revision 15.0 found
[  159.528991] omap-iommu omap-iommu.0: isp: version 1.1
[  159.875701] omap_i2c omap_i2c.2: Arbitration lost
[  159.881622] mt9p031 2-0048: Failed to reset the camera
[  159.887054] omap3isp omap3isp: Failed to power on: -5
[  159.892425] mt9p031 2-0048: Failed to power on device: -5
[  159.898956] isp_register_subdev_group: Unable to register subdev mt9p031

Have you (or anyone else) seen that issue ?

-- 
Regards,

Laurent Pinchart
