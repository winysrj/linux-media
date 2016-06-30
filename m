Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:34081 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751680AbcF3A1b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 20:27:31 -0400
Message-ID: <1467246446.24287.118.camel@perches.com>
Subject: Re: [PATCH 04/15] lirc_dev: replace printk with pr_* or dev_*
From: Joe Perches <joe@perches.com>
To: Andi Shyti <andi.shyti@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Date: Wed, 29 Jun 2016 17:27:26 -0700
In-Reply-To: <1467206444-9935-5-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
	 <1467206444-9935-5-git-send-email-andi.shyti@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2016-06-29 at 22:20 +0900, Andi Shyti wrote:
> This patch mutes also all the checkpatch warnings related to
> printk.
> 
> Reword all the printouts so that the string doesn't need to be
> split, which fixes the following checkpatch warning:

Adding

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include would allow these to be prefixed
automatically and allow the embedded prefixes to be removed.
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
[]
> @@ -240,59 +240,51 @@ static int lirc_allocate_driver(struct lirc_driver *d)
>  	int err;
>  
>  	if (!d) {
> -		printk(KERN_ERR "lirc_dev: lirc_register_driver: "
> -		       "driver pointer must be not NULL!\n");
> +		pr_err("lirc_dev: driver pointer must be not NULL!\n");
>  		err = -EBADRQC;
>  		goto out;
>  	}

		pr_err("driver pointer must not be NULL!\n");

And typical multiple line statement alignment is to
the open parenthesis.
