Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:53537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1DBWxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 18:53:48 -0400
Message-ID: <4D97A8F6.1060001@infradead.org>
Date: Sat, 02 Apr 2011 19:53:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] soc-camera: one more patch
References: <Pine.LNX.4.64.1103232149360.6836@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1103232149360.6836@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-03-2011 17:51, Guennadi Liakhovetski escreveu:
> Hi Mauro
> 
> Sorry, would be nice if we could manage to push one more patch for 2.6.39:
> 
> The following changes since commit f772f016e15a0b93b5aa9680203107ab8cb9bdc6:
> 
>   [media] media-devnode: don't depend on BKL stuff (2011-03-22 19:43:01 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.39
> 
> Guennadi Liakhovetski (1):
>       V4L: soc_camera_platform: add helper functions to manage device instances
> 
>  include/media/soc_camera_platform.h |   50 +++++++++++++++++++++++++++++++++++
>  1 files changed, 50 insertions(+), 0 deletions(-)

Guennadi,

While it would be probably ok to send this patch after the end of the merge window,
there's no sense on doing it, as no other driver is using the new stuff. So, I just
added it at stating/for_2.6.40.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

