Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44662 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751259AbdJDQ5K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 12:57:10 -0400
Date: Wed, 4 Oct 2017 13:56:51 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, sean@mess.org
Subject: Re: [PATCH 07/19] lirc_dev: remove kmalloc in lirc_dev_fop_read()
Message-ID: <20171004135558.53df2b1d@recife.lan>
In-Reply-To: <149839391031.28811.5094791739782133013.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
        <149839391031.28811.5094791739782133013.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 25 Jun 2017 14:31:50 +0200
David Härdeman <david@hardeman.nu> escreveu:

> lirc_zilog uses a chunk_size of 2 and ir-lirc-codec uses sizeof(int).
> 
> Therefore, using stack memory should be perfectly fine.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/lirc_dev.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index 1773a2934484..92048d945ba7 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -376,7 +376,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
>  			  loff_t *ppos)
>  {
>  	struct irctl *ir = file->private_data;
> -	unsigned char *buf;
> +	unsigned char buf[ir->buf->chunk_size];

No. We don't do dynamic buffer allocation on stak at the Kernel,
as this could cause the Linux stack to overflow without notice.

This should also generate alerts on static code analyzers like
sparse.

I'll drop this patch from the series.

Thanks,
Mauro
