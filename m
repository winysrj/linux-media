Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbZGVU6c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 16:58:32 -0400
Date: Wed, 22 Jul 2009 13:57:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Samuelsson <sam.linux.kernel@gmail.com>
Cc: rbultje@ronald.bitfreak.net, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [patch] drivers/media/video/zoran_card.c: en/decoder loading
Message-Id: <20090722135757.1653962f.akpm@linux-foundation.org>
In-Reply-To: <20080127190129.6a1554ef.sam.linux.kernel@gmail.com>
References: <20080127190129.6a1554ef.sam.linux.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(cc linux-media)

On Sun, 27 Jan 2008 19:01:29 +0100
Martin Samuelsson <sam.linux.kernel@gmail.com> wrote:

> This enables the avs6eyes to load the bt866 and ks0127 drivers automatically.
> 
> Signed-off-by: Martin Samuelsson <sam.linux.kernel@gmail.com>
> ---
>  zoran_card.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> --- linux-2.6.24-ori/drivers/media/video/zoran_card.c	2008-01-24 23:58:37.000000000 +0100
> +++ linux-2.6.24-sam/drivers/media/video/zoran_card.c	2008-01-27 17:16:51.000000000 +0100
> @@ -366,6 +366,12 @@ i2cid_to_modulename (u16 i2c_id)
>  	case I2C_DRIVERID_MSE3000:
>  		name = "mse3000";
>  		break;*/
> +	case I2C_DRIVERID_BT866:
> +		name = "bt866";
> +		break;
> +	case I2C_DRIVERID_KS0127:
> +		name = "ks0127";
> +		break;
>  	default:
>  		break;
>  	}

The Zoran driver has changed a lot since 2.6.24 and I can't find
anywhere where a patch like this might be applied.

Please check a current kernel and update the patch if it is still needed?
