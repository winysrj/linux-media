Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:62392 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab1EROLZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 10:11:25 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 75648189B66
	for <linux-media@vger.kernel.org>; Wed, 18 May 2011 16:11:23 +0200 (CEST)
Date: Wed, 18 May 2011 16:11:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/5] soc-camera for .40: adapt to changed and new mediabus
 pixel codes
Message-ID: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the integration of the Media Controller and related drivers, pixel 
codes chenged their values and new ones have been added. soc-camera uses 
of those codes have to be adjusted too now.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
