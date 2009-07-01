Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37436 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753751AbZGAJbc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jul 2009 05:31:32 -0400
Date: Wed, 1 Jul 2009 11:31:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: m-karicheri2@ti.com, Hans Verkuil <hverkuil@xs4all.nl>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH RFC] fix cropping and scaling for mx3-camera and mt9t031
 drivers
In-Reply-To: <Pine.LNX.4.64.0906301656471.5748@axis700.grange>
Message-ID: <Pine.LNX.4.64.0907011033340.5609@axis700.grange>
References: <Pine.LNX.4.64.0906301656471.5748@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 30 Jun 2009, Guennadi Liakhovetski wrote:

> This makes mx3-camera and mt9t031 S_CROP and S_FMT implementations V4L2 
> API compliant.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> This is definitely only an RFC, it only fixes one single configuration - 
> i.MX31 (mx3-camera) and MT9T031, and breaks the rest, so, other soc-camera 
> drivers do not even compile with this patch. But users of this hardware 
> are encouraged to check this out. This is still based off an "old" (pre 
> 2.6.30) -next snapshot, the same patch stack at 
> http://download.open-technology.de/soc-camera/20090617/ shall be applied 
> (one patch added), for branch-base see 0000-base. The below patch is also 
> under http://download.open-technology.de/testing/. I think, next I shall 
> update to a more recent post-2.6.30 tree, and then start converting / 
> fixing other drivers.

An updated version of the patch stack is under

http://download.open-technology.de/soc-camera/20090701

it is now based on the IMX tree from Sascha Hauer

git://git.pengutronix.de/git/imx/linux-2.6.git

more precisely its for-rmk branch (commit ID in 0000-base), the S_CROP / 
S_FMT patch from testing/ still applies.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
