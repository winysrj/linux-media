Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-217.synserver.de ([212.40.185.217]:1286 "EHLO
	smtp-out-067.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751901AbcASM1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 07:27:39 -0500
Subject: Re: [PATCH] adv7604: fix SPA register location for ADV7612
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	linux-media@vger.kernel.org
References: <1453205828-8814-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Cc: linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, william.towle@codethink.co.uk
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <569E2A29.4010801@metafoo.de>
Date: Tue, 19 Jan 2016 13:20:57 +0100
MIME-Version: 1.0
In-Reply-To: <1453205828-8814-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2016 01:17 PM, Ulrich Hecht wrote:
> SPA location LSB register is at 0x70.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  drivers/media/i2c/adv7604.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 3787f81..f78d36c 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2149,6 +2149,10 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>  	if (info->type == ADV7604) {
>  		rep_write(sd, 0x76, spa_loc & 0xff);
>  		rep_write_clr_set(sd, 0x77, 0x40, (spa_loc & 0x100) >> 2);
> +	} else if (info->type == ADV7612) {
> +		/* ADV7612 Software Manual Rev. A, p. 15 */
> +		rep_write(sd, 0x70, spa_loc & 0xff);

That should just go onto the else branch and replace the FIXME.

> +		rep_write_clr_set(sd, 0x71, 0x01, (spa_loc & 0x100) >> 8);
>  	} else {
>  		/* FIXME: Where is the SPA location LSB register ? */
>  		rep_write_clr_set(sd, 0x71, 0x01, (spa_loc & 0x100) >> 8);
> 

