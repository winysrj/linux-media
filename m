Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:16055 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2GRO7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 10:59:19 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Duan Jiong <djduanjiong@gmail.com>
Subject: Re: [PATCH] pms.c: remove duplicated include
Date: Wed, 18 Jul 2012 16:58:53 +0200
Cc: mchehab@infradead.org, hans.verkuil@cisco.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5006CB2B.3060905@gmail.com>
In-Reply-To: <5006CB2B.3060905@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb18030"
Content-Transfer-Encoding: 7bit
Message-Id: <201207181658.53914.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 18 July 2012 16:41:47 Duan Jiong wrote:
> 
> Signed-off-by: Duan Jiong <djduanjiong@gmail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans

> ---
>  drivers/media/video/pms.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
> index b4c679b..77f9c92 100644
> --- a/drivers/media/video/pms.c
> +++ b/drivers/media/video/pms.c
> @@ -30,7 +30,6 @@
>  #include <linux/ioport.h>
>  #include <linux/init.h>
>  #include <linux/mutex.h>
> -#include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/isa.h>
>  #include <asm/io.h>
> 
