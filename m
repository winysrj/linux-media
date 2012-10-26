Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:57409 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab2JZESS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 00:18:18 -0400
Date: Thu, 25 Oct 2012 23:13:09 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] pvr2: fix minor storage
In-Reply-To: <20121025143816.17307.17929.stgit@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1210252307550.14936@ivanova.isely.net>
References: <20121025143816.17307.17929.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Completely agree!  Thanks for spotting that one.

Signed-off-by: Mike Isely <isely@pobox.com>

  -Mike


On Thu, 25 Oct 2012, Alan Cox wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> This should have break statements in it.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/media/usb/pvrusb2/pvrusb2-hdw.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> index fb828ba..299751a 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> @@ -3563,9 +3563,9 @@ void pvr2_hdw_v4l_store_minor_number(struct pvr2_hdw *hdw,
>  				     enum pvr2_v4l_type index,int v)
>  {
>  	switch (index) {
> -	case pvr2_v4l_type_video: hdw->v4l_minor_number_video = v;
> -	case pvr2_v4l_type_vbi: hdw->v4l_minor_number_vbi = v;
> -	case pvr2_v4l_type_radio: hdw->v4l_minor_number_radio = v;
> +	case pvr2_v4l_type_video: hdw->v4l_minor_number_video = v;break;
> +	case pvr2_v4l_type_vbi: hdw->v4l_minor_number_vbi = v;break;
> +	case pvr2_v4l_type_radio: hdw->v4l_minor_number_radio = v;break;
>  	default: break;
>  	}
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
