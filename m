Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:59284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaC3VEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 17:04:43 -0400
Date: Sun, 30 Mar 2014 23:04:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ben Dooks <ben.dooks@codethink.co.uk>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
	linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 5/5] rcar_vin: add devicetree support
In-Reply-To: <Pine.LNX.4.64.1403081148050.18310@axis700.grange>
Message-ID: <Pine.LNX.4.64.1403302303490.12008@axis700.grange>
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk>
 <1394197299-17528-6-git-send-email-ben.dooks@codethink.co.uk>
 <Pine.LNX.4.64.1403081148050.18310@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

Since I never received a reply to this my query, I consider this your 
patch series suspended.

Thanks
Guennadi

On Sat, 8 Mar 2014, Guennadi Liakhovetski wrote:

> Hi Ben,
> 
> On Fri, 7 Mar 2014, Ben Dooks wrote:
> 
> > Add support for devicetree probe for the rcar-vin
> > driver.
> 
> Thanks for the patch. I'm afraid I don't quite understand how it is 
> supposed to work though. AFAICS, the rcar_vin driver currently doesn't 
> support asynchronous probing, so, your code is relying on a specific 
> probing order? Besides, as of now soc-camera doesn't support OF probing. 
> You mentioned, that you have a patch for soc-camera to add OF support. I 
> think that and async probing for rcar_vin should be committed before this 
> patch becomes meaningful.

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
