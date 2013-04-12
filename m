Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:61146 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3DLQNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 12:13:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id E807240BB3
	for <linux-media@vger.kernel.org>; Fri, 12 Apr 2013 17:43:00 +0200 (CEST)
Date: Fri, 12 Apr 2013 17:43:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] 3.10: soc-camera take 3
Message-ID: <Pine.LNX.4.64.1304121741070.1727@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Just two more patches for 3.10. Note, that one of them is for MAINTAINERS. 
Should it go via media or via someone else's tree?

The following changes since commit 81e096c8ac6a064854c2157e0bf802dc4906678c:

  [media] budget: Add support for Philips Semi Sylt PCI ref. design (2013-04-08 07:28:01 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.10-3

Guennadi Liakhovetski (1):
      soc-camera: fix typos in the default format-conversion table

Laurent Pinchart (1):
      MAINTAINERS: Mark the SH VOU driver as Odd Fixes

 MAINTAINERS                                      |    2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
