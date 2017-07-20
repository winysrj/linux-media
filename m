Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37931
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S936333AbdGTPGc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:06:32 -0400
Date: Thu, 20 Jul 2017 12:06:23 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: armetallica <armetallica@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]
Message-ID: <20170720120623.39e925c1@vento.lan>
In-Reply-To: <20170710013511.3b4fbe2a@SAL9000>
References: <20170710013511.3b4fbe2a@SAL9000>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Jul 2017 01:35:11 +0200
armetallica <armetallica@gmail.com> escreveu:

> From 043428d63637a6dd8e52449b73dbb8341885d7e4 Mon Sep 17 00:00:00 2001
> From: Armin Schoenlieb <armetallica@gmail.com>
> Date: Mon, 10 Jul 2017 01:12:52 +0200
> Subject: [PATCH] Staging: media: atomisp2: fixed trailing whitespace error in
>  atomisp_v4l2.c This is a patch to the atomisp_v4l2.c file that fixes up a
>  trailing whitespace error found by the checkpatch.pl tool

Something clearly gets wrong here...

Regards,
Mauro

> 
> Signed-off-by: Armin Schoenlieb <armetallica@gmail.com>
> ---
>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
> index a543def739fc..05d02ebb6d25 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
> @@ -1277,13 +1277,13 @@ static int atomisp_pci_probe(struct pci_dev *dev,
>  			(ATOMISP_HW_REVISION_ISP2400
>  			 << ATOMISP_HW_REVISION_SHIFT) |
>  			ATOMISP_HW_STEPPING_B0;
> -#ifdef FIXME			
> +#ifdef FIXME
>  		if (INTEL_MID_BOARD(3, TABLET, BYT, BLK, PRO, CRV2) ||
>  			INTEL_MID_BOARD(3, TABLET, BYT, BLK, ENG, CRV2)) {
>  			isp->dfs = &dfs_config_byt_cr;
>  			isp->hpll_freq = HPLL_FREQ_2000MHZ;
>  		} else
> -#endif		
> +#endif
>  		{
>  			isp->dfs = &dfs_config_byt;
>  			isp->hpll_freq = HPLL_FREQ_1600MHZ;



Thanks,
Mauro
