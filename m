Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34677 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754925AbcJWRJN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 13:09:13 -0400
Subject: Re: [PATCH 1/1] [media] mb86a20s: always initialize a return value
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <20160910164901.2901-1-nicolas.iooss_linux@m4x.org>
Cc: linux-kernel@vger.kernel.org
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Message-ID: <93d6d621-88eb-a573-40a8-94571f95b327@m4x.org>
Date: Sun, 23 Oct 2016 19:09:10 +0200
MIME-Version: 1.0
In-Reply-To: <20160910164901.2901-1-nicolas.iooss_linux@m4x.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I sent the following patch (available on
https://patchwork.kernel.org/patch/9325035/) a few weeks ago and got no
feedback even though the bug it fixes seems to still exist in
linux-next. Did I do something wrong? Should I consider this patch to be
rejected?

Thanks,
Nicolas

On 10/09/16 18:49, Nicolas Iooss wrote:
> In mb86a20s_read_status_and_stats(), when mb86a20s_read_status() fails,
> the function returns the value in variable rc without initializing it
> first. Fix this by propagating the error code from variable status_nr.
> 
> This bug has been found using clang and -Wsometimes-uninitialized
> warning flag.
> 
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
> ---
>  drivers/media/dvb-frontends/mb86a20s.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
> index 41325328a22e..eca07432645e 100644
> --- a/drivers/media/dvb-frontends/mb86a20s.c
> +++ b/drivers/media/dvb-frontends/mb86a20s.c
> @@ -1971,6 +1971,7 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
>  	if (status_nr < 0) {
>  		dev_err(&state->i2c->dev,
>  			"%s: Can't read frontend lock status\n", __func__);
> +		rc = status_nr;
>  		goto error;
>  	}
>  
> 

