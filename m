Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40766 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754037AbZCLNbK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 09:31:10 -0400
Date: Thu, 12 Mar 2009 14:31:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] V2: soc-camera: setting the buswidth of camera
 sensors
In-Reply-To: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0903121429530.4896@axis700.grange>
References: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Mar 2009, Sascha Hauer wrote:

> Take 2: I hope I addressed all comments I receive in the first round.
> 
> The following patches change the handling of the bus width
> for camera sensors so that a board can overwrite a sensors
> native bus width
> 
> Sascha Hauer (5):
>   soc-camera: add board hook to specify the buswidth for camera sensors
>   pcm990 baseboard: add camera bus width switch setting
>   mt9m001: allow setting of bus width from board code
>   mt9v022: allow setting of bus width from board code
>   soc-camera: remove now unused gpio member of struct soc_camera_link

Ok, the rest look good to me. So, after you fix or explain 2/5 I'll be 
pulling them.

> 
>  arch/arm/mach-pxa/pcm990-baseboard.c |   49 ++++++++++--
>  drivers/media/video/Kconfig          |   14 ----
>  drivers/media/video/mt9m001.c        |  143 ++++++++++------------------------
>  drivers/media/video/mt9v022.c        |  141 ++++++++++-----------------------
>  include/media/soc_camera.h           |    9 ++-
>  5 files changed, 129 insertions(+), 227 deletions(-)
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
