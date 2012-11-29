Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab2K2Kn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 05:43:26 -0500
Date: Thu, 29 Nov 2012 11:43:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com
Subject: Re: [PATCH v2 0/4] media: mx2_camera: Remove i.mx25 and clean up.
In-Reply-To: <1351607342-18030-1-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1211291139350.11210@axis700.grange>
References: <1351607342-18030-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Tue, 30 Oct 2012, Javier Martin wrote:

> Changes since v1:
>  - Remove i.MX25 support in the Kconfig file too in patch 1.
> 
> [PATCH v2 1/4] media: mx2_camera: Remove i.mx25 support.
> [PATCH v2 2/4] media: mx2_camera: Add image size HW limits.
> [PATCH v2 3/4] media: mx2_camera: Remove 'buf_cleanup' callback.
> [PATCH v2 4/4] media: mx2_camera: Remove buffer states.

Now that Fabio has confirmed, that the driver is working on i.MX25, we 
don't need to remove support for it. So, patch 1 is dropped, patch 2 I 
adjusted to be i.MX27-specific, patch also cannot be applied if i.MX25 is 
kept, patch 4 cannot be used either, becuase the buffer state is actually 
checked on i.MX25. It might be possible to remove or simplify it still, 
but that would require a different patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
