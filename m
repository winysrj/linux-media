Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55892 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab3CDJ3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:29:47 -0500
Received: by mail-wg0-f49.google.com with SMTP id 15so4066078wgd.16
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 01:29:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <82ceff23cb7321a9f84f76ae1ed956b2829a45d6.1362387265.git.hans.verkuil@cisco.com>
References: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
 <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl> <82ceff23cb7321a9f84f76ae1ed956b2829a45d6.1362387265.git.hans.verkuil@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 4 Mar 2013 14:59:26 +0530
Message-ID: <CA+V-a8t_ri8qJoc=KwE6kMCXwPxqkpbMoV3UsjZ9mJ_zgRFORQ@mail.gmail.com>
Subject: Re: [REVIEW PATCH 10/11] davinci/dm644x_ccdc: fix compiler warning
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Mar 4, 2013 at 2:35 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> drivers/media/platform/davinci/dm644x_ccdc.c: In function �validate_ccdc_param�:
> drivers/media/platform/davinci/dm644x_ccdc.c:233:32: warning: comparison between �enum ccdc_gama_width� and �enum ccdc_data_size� [-Wenum-compare]
>
please refer this discussion [1], where Mauro has suggested
few options for fixing it.

Regards,
--Prabhakar Lad

[1] https://patchwork.kernel.org/patch/1923091/

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/davinci/dm644x_ccdc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
> index 318e805..41f0a80 100644
> --- a/drivers/media/platform/davinci/dm644x_ccdc.c
> +++ b/drivers/media/platform/davinci/dm644x_ccdc.c
> @@ -230,7 +230,7 @@ static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
>         if (ccdcparam->alaw.enable) {
>                 if ((ccdcparam->alaw.gama_wd > CCDC_GAMMA_BITS_09_0) ||
>                     (ccdcparam->alaw.gama_wd < CCDC_GAMMA_BITS_15_6) ||
> -                   (ccdcparam->alaw.gama_wd < ccdcparam->data_sz)) {
> +                   (ccdcparam->alaw.gama_wd < (unsigned)ccdcparam->data_sz)) {
>                         dev_dbg(ccdc_cfg.dev, "\nInvalid data line select");
>                         return -1;
>                 }
> --
> 1.7.10.4
>
