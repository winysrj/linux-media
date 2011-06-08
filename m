Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64828 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1FHMdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 08:33:03 -0400
Received: by wya21 with SMTP id 21so315242wya.19
        for <linux-media@vger.kernel.org>; Wed, 08 Jun 2011 05:33:02 -0700 (PDT)
Subject: Re: [beagleboard] Re: [PATCH v7 1/2] Add driver for Aptina (Micron) mt9p031 sensor.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <201106081357.51578.laurent.pinchart@ideasonboard.com>
Date: Wed, 8 Jun 2011 14:32:59 +0200
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	carlighting@yahoo.co.nz, mch_kot@yahoo.com.cn
Content-Transfer-Encoding: 8BIT
Message-Id: <4CF44DCA-BCCA-4AA6-AE14-DAADE66767B4@beagleboard.org>
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com> <201106081357.51578.laurent.pinchart@ideasonboard.com>
To: beagleboard@googlegroups.com
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Op 8 jun 2011, om 13:57 heeft Laurent Pinchart het volgende geschreven:

> Hi Javier,
> 
> I'm testing your patch on a 2.6.39 kernel. Here's what I get when loading the 
> omap3-isp module.
> 
> root@arago:~# modprobe omap3-isp
> [  159.523681] omap3isp omap3isp: Revision 15.0 found
> [  159.528991] omap-iommu omap-iommu.0: isp: version 1.1
> [  159.875701] omap_i2c omap_i2c.2: Arbitration lost
> [  159.881622] mt9p031 2-0048: Failed to reset the camera
> [  159.887054] omap3isp omap3isp: Failed to power on: -5
> [  159.892425] mt9p031 2-0048: Failed to power on device: -5
> [  159.898956] isp_register_subdev_group: Unable to register subdev mt9p031
> 
> Have you (or anyone else) seen that issue ?

I build in both statically to avoid that problem.

regards,

Koen