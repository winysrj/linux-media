Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49073 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbeJHUTC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 16:19:02 -0400
Date: Mon, 8 Oct 2018 15:07:19 +0200
From: Greg KH <greg@kroah.com>
To: Dafna Hirschfeld <dafna3@gmail.com>
Cc: isely@pobox.com, mchehab@kernel.org, helen.koike@collabora.com,
        hverkuil@xs4all.nl, outreachy-kernel@googlegroups.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Outreachy kernel] [PATCH vicodec] media: pvrusb2: replace
 `printk` with `pr_*`
Message-ID: <20181008130719.GA20351@kroah.com>
References: <20181008120647.10271-1-dafna3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181008120647.10271-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 08, 2018 at 03:06:47PM +0300, Dafna Hirschfeld wrote:
> Replace calls to `printk` with the appropriate `pr_*`
> macro.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/usb/pvrusb2/pvrusb2-debug.h    |  2 +-
>  drivers/media/usb/pvrusb2/pvrusb2-hdw.c      |  8 +++---
>  drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c | 28 +++++++++-----------
>  drivers/media/usb/pvrusb2/pvrusb2-main.c     |  4 +--
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c     |  4 +--
>  5 files changed, 22 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-debug.h b/drivers/media/usb/pvrusb2/pvrusb2-debug.h
> index 5cd16292e2fa..1323f949f454 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-debug.h
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-debug.h
> @@ -17,7 +17,7 @@
>  
>  extern int pvrusb2_debug;
>  
> -#define pvr2_trace(msk, fmt, arg...) do {if(msk & pvrusb2_debug) printk(KERN_INFO "pvrusb2: " fmt "\n", ##arg); } while (0)
> +#define pvr2_trace(msk, fmt, arg...) do {if (msk & pvrusb2_debug) pr_info("pvrusb2: " fmt "\n", ##arg); } while (0)

You should not need prefixes for pr_info() calls.

>  
>  /* These are listed in *rough* order of decreasing usefulness and
>     increasing noise level. */
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> index a8519da0020b..7702285c1519 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> @@ -3293,12 +3293,12 @@ void pvr2_hdw_trigger_module_log(struct pvr2_hdw *hdw)
>  	int nr = pvr2_hdw_get_unit_number(hdw);
>  	LOCK_TAKE(hdw->big_lock);
>  	do {
> -		printk(KERN_INFO "pvrusb2: =================  START STATUS CARD #%d  =================\n", nr);
> +		pr_info("pvrusb2: =================  START STATUS CARD #%d  =================\n", nr);

A driver should be using dev_info(), not pr_*.

Also, for the outreachy application process, I can not accept patches
outside of drivers/staging/.

sorry,

greg k-h
