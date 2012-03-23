Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58390 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab2CWMzF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 08:55:05 -0400
Message-ID: <4F6C72A6.30908@iki.fi>
Date: Fri, 23 Mar 2012 14:55:02 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH 2/3] em28xx-dvb: enable LNA for cxd2820r in DVB-T mode
References: <1331832829-4580-1-git-send-email-gennarone@gmail.com> <1331832829-4580-3-git-send-email-gennarone@gmail.com>
In-Reply-To: <1331832829-4580-3-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we speak earlier LNA support is not implemented at all as our API / 
framework. My personal opinion LNA should be always disabled by default 
since it still makes some noise. Current hard coded values are just 
selected what gives better signal for me and thus are not optimal nor 
correct. Anyhow, I would not like to change those as for some user it 
could cause problems. And if I would change those I will disable all :)

So better to left as those are currently until API/DVB core is fixed to 
support LNA.

regards
Antti


On 15.03.2012 19:33, Gianluca Gennari wrote:
> Enable the LNA amplifier also for DVB-T (like for DVB-T2 and DVB-C);
> this greatly improves reception of weak signals without affecting the reception
> of the strong ones.
>
> Experimental data (collected with the mipsel STB) on the weakest frequencies
> available in my area:
>
> LNA OFF:
>
> MUX          level   BER     picture
>
> RAI mux 4    72%     32000   corrupted
> TIMB 2       75%     14      OK
> TVA Vicenza  68%     32000   corrupted
> RAI mux 2    78%     14      OK
>
> LNA ON:
>
> MUX          level   BER     picture
>
> RAI mux 4    73%     1500    OK
> TIMB 2       76%     0       OK
> TVA Vicenza  69%     0       OK
> RAI mux 2    79%     0       OK
>
> Moreover, with LNA enabled, the PCTV 290e was able to pick up 2 new frequencies
> matching the integrated tuner of my Panasonic G20 TV, which is really good.
>
> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>
> ---
>   drivers/media/video/em28xx/em28xx-dvb.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
> index fbd9010..4917b71 100644
> --- a/drivers/media/video/em28xx/em28xx-dvb.c
> +++ b/drivers/media/video/em28xx/em28xx-dvb.c
> @@ -502,7 +502,8 @@ static struct cxd2820r_config em28xx_cxd2820r_config = {
>   	.i2c_address = (0xd8>>  1),
>   	.ts_mode = CXD2820R_TS_SERIAL,
>
> -	/* enable LNA for DVB-T2 and DVB-C */
> +	/* enable LNA for DVB-T, DVB-T2 and DVB-C */
> +	.gpio_dvbt[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
>   	.gpio_dvbt2[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
>   	.gpio_dvbc[0] = CXD2820R_GPIO_E | CXD2820R_GPIO_O | CXD2820R_GPIO_L,
>   };


-- 
http://palosaari.fi/
