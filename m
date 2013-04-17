Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:58511 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965738Ab3DQHtX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 03:49:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [media] go7007: dubious one-bit signed bitfields
Date: Wed, 17 Apr 2013 09:49:18 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20130417072029.GF7923@elgon.mountain>
In-Reply-To: <20130417072029.GF7923@elgon.mountain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304170949.18362.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 17 April 2013 09:20:30 Dan Carpenter wrote:
> Because they're signed, "is_video" and "is_audio" can be 0 and -1
> instead of 0 and 1 as intended.  It doesn't cause a bug, but it makes
> Sparse complain:
> drivers/staging/media/go7007/go7007-priv.h:94:31: error: dubious one-bit signed bitfield
> drivers/staging/media/go7007/go7007-priv.h:95:31: error: dubious one-bit signed bitfield
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> 
> diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
> index 8bde187..6e16af7 100644
> --- a/drivers/staging/media/go7007/go7007-priv.h
> +++ b/drivers/staging/media/go7007/go7007-priv.h
> @@ -91,8 +91,8 @@ struct go7007_board_info {
>  	int num_i2c_devs;
>  	struct go_i2c {
>  		const char *type;
> -		int is_video:1;
> -		int is_audio:1;
> +		unsigned int is_video:1;
> +		unsigned int is_audio:1;
>  		int addr;
>  		u32 flags;
>  	} i2c_devs[5];
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
