Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:55404 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1BVJ5i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 04:57:38 -0500
Date: Tue, 22 Feb 2011 10:57:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: linux-sh@vger.kernel.org,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 0/3] soc_camera_platform: dynamically manage device instances
Message-ID: <Pine.LNX.4.64.1102221049240.1380@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series switches soc_camera_platform users to manage their 
camera device instances dynamically instead of re-using static objects. 
Since I don't have any of affected platforms at hand, this is only 
compile-tested. Please, test!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
