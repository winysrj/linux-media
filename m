Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab1IUQqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 12:46:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id BF20E18B063
	for <linux-media@vger.kernel.org>; Wed, 21 Sep 2011 18:46:07 +0200 (CEST)
Date: Wed, 21 Sep 2011 18:46:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] soc-camera: prepare sh_mobile_ceu_camera for MC
Message-ID: <Pine.LNX.4.64.1109211816380.24024@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

Of the following 2 patches the first one just adds a helper function to 
soc-camera core, and the second one removes the worst cases of 
"coffee-ground reading" from the driver. By this I mean optimisation 
attempts, trying to combine client (e.g., camera sensor driver) and host 
(CEU, bridge) cropping and scaling to achieve best results. Where "best 
results" meant as close to user-requesed configuration as possible with 
minimum bandwidth waste. Even though the results were pretty good, the 
implementation made the driver very complex, hard to maintain and loaded 
with calculations less trivial, than what we like to have in the kernel.

With the move to the Media Controller these optimisations can and shall be 
carried out in the user-space with each driver being configured separately 
for its specific cropping and scaling tasks. Even though we want to 
preserve the ability to work with standard V4L2 applications even without 
the need for an initial set up, we can now remove all those optimisations 
and only keep a couple of simple cases for backwards compatibility. These 
"simple" cases include situations, where the CEU driver forwards an S_CROP 
or an S_FMT to the subdevice driver(s), then checks the result and if 
there is a _simple_ way to improve it, then it does that. Most importantly 
all cases of cropping (on CEU / bridge) on top of scaling (subdevice), 
which lead to the need to calculate subdevice scaling factors and use them 
to calculate host cropping and its projection on the sensor plane...

I don't think we manage to get these patches in 3.2, especially, since 
they mostly make sense in conmbination with the soc-camera Media 
Controller patches, which also are not quite finished yet. So, these 
patches are an early preview. They should be applied on top of what will 
become the soc-camera 3.2 pull, an almost final version of which is 
available at

git://linuxtv.org/gliakhovetski/v4l-dvb.git rc1-for-3.2

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
