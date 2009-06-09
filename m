Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:11184 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbZFIOxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 10:53:34 -0400
Date: Tue, 9 Jun 2009 16:54:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: RFC: proposal for new i2c.h macro to initialize i2c address
 lists on the fly
Message-ID: <20090609165418.70768103@hyperion.delvare>
In-Reply-To: <200906091504.37330.hverkuil@xs4all.nl>
References: <200906061500.49338.hverkuil@xs4all.nl>
	<20090608143932.36cd1b4f@hyperion.delvare>
	<200906091504.37330.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 9 Jun 2009 15:04:36 +0200, Hans Verkuil wrote:
> Here it is:
> 
> --- linux-git/include/linux/i2c.h.orig	2009-06-09 14:53:32.000000000 +0200
> +++ linux-git/include/linux/i2c.h	2009-06-09 15:03:24.000000000 +0200
> @@ -412,6 +412,10 @@
>  /* The numbers to use to set I2C bus address */
>  #define ANY_I2C_BUS		0xffff
>  
> +/* Construct an I2C_CLIENT_END-terminated array of i2c addresses */
> +#define I2C_ADDRS(addr, addrs...) \
> +	((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })
> +
>  
>  /* ----- functions exported by i2c.o */
>  
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Note that this can also be used to initialize an array:
> 
> static const unsigned short addrs[] = I2C_ADDRS(0x2a, 0x2c);
> 
> Whether you want to is another matter, but it works. This functionality is 
> also available in the oldest supported gcc (3.2).

Applied, thanks.

-- 
Jean Delvare
