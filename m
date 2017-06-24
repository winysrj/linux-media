Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36220
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751482AbdFXTJp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 15:09:45 -0400
Date: Sat, 24 Jun 2017 16:09:35 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
Subject: Re: [PATCH 7/7] [staging] cxd2099/cxd2099.c: Activate cxd2099
 buffer mode
Message-ID: <20170624160935.5d314082@vento.lan>
In-Reply-To: <1494190313-18557-8-git-send-email-jasmin@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
        <1494190313-18557-8-git-send-email-jasmin@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  7 May 2017 22:51:53 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> From: Jasmin Jessich <jasmin@anw.at>
> 
> Now the cxd2099 buffer mode is activated, but can be deactivated by
> setting BUFFER_MODE to 0 at the compiler command line or by editiing
> the file.

Editing the sources to enable a feature doesn't seem nice. If this
feature should be enabled per caller, you should pass a parameter
for the caller driver when binding to it.

> 
> Signed-off-by: Jasmin Jessich <jasmin@anw.at>
> ---
>  drivers/staging/media/cxd2099/cxd2099.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
> index 64de129..dcad557 100644
> --- a/drivers/staging/media/cxd2099/cxd2099.c
> +++ b/drivers/staging/media/cxd2099/cxd2099.c
> @@ -33,7 +33,9 @@
>  
>  #include "cxd2099.h"
>  
> -/* #define BUFFER_MODE 1 */
> +#ifndef BUFFER_MODE
> +#define BUFFER_MODE 1
> +#endif
>  
>  static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount);
>  



Thanks,
Mauro
