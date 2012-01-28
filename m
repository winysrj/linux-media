Return-path: <linux-media-owner@vger.kernel.org>
Received: from [206.117.179.246] ([206.117.179.246]:53413 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752062Ab2A1RHS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jan 2012 12:07:18 -0500
Message-ID: <1327770403.19848.45.camel@joe2Laptop>
Subject: Re: [PATCH] media: Use KERN_ERR not KERN_ERROR in saa7164.h
From: Joe Perches <joe@perches.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	trivial@kernel.org
Date: Sat, 28 Jan 2012 09:06:43 -0800
In-Reply-To: <1327769095-9036-1-git-send-email-standby24x7@gmail.com>
References: <1327769095-9036-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2012-01-29 at 01:44 +0900, Masanari Iida wrote:
> Correct "KERN_ERROR" to "KERN_ERR" in
> drivers/media/video/saa7164/saa7164.h
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
[]
> diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/video/saa7164/saa7164.h
[]
> @@ -613,7 +613,7 @@ extern unsigned int saa_debug;
>  
>  #define log_err(fmt, arg...)\
>  	do { \
> -		printk(KERN_ERROR "%s: " fmt, dev->name, ## arg);\
> +		printk(KERN_ERR "%s: " fmt, dev->name, ## arg);\
>  	} while (0)
>  
>  #define saa7164_readl(reg) readl(dev->lmmio + ((reg) >> 2))

Delete the whole macro instead, it's unused.


