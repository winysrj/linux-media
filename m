Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52975 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761034AbZE0SgW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 14:36:22 -0400
Date: Wed, 27 May 2009 15:36:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-media@vger.kernel.org, Chaithrika U S <chaithrika@ti.com>
Subject: Re: v4l: Compile ADV7343 and THS7303 drivers for kernels >= 2.6.26
Message-ID: <20090527153619.4b73bb29@pedra.chehab.org>
In-Reply-To: <1243402964-8207-1-git-send-email-chaithrika@ti.com>
References: <1243402964-8207-1-git-send-email-chaithrika@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 May 2009 01:42:44 -0400
Chaithrika U S <chaithrika@ti.com> escreveu:

> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> ---
>  v4l/versions.txt |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/v4l/versions.txt b/v4l/versions.txt
> index eb206b5..3c57c14 100644
> --- a/v4l/versions.txt
> +++ b/v4l/versions.txt
> @@ -13,6 +13,8 @@ USB_STV06XX
>  VIDEO_TVP514X
>  # requires id_table and new i2c stuff
>  RADIO_TEA5764
> +VIDEO_THS7303
> +VIDEO_ADV7343
>  
>  [2.6.25]
>  # Requires gpiolib

Thanks for the patch, but I just added a patch fixing compilation with older
kernels. There were more things broken due to the ir-kbd-i2c patches.




Cheers,
Mauro
