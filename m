Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54104 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbbCCOLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 09:11:07 -0500
Date: Tue, 3 Mar 2015 14:11:03 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Jurgen Kramer <gtmkramer@xs4all.nl>,
	stable@vger.kernel.org
Subject: Re: [PATCHv2] Si2168: increase timeout to fix firmware loading
Message-ID: <20150303141103.GB11835@charon.olymp>
References: <1424986914-5472-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1424986914-5472-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 26, 2015 at 11:41:54PM +0200, Antti Palosaari wrote:
> From: Jurgen Kramer <gtmkramer@xs4all.nl>
> 
> Increase si2168 cmd execute timeout to prevent firmware load failures. Tests
> shows it takes up to 52ms to load the 'dvb-demod-si2168-a30-01.fw' firmware.
> Increase timeout to a safe value of 70ms.
> 
> Cc: <stable@vger.kernel.org> # v3.16+
> Signed-off-by: Jurgen Kramer <gtmkramer@xs4all.nl>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
> Changes since v1:
>  * I added my SOB
> 
> Patch for stable 3.16+
> 
> That patch is already applied to master as commit 551c33e729f654ecfaed00ad399f5d2a631b72cb
> There was some mistake and Cc stable tag I added to patchwork [1] was lost.
>

Thank you Antti, I'll queue this for the 3.16 kernel.

Cheers,
--
Luís

> [1] https://patchwork.linuxtv.org/patch/27382/
> ---
>  drivers/media/dvb-frontends/si2168.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 2e3cdcf..fbc1fa8 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -39,7 +39,7 @@ static int si2168_cmd_execute(struct si2168 *s, struct si2168_cmd *cmd)
>  
>  	if (cmd->rlen) {
>  		/* wait cmd execution terminate */
> -		#define TIMEOUT 50
> +		#define TIMEOUT 70
>  		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
>  		while (!time_after(jiffies, timeout)) {
>  			ret = i2c_master_recv(s->client, cmd->args, cmd->rlen);
> -- 
> http://palosaari.fi/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
