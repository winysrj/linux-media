Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761492Ab3DBRF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 13:05:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 3511B40BB3
	for <linux-media@vger.kernel.org>; Tue,  2 Apr 2013 19:05:56 +0200 (CEST)
Date: Tue, 2 Apr 2013 19:05:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: soc-camera: last call for 3.10
Message-ID: <Pine.LNX.4.64.1304021846520.31999@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

These are the patches that I've got in my 3.10 soc-camera queue. Please, 
ping me if any are missing. I'll be pushing these some time later this 
week.

Fabio Porcedda (2):
      drivers: media: use module_platform_driver_probe()
      mx2_camera: use module_platform_driver_probe()

Guennadi Liakhovetski (1):
      soc-camera: protect against racing open(2) and rmmod

Phil Edworthy (1):
      soc_camera: Add RGB666 & RGB888 formats

Tushar Behera (1):
      atmel-isi: Update error check for unsigned variables

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
