Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36209
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751436AbdFXTHU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 15:07:20 -0400
Date: Sat, 24 Jun 2017 16:07:11 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
Subject: Re: [PATCH 5/7] [media] ddbridge/ddbridge-core.c: Set maximum
 cxd2099 block size to 512
Message-ID: <20170624160711.1733e9f9@vento.lan>
In-Reply-To: <1494190313-18557-6-git-send-email-jasmin@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
        <1494190313-18557-6-git-send-email-jasmin@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  7 May 2017 22:51:51 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

Please add a description. Why is it needed?

> From: Jasmin Jessich <jasmin@anw.at>
> 
> Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> Signed-off-by: Jasmin Jessich <jasmin@anw.at>
> ---
>  drivers/media/pci/ddbridge/ddbridge-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
> index 340cff0..c96b7f9 100644
> --- a/drivers/media/pci/ddbridge/ddbridge-core.c
> +++ b/drivers/media/pci/ddbridge/ddbridge-core.c
> @@ -1036,6 +1036,7 @@ static struct cxd2099_cfg cxd_cfg = {
>  	.adr     =  0x40,
>  	.polarity = 1,
>  	.clock_mode = 1,
> +	.max_i2c = 512,
>  };
>  
>  static int ddb_ci_attach(struct ddb_port *port)



Thanks,
Mauro
