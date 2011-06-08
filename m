Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:60158 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1FHLaq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 07:30:46 -0400
Date: Wed, 8 Jun 2011 13:30:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kassey Lee <ygli@marvell.com>
cc: linux-media@vger.kernel.org, ytang5@marvell.com, corbet@lwn.net,
	qingx@marvell.com, jwan@marvell.com, leiwen@marvell.com
Subject: Re: [PATCH] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
In-Reply-To: <1307530660-25464-1-git-send-email-ygli@marvell.com>
Message-ID: <Pine.LNX.4.64.1106081322590.24274@axis700.grange>
References: <1307530660-25464-1-git-send-email-ygli@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kassey

Thanks for the new version, but, IIUC, you agreed to reimplement your 
driver on top of a common ccic core, which means, a lot of code will 
change. So, it doesn't really make much sense now to make and review new 
stand-alone versions of your driver, right? So, shall we wait until Jon's 
CCIC code stabilises a bit and you rebase your driver on top of it? Of 
course, you can also work together with Jon on the drivers to get them 
faster in shape and in a way, suitable fou you both.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
