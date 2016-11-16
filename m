Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44339
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933341AbcKPOfl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 09:35:41 -0500
Date: Wed, 16 Nov 2016 12:35:34 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 07/34] [media] DaVinci-VPBE: Delete an unnecessary
 variable initialisation in vpbe_initialize()
Message-ID: <20161116123534.5fdbda6b@vento.lan>
In-Reply-To: <a0386b6e-ba8c-1fae-edb2-27dfd8e1b6bf@users.sourceforge.net>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
        <a0386b6e-ba8c-1fae-edb2-27dfd8e1b6bf@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 12 Oct 2016 16:42:31 +0200
SF Markus Elfring <elfring@users.sourceforge.net> escreveu:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 12 Oct 2016 09:45:39 +0200
> 
> The local variable "ret" will be set to an appropriate value a bit later.
> Thus omit the explicit initialisation at the beginning.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/platform/davinci/vpbe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index afa8ff7..9fdd8c0 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -597,7 +597,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>  	struct osd_state *osd_device;
>  	struct i2c_adapter *i2c_adap;
>  	int num_encoders;
> -	int ret = 0;
> +	int ret;
>  	int err;

Please fold this change to the patch where you'll be addressing the
issues with "err" var, as per my previous email.




Thanks,
Mauro
