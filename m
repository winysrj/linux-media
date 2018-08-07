Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37931 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbeHGNOg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 09:14:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id v14-v6so15350229wro.5
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 04:00:49 -0700 (PDT)
Subject: Re: [PATCH] media: imx: shut up a false positive warning
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
References: <132f3c7bb98673f713be9511de16b7622803df36.1533635936.git.mchehab+samsung@kernel.org>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <584aecdc-961a-6d64-147c-f37adaef3bcf@gmail.com>
Date: Tue, 7 Aug 2018 12:00:46 +0100
MIME-Version: 1.0
In-Reply-To: <132f3c7bb98673f713be9511de16b7622803df36.1533635936.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 07/08/18 10:58, Mauro Carvalho Chehab wrote:
> With imx, gcc produces a false positive warning:
> 
> 	drivers/staging/media/imx/imx-media-csi.c: In function 'csi_idmac_setup_channel':
> 	drivers/staging/media/imx/imx-media-csi.c:457:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
> 	   if (passthrough) {
> 	      ^
> 	drivers/staging/media/imx/imx-media-csi.c:464:2: note: here
> 	  default:
> 	  ^~~~~~~
> 
> That's because the regex it uses for fall trough is not
> good enough. So, rearrange the fall through comment in a way
> that gcc will recognize.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>   drivers/staging/media/imx/imx-media-csi.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 4647206f92ca..b7ffd231c64b 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -460,7 +460,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>   			passthrough_cycles = incc->cycles;
>   			break;
>   		}
> -		/* fallthrough for non-passthrough RGB565 (CSI-2 bus) */
> +		/* for non-passthrough RGB565 (CSI-2 bus) */
> +		/* Falls through */

Adding a '-' to the fallthrough seems to meet the regex requirements at 
level 3 of the warning. Eg...

/* fallthrough- for non-passthrough RGB565 (CSI-2 bus) */

Not sure if this is an improvement though.

Regards,
Ian

>   	default:
>   		burst_size = (image.pix.width & 0xf) ? 8 : 16;
>   		passthrough_bits = 16;
> 
