Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44246 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726945AbeIMOdQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 10:33:16 -0400
Date: Thu, 13 Sep 2018 12:24:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l2-common: fix typo in documentation for
 v4l_bound_align_image()
Message-ID: <20180913092437.knojzf2bzzcb4urh@valkosipuli.retiisi.org.uk>
References: <20180913000738.1674-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180913000738.1674-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 13, 2018 at 02:07:38AM +0200, Niklas Söderlund wrote:
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  include/media/v4l2-common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index cdc87ec61e54c856..7c97951a85e15d6b 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -283,7 +283,7 @@ struct v4l2_priv_tun_config {
>   * @height:	pointer to height that will be adjusted if needed.
>   * @hmin:	minimum height.
>   * @hmax:	maximum height.
> - * @halign:	least significant bit on width.
> + * @halign:	least significant bit on height.
>   * @salign:	least significant bit for the image size (e. g.
>   *		:math:`width * height`).
>   *

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
