Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:51044 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab1BRIN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 03:13:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id EFD73189B7F
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 09:13:27 +0100 (CET)
Date: Fri, 18 Feb 2011 09:13:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] soc-camera: vb2
Message-ID: <Pine.LNX.4.64.1102180857360.1851@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

Two of these patches I already pushed to my experimental vb2 branch on 
linuxtv.org, I just forgot to also post them here (bad-bad). The third one 
is actually a fix / an improvement to the original sh-mobile-ceu driver 
port to vb2, which I would like to merge with it for final submission. I 
am just not quite sure, how appropriate this would be. In principle that 
is "just" an experimental branch, even though it is publicly visible, so, 
noone can expect commits in it to be in their final form. So, I think, I 
will redo that patch and drop the vb2 branch, merging it completely into 
the 2.6.39 queue.

The forth patch is not related to vb2, it just fixes again cropping on 
sh-mobile-ceu.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

