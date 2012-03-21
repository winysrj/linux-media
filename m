Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2CULAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:00:02 -0400
Date: Wed, 21 Mar 2012 11:59:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] V4L: sh_mobile_ceu_camera: maximum image size depends
 on the hardware version
In-Reply-To: <2696549.KbXzs1B8nR@avalon>
Message-ID: <Pine.LNX.4.64.1203211157340.31443@axis700.grange>
References: <Pine.LNX.4.64.1203141600210.25284@axis700.grange>
 <2696549.KbXzs1B8nR@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Wed, 21 Mar 2012, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Wednesday 14 March 2012 16:02:20 Guennadi Liakhovetski wrote:
> > Newer CEU versions, e.g., the one, used on sh7372, support image sizes
> > larger than 2560x1920. Retrieve maximum sizes from platform properties.
> 
> Isn't there a way you could query the CEU version at runtime instead ?

I'm not aware of any. And even if it were possible, I'm not sure putting 
tables with "version - feature-set" tables into the driver proper would be 
a very good idea. It used to be like that (or almost like that with 
dependencies on the chip-type) in other drivers (e.g., shdma) and we 
dropped it in favour of platform data.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
