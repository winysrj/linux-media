Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36340 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3BORY4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 12:24:56 -0500
Received: by mail-pa0-f41.google.com with SMTP id fb11so1822718pad.14
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 09:24:55 -0800 (PST)
Date: Fri, 15 Feb 2013 09:24:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-media <linux-media@vger.kernel.org>,
	stable@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH] media: i.MX27 camera: fix picture source width
Message-ID: <20130215172452.GA27113@kroah.com>
References: <1360948121.29406.15.camel@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360948121.29406.15.camel@mars>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 15, 2013 at 06:08:41PM +0100, Christoph Fritz wrote:
> While using a mt9m001 (monochrome) camera the final output falsely gets
> horizontally divided into two pictures.
> 
> The issue was git bisected to commit f410991dcf1f
> 
>   |  [media] i.MX27 camera: add support for YUV420 format
>   |
>   |  This patch uses channel 2 of the eMMa-PrP to convert
>   |  format provided by the sensor to YUV420.
>   |
>   |  This format is very useful since it is used by the
>   |  internal H.264 encoder.
> 
> It sets PICTURE_X_SIZE in register PRP_SRC_FRAME_SIZE to its full width
> while before that commit it was divided by two:
> 
> -   writel(((bytesperline >> 1) << 16) | icd->user_height,
> +           writel((icd->user_width << 16) | icd->user_height,
>                     pcdev->base_emma + PRP_SRC_FRAME_SIZE);
> 
> i.mx27 reference manual (41.6.12 PrP Source Frame Size Register) says:
> 
>     PICTURE_X_SIZE. These bits set the frame width to be
>     processed in number of pixels. In YUV 4:2:0 mode, Cb and
>     Cr widths are taken as PICTURE_X_SIZE/2 pixels.  In YUV
>     4:2:0 mode, this value should be a multiple of 8-pixels.
>     In other modes (RGB, YUV 4:2:2 and YUV 4:4:4) it should
>     be a multiple of 4 pixels.
> 
> This patch reverts to PICTURE_X_SIZE/2 for channel 1.
> 
> Tested on Kernel 3.4, merged to 3.8rc.
> 
> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> ---
>  drivers/media/platform/soc_camera/mx2_camera.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
