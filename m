Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2AZP2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 10:28:16 -0500
Date: Thu, 26 Jan 2012 16:28:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/8] soc_camera: Use soc_camera_device::bytesperline to
 compute line sizes
In-Reply-To: <1327504351-24413-3-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1201261625030.10057@axis700.grange>
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1327504351-24413-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Jan 2012, Laurent Pinchart wrote:

> Instead of computing the line sizes, use the previously negotiated
> soc_camera_device::bytesperline value.

Ok, some of my comments to the previous patch should actually be applied 
to this one instead, but you'll figure it out ;-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
