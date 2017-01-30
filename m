Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53107 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750850AbdA3RKZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 12:10:25 -0500
Date: Mon, 30 Jan 2017 17:10:22 +0000
From: Sean Young <sean@mess.org>
To: Derek Robson <robsonde@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: media: lirc: style fix, using octal file
 permissions
Message-ID: <20170130171022.GA16673@gofer.mess.org>
References: <20170107030255.19042-1-robsonde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170107030255.19042-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 07, 2017 at 04:02:55PM +1300, Derek Robson wrote:
> Change file permissions to octal style.
> Found using checkpatch
> 
> Signed-off-by: Derek Robson <robsonde@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_imon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
> index 1e650fba4a92..6c8a4a15278e 100644
> --- a/drivers/staging/media/lirc/lirc_imon.c
> +++ b/drivers/staging/media/lirc/lirc_imon.c
> @@ -182,7 +182,7 @@ MODULE_DESCRIPTION(MOD_DESC);
>  MODULE_VERSION(MOD_VERSION);
>  MODULE_LICENSE("GPL");
>  MODULE_DEVICE_TABLE(usb, imon_usb_id_table);
> -module_param(debug, int, S_IRUGO | S_IWUSR);
> +module_param(debug, int, 0644);
>  MODULE_PARM_DESC(debug, "Debug messages: 0=no, 1=yes(default: no)");
>  
>  static void free_imon_context(struct imon_context *context)

In the current media tree, drivers/staging/media/lirc/lirc_imon.c has
been merged with drivers/media/rc/imon.c already, I'm afraid. This
patch no longer applies.


Sean
