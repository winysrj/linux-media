Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:54265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2JQI1i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 04:27:38 -0400
Date: Wed, 17 Oct 2012 10:27:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [Q] reprobe deferred-probing drivers
Message-ID: <Pine.LNX.4.64.1210171021060.7402@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I've got a situation, for which I currently don't have a (good) solution.

Let's say device A depends on device B and as long as B hasn't probed, A 
requests deferred probing. Now B probes, which causes A to also succeed 
its probing. Next we want to remove B, say, by unloading its driver. A has 
to go back into "deferred-probing" state. How do we do it? This can be 
achieved by unloading B's driver and loading again. Essentially, we have 
to use the sysfs "unbind" and then the "bind" attributes. But how do we do 
this from the kernel? Shall we export driver_bind() and driver_unbind()?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
