Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:42584 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaJRPF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Oct 2014 11:05:58 -0400
Received: by mail-la0-f53.google.com with SMTP id gq15so2004488lab.26
        for <linux-media@vger.kernel.org>; Sat, 18 Oct 2014 08:05:57 -0700 (PDT)
Message-ID: <544281C3.9030002@cogentembedded.com>
Date: Sat, 18 Oct 2014 19:05:39 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 2/3] media: soc_camera: rcar_vin: Add capture width
 check for NV16 format
References: <1413439968-6349-1-git-send-email-ykaneko0929@gmail.com> <1413439968-6349-3-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1413439968-6349-3-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/16/2014 10:12 AM, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

> At the time of NV16 capture format, the user has to specify the
> capture output width of the multiple of 32 for H/W specification.
> At the time of using NV16 format by ioctl of VIDIOC_S_FMT,
> this patch adds align check and the error handling to forbid
> specification of the capture output width which is not a multiple of 32.

> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---

> v2 [Yoshihiro Kaneko]
> * use u32 instead of unsigned long

>   drivers/media/platform/soc_camera/rcar_vin.c | 24 ++++++++++++++++++++++--
>   1 file changed, 22 insertions(+), 2 deletions(-)

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 34d5b80..ff5f80a 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> @@ -1606,6 +1615,17 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>   	dev_dbg(dev, "S_FMT(pix=0x%x, %ux%u)\n",
>   		pixfmt, pix->width, pix->height);
>
> +	/* At the time of NV16 capture format, the user has to specify the
> +	   width of the multiple of 32 for H/W specification. */
> +	if (priv->error_flag == false)
> +		priv->error_flag = true;
> +	else {
> +		if ((pixfmt == V4L2_PIX_FMT_NV16) && (pix->width & 0x1F)) {
> +			dev_err(icd->parent, "Specified width error in NV16 format.\n");
> +			return -EINVAL;
> +		}
> +	}

    Oh, and the kernel style dictates that {} should be used in all arms of 
the *if* statement if they're used in at least one.

WBR, Sergei

