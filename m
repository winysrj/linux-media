Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48779 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaLHRwy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 12:52:54 -0500
Message-ID: <5485E572.9010801@iki.fi>
Date: Mon, 08 Dec 2014 19:52:50 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jurgen Kramer <gtmkramer@xs4all.nl>, linux-media@vger.kernel.org
CC: Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH] Si2168: increase timeout to fix firmware loading
References: <1418027444-4718-1-git-send-email-gtmkramer@xs4all.nl>
In-Reply-To: <1418027444-4718-1-git-send-email-gtmkramer@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/2014 10:30 AM, Jurgen Kramer wrote:
> Increase si2168 cmd execute timeout to prevent firmware load failures. Tests
> shows it takes up to 52ms to load the 'dvb-demod-si2168-a30-01.fw' firmware.
> Increase timeout to a safe value of 70ms.
>
> Signed-off-by: Jurgen Kramer <gtmkramer@xs4all.nl>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Cc: <stable@vger.kernel.org> # v3.17+

That must go stable 3.17.

Antti

> ---
>   drivers/media/dvb-frontends/si2168.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index ce9ab44..d2f1a3e 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -39,7 +39,7 @@ static int si2168_cmd_execute(struct si2168 *s, struct si2168_cmd *cmd)
>
>   	if (cmd->rlen) {
>   		/* wait cmd execution terminate */
> -		#define TIMEOUT 50
> +		#define TIMEOUT 70
>   		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
>   		while (!time_after(jiffies, timeout)) {
>   			ret = i2c_master_recv(s->client, cmd->args, cmd->rlen);
>

-- 
http://palosaari.fi/
