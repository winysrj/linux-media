Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33121 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751310AbdGQNpO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 09:45:14 -0400
Subject: Re: [PATCH 14/14] [media] fix warning on v4l2_subdev_call() result
 interpreted as bool
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20170714092540.1217397-1-arnd@arndb.de>
 <20170714093938.1469319-1-arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f57e08d9-0984-b67c-c64b-c7e0542d0361@xs4all.nl>
Date: Mon, 17 Jul 2017 15:45:08 +0200
MIME-Version: 1.0
In-Reply-To: <20170714093938.1469319-1-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/07/17 11:36, Arnd Bergmann wrote:
> v4l2_subdev_call is a macro returning whatever the callback return
> type is, usually 'int'. With gcc-7 and ccache, this can lead to
> many wanings like:
> 
> media/platform/pxa_camera.c: In function 'pxa_mbus_build_fmts_xlate':
> media/platform/pxa_camera.c:766:27: error: ?: using integer constants in boolean context [-Werror=int-in-bool-context]
>   while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
> media/atomisp/pci/atomisp2/atomisp_cmd.c: In function 'atomisp_s_ae_window':
> media/atomisp/pci/atomisp2/atomisp_cmd.c:6414:52: error: ?: using integer constants in boolean context [-Werror=int-in-bool-context]
>   if (v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
> 
> The best workaround I could come up with is to change all the
> callers that use the return code from v4l2_subdev_call() in an
> 'if' or 'while' condition.
> 
> In case of simple 'if' checks, adding a temporary variable is
> usually ok, and sometimes this can be used to propagate or
> print an error code, so I do that.
> 
> For the 'while' loops, I ended up adding an otherwise useless
> comparison with zero, which unfortunately makes the code a little
> uglied.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/pci/cx18/cx18-ioctl.c                      |  6 ++++--
>  drivers/media/pci/saa7146/mxb.c                          |  5 +++--
>  drivers/media/platform/atmel/atmel-isc.c                 |  4 ++--
>  drivers/media/platform/atmel/atmel-isi.c                 |  4 ++--
>  drivers/media/platform/blackfin/bfin_capture.c           |  4 ++--
>  drivers/media/platform/omap3isp/ispccdc.c                |  5 +++--
>  drivers/media/platform/pxa_camera.c                      |  3 ++-
>  drivers/media/platform/rcar-vin/rcar-core.c              |  2 +-
>  drivers/media/platform/rcar-vin/rcar-dma.c               |  4 +++-
>  drivers/media/platform/soc_camera/soc_camera.c           |  4 ++--
>  drivers/media/platform/stm32/stm32-dcmi.c                |  4 ++--
>  drivers/media/platform/ti-vpe/cal.c                      |  6 ++++--
>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 13 +++++++------
>  13 files changed, 37 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
> index 80b902b12a78..1803f28fc501 100644
> --- a/drivers/media/pci/cx18/cx18-ioctl.c
> +++ b/drivers/media/pci/cx18/cx18-ioctl.c
> @@ -188,6 +188,7 @@ static int cx18_g_fmt_sliced_vbi_cap(struct file *file, void *fh,
>  {
>  	struct cx18 *cx = fh2id(fh)->cx;
>  	struct v4l2_sliced_vbi_format *vbifmt = &fmt->fmt.sliced;
> +	int ret;
>  
>  	/* sane, V4L2 spec compliant, defaults */
>  	vbifmt->reserved[0] = 0;
> @@ -201,8 +202,9 @@ static int cx18_g_fmt_sliced_vbi_cap(struct file *file, void *fh,
>  	 * digitizer/slicer.  Note, cx18_av_vbi() wipes the passed in
>  	 * fmt->fmt.sliced under valid calling conditions
>  	 */
> -	if (v4l2_subdev_call(cx->sd_av, vbi, g_sliced_fmt, &fmt->fmt.sliced))
> -		return -EINVAL;
> +	ret = v4l2_subdev_call(cx->sd_av, vbi, g_sliced_fmt, &fmt->fmt.sliced);
> +	if (ret)
> +		return ret;

Please keep the -EINVAL here. I can't be 100% certain that returning 'ret' wouldn't
break something.

>  
>  	vbifmt->service_set = cx18_get_service_set(vbifmt);
>  	return 0;

<snip>

> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> index 97093baf28ac..fe56a037f065 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> @@ -6405,19 +6405,20 @@ int atomisp_s_ae_window(struct atomisp_sub_device *asd,
>  	struct atomisp_device *isp = asd->isp;
>  	/* Coverity CID 298071 - initialzize struct */
>  	struct v4l2_subdev_selection sel = { 0 };
> +	int ret;
>  
>  	sel.r.left = arg->x_left;
>  	sel.r.top = arg->y_top;
>  	sel.r.width = arg->x_right - arg->x_left + 1;
>  	sel.r.height = arg->y_bottom - arg->y_top + 1;
>  
> -	if (v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
> -			     pad, set_selection, NULL, &sel)) {
> -		dev_err(isp->dev, "failed to call sensor set_selection.\n");
> -		return -EINVAL;
> -	}
> +	ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
> +			       pad, set_selection, NULL, &sel);
> +	if (ret)
> +		dev_err(isp->dev, "failed to call sensor set_selection: %d\n",
> +			ret);

Same here: just keep the 'return -EINVAL'.

>  
> -	return 0;
> +	return ret;
>  }
>  
>  int atomisp_flash_enable(struct atomisp_sub_device *asd, int num_frames)
> 

This is all very hackish, though. I'm not terribly keen on this patch. It's not
clear to me *why* these warnings appear in your setup.

Regards,

	Hans
