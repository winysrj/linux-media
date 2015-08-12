Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbbHLPtb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 11:49:31 -0400
Date: Wed, 12 Aug 2015 08:49:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aparna Karuthodi <kdasaparna@gmail.com>
Cc: devel@driverdev.osuosl.org, mchehab@osg.samsung.com,
	jarod@wilsonet.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media:lirc: Added a newline character after
 declaration
Message-ID: <20150812154930.GA13396@kroah.com>
References: <1439392302-3579-1-git-send-email-kdasaparna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1439392302-3579-1-git-send-email-kdasaparna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 12, 2015 at 08:41:42PM +0530, Aparna Karuthodi wrote:
> Added a newline character to remove a coding style warning detected
> by checkpatch.
> 
> The warning is given below:
> drivers/staging/media/lirc/lirc_serial.c:1169: WARNING: quoted string split
> across lines
> 
> Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_serial.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
> index 19628d0..628577f 100644
> --- a/drivers/staging/media/lirc/lirc_serial.c
> +++ b/drivers/staging/media/lirc/lirc_serial.c
> @@ -1165,7 +1165,7 @@ module_init(lirc_serial_init_module);
>  module_exit(lirc_serial_exit_module);
>  
>  MODULE_DESCRIPTION("Infra-red receiver driver for serial ports.");
> -MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff, "
> +MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff,\n"
>  	      "Christoph Bartelmus, Andrei Tanas");

No, you just changed the way this string looks, that's not ok at all.

This is fine the way it is, you can ignore it.
