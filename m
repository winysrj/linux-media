Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:26316 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2ILIGs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 04:06:48 -0400
Date: Wed, 12 Sep 2012 11:06:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media: Removes useless kfree()
Message-ID: <20120912080642.GA19396@mwanda>
References: <1347386432-12954-1-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347386432-12954-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 11, 2012 at 08:00:32PM +0200, Peter Senna Tschudin wrote:
> diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
> index cc11260..748da5d 100644
> --- a/drivers/media/dvb-frontends/lg2160.c
> +++ b/drivers/media/dvb-frontends/lg2160.c
> @@ -1451,7 +1451,6 @@ struct dvb_frontend *lg2160_attach(const struct lg2160_config *config,
>  	return &state->frontend;
>  fail:
>  	lg_warn("unable to detect LG216x hardware\n");
> -	kfree(state);
>  	return NULL;
>  }

I wish you had fixed this the same as the others and removed the
goto.  Also the printk is redundant and wrong.  Remove it too.

regards,
dan carpenter

