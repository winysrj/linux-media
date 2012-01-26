Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55136 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2AZPic (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 10:38:32 -0500
Date: Thu, 26 Jan 2012 16:38:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/8] soc-camera: Add plane layout information to struct
 soc_mbus_pixelfmt
In-Reply-To: <1327504351-24413-4-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1201261629031.10057@axis700.grange>
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1327504351-24413-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Jan 2012, Laurent Pinchart wrote:

> To compute the number of bytes per line according to the V4L2
> specification, we need information about planes layout for planar
> formats. The new enum soc_mbus_layout convey that information.

Maybe it is better to call that value not "the number of bytes per line 
according to the V4L2 specification," but rather "the value of the 
.bytesperline field?" Also, "conveys" seems a better fit to me:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
