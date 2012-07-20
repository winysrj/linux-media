Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2GTPkU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 11:40:20 -0400
Date: Fri, 20 Jul 2012 17:40:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sascha Hauer <s.hauer@pengutronix.de>
Subject: mx1: compilation broken
Message-ID: <Pine.LNX.4.64.1207201734580.5505@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

mx1 camera compilation broken in current media-next 
(git://linuxtv.org/media_tree.git staging/for_v3.6):

In file included from linux/drivers/media/video/mx1_camera.c:44:
linux/arch/arm/mach-imx/include/mach/dma-mx1-mx2.h:8: fatal error: mach/dma-v1.h: No such file or directory

sorry, if this is already fixed in a more recent -next snapshot.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
