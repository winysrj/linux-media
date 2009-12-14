Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59514 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757406AbZLNPIF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 10:08:05 -0500
Date: Mon, 14 Dec 2009 16:08:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: Latest stack that can be merged on top of linux-next tree
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155CEE4E4@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0912141606180.4957@axis700.grange>
References: <A69FA2915331DC488A831521EAE36FE40155C809AB@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0912120141160.5084@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155CEE4E4@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Dec 2009, Karicheri, Muralidharan wrote:

> Guennadi,
> 
> I marged relevant files from the latest of your v4l tree after seeing 
> your pull request. I worked fine for VGA capture.

Good.

> But I need to enable 
> SOC_CAMERA to get the MT9T031 enabled which looks improper to me. Can we 
> remove this restriction from KConfig?

Sure, as long as we have a valid case where the driver can and does work 
without soc-camera, which we now do, we shall remove this dependency.

> I plan to send a vpfe capture 
> patch to support capture using this driver this week.

Good, looking forward to it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
