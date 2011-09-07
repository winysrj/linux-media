Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab1IGQrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 12:47:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 2A01B18B03B
	for <linux-media@vger.kernel.org>; Wed,  7 Sep 2011 17:03:06 +0200 (CEST)
Date: Wed, 7 Sep 2011 17:03:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] V4L: sh-mobile: CEU - CSI-2 - client configuration
Message-ID: <Pine.LNX.4.64.1109071550320.14818@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEU (bridge) driver is a much better place to configure the client -> 
[CSI-2] -> CEU pipeline, than the CSI-2 driver. These 2 patches move this 
configuration accordingly.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
