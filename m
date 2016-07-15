Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46706
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbcGOPUN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 11:20:13 -0400
Date: Fri, 15 Jul 2016 12:20:08 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] mb86a20s: remove redundant check if val is less
 than zero
Message-ID: <20160715122008.20c5f59d@recife.lan>
In-Reply-To: <1468315851-9179-1-git-send-email-colin.king@canonical.com>
References: <1468315851-9179-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 Jul 2016 10:30:51 +0100
Colin King <colin.king@canonical.com> escreveu:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The result of mb86a20s_readreg(state, 0x0a) & 0xf is always in the range
> 0x00 to 0x0f and can never be negative, so remove the redundant check
> of the result being less than zero.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/dvb-frontends/mb86a20s.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
> index fb88ddd..0205846 100644
> --- a/drivers/media/dvb-frontends/mb86a20s.c
> +++ b/drivers/media/dvb-frontends/mb86a20s.c
> @@ -302,8 +302,6 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, enum fe_status *status)
>  	*status = 0;
>  
>  	val = mb86a20s_readreg(state, 0x0a) & 0xf;
> -	if (val < 0)
> -		return val;

Actually, mb86a20s_readreg() can return a negative value.

Please change the above logic to first check for the value returned
from mb86a20s_readreg() and then apply the bitmask.

Thanks,
Mauro

>  
>  	if (val >= 2)
>  		*status |= FE_HAS_SIGNAL;



Thanks,
Mauro
