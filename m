Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38060 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbbBXWDu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 17:03:50 -0500
Date: Tue, 24 Feb 2015 19:03:46 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: au0828 replace printk KERN_DEBUG with pr_debug
Message-ID: <20150224190346.4cf0b439@recife.lan>
In-Reply-To: <1424804014-7743-1-git-send-email-shuahkh@osg.samsung.com>
References: <1424804014-7743-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 24 Feb 2015 11:53:34 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Replace printk KERN_DEBUG with pr_debug in dprintk macro
> defined in au0828.h
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/usb/au0828/au0828.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index eb15187..e3e90ea 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -336,7 +336,7 @@ extern struct vb2_ops au0828_vbi_qops;
>  
>  #define dprintk(level, fmt, arg...)\
>  	do { if (au0828_debug & level)\
> -		printk(KERN_DEBUG pr_fmt(fmt), ## arg);\
> +		pr_debug(pr_fmt(fmt), ## arg);\

NACK.

This is the worse of two words, as it would require both to enable
each debug line via dynamic printk setting and to enable au0828_debug.

Regards,
Mauro


>  	} while (0)
>  
>  /* au0828-input.c */
