Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3JUIRR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 04:17:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 6D46140BB3
	for <linux-media@vger.kernel.org>; Mon, 21 Oct 2013 10:17:15 +0200 (CEST)
Date: Mon, 21 Oct 2013 10:17:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [BUILD WARNING] VIDEO_TUNER unmet dependency warning
Message-ID: <Pine.LNX.4.64.1310211012230.32101@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Got this warning with today's Linus' tree:

warning: (VIDEO_PVRUSB2 && VIDEO_TLG2300 && VIDEO_USBVISION && 
VIDEO_CX231XX && VIDEO_TM6000 && VIDEO_EM28XX && VIDEO_IVTV && VIDEO_MXB 
&& VIDEO_CX18 && VIDEO_CX23885 && VIDEO_CX88 && VIDEO_BT848 && 
VIDEO_SAA7134 && VIDEO_SAA7164 && VIDEO_GO7007) selects VIDEO_TUNER which 
has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
