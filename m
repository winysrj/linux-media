Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab0BDMep (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 07:34:45 -0500
Message-ID: <4B6ABEDE.2050004@redhat.com>
Date: Thu, 04 Feb 2010 10:34:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Yoichi Yuasa <yuasa@linux-mips.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] fix memory leak media IR keytable
References: <20100204110144.70046143.yuasa@linux-mips.org>
In-Reply-To: <20100204110144.70046143.yuasa@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yoichi,

Yoichi Yuasa wrote:
> Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
> ---
>  drivers/media/IR/ir-keytable.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
> index b521ed9..44501d9 100644
> --- a/drivers/media/IR/ir-keytable.c
> +++ b/drivers/media/IR/ir-keytable.c
> @@ -422,8 +422,10 @@ int ir_input_register(struct input_dev *input_dev,
>  	ir_dev->rc_tab.size = ir_roundup_tablesize(rc_tab->size);
>  	ir_dev->rc_tab.scan = kzalloc(ir_dev->rc_tab.size *
>  				    sizeof(struct ir_scancode), GFP_KERNEL);
> -	if (!ir_dev->rc_tab.scan)
> +	if (!ir_dev->rc_tab.scan) {
> +		kfree(ir_dev);
>  		return -ENOMEM;
> +	}


Thanks for the patch, but we've received and applied an identical fix at the development
tree.

-- 

Cheers,
Mauro
