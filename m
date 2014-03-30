Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50743 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaC3VRl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 17:17:41 -0400
Date: Sun, 30 Mar 2014 23:17:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ben Dooks <ben.dooks@codethink.co.uk>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
	linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 5/5] rcar_vin: add devicetree support
In-Reply-To: <5338890A.2050607@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1403302316480.12008@axis700.grange>
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk>
 <1394197299-17528-6-git-send-email-ben.dooks@codethink.co.uk>
 <Pine.LNX.4.64.1403081148050.18310@axis700.grange>
 <Pine.LNX.4.64.1403302303490.12008@axis700.grange> <5338890A.2050607@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 30 Mar 2014, Ben Dooks wrote:

> On 30/03/14 22:04, Guennadi Liakhovetski wrote:
> > Hi Ben,
> > 
> > Since I never received a reply to this my query, I consider this your
> > patch series suspended.
> > 
> > Thanks
> > Guennadi
> 
> I meant to send out a patch series for the of probe for soc_camera.
> The actual rcar_vin does not need much to support async probe, it is
> just the soc_camera that needs sorting.

But without that soc-camera DT support your patches are non-functional, 
right?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
