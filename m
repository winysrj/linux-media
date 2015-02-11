Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35391 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbbBKVpH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 16:45:07 -0500
Message-ID: <54DBCD5D.8000409@gentoo.org>
Date: Wed, 11 Feb 2015 22:45:01 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Christian Engelmayer <cengelma@gmx.at>, linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com, hans.verkuil@cisco.com
Subject: Re: [PATCH] [media] si2165: Fix possible leak in si2165_upload_firmware()
References: <1423688303-31894-1-git-send-email-cengelma@gmx.at>
In-Reply-To: <1423688303-31894-1-git-send-email-cengelma@gmx.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.02.2015 21:58, Christian Engelmayer wrote:
> In case of an error function si2165_upload_firmware() releases the already
> requested firmware in the exit path. However, there is one deviation where
> the function directly returns. Use the correct cleanup so that the firmware
> memory gets freed correctly. Detected by Coverity CID 1269120.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested only. Applies against linux-next.
> ---
>  drivers/media/dvb-frontends/si2165.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
> index 98ddb49ad52b..4cc5d10ed0d4 100644
> --- a/drivers/media/dvb-frontends/si2165.c
> +++ b/drivers/media/dvb-frontends/si2165.c
> @@ -505,7 +505,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
>  	/* reset crc */
>  	ret = si2165_writereg8(state, 0x0379, 0x01);
>  	if (ret)
> -		return ret;
> +		goto error;
>  
>  	ret = si2165_upload_firmware_block(state, data, len,
>  					   &offset, block_count);
> 
Good catch.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

