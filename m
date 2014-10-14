Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35637 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaJNM6S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 08:58:18 -0400
Received: by mail-wi0-f178.google.com with SMTP id h11so6700787wiw.11
        for <linux-media@vger.kernel.org>; Tue, 14 Oct 2014 05:58:17 -0700 (PDT)
Message-ID: <543D1DD1.2060700@cogentembedded.com>
Date: Tue, 14 Oct 2014 16:57:53 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 3/3] media: soc_camera: rcar_vin: Add NV16 horizontal
 scaling-up support
References: <1413268013-8437-1-git-send-email-ykaneko0929@gmail.com> <1413268013-8437-4-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1413268013-8437-4-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 10/14/2014 10:26 AM, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

> The scaling function had been forbidden for the capture format of
> NV16 until now. With this patch, a horizontal scaling-up function
> is supported to the capture format of NV16. a vertical scaling-up
> by the capture format of NV16 is forbidden for the H/W specification.

    s/for/by/?

> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
>   drivers/media/platform/soc_camera/rcar_vin.c | 19 +++++++++++++++----
>   1 file changed, 15 insertions(+), 4 deletions(-)

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 00bc98d..bf3588f 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> @@ -1622,9 +1622,19 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>   	if (priv->error_flag == false)
>   		priv->error_flag = true;
>   	else {
> -		if ((pixfmt == V4L2_PIX_FMT_NV16) && (pix->width & 0x1F)) {
> -			dev_err(icd->parent, "Specified width error in NV16 format.\n");
> -			return -EINVAL;
> +		if (pixfmt == V4L2_PIX_FMT_NV16) {
> +			if (pix->width & 0x1F) {
> +				dev_err(icd->parent,
> +				"Specified width error in NV16 format. "

    You should indent the string more to the right, preferrably starting it 
under 'icd'.

> +				"Please specify the multiple of 32.\n");

    Do not break the string like this. scripts/checkpatch.pl has been taught 
to not complain about long strings.

> +				return -EINVAL;
> +			}
> +			if (pix->height != cam->height) {
> +				dev_err(icd->parent,
> +				"Vertical scaling-up error in NV16 format. "
> +				"Please specify input height size.\n");

    Same here. Not breaking the lines helps to find the error messages in the 
code.

[...]

WBR, Sergei

