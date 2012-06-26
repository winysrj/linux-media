Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34622 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab2FZUms (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 16:42:48 -0400
Received: by pbbrp8 with SMTP id rp8so566211pbb.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 13:42:47 -0700 (PDT)
Date: Tue, 26 Jun 2012 13:42:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 3/4] em28xx: Workaround for new udev versions
Message-ID: <20120626204242.GC3885@kroah.com>
References: <4FE9169D.5020300@redhat.com>
 <1340739262-13747-1-git-send-email-mchehab@redhat.com>
 <1340739262-13747-4-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340739262-13747-4-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2012 at 04:34:21PM -0300, Mauro Carvalho Chehab wrote:
> New udev-182 seems to be buggy: even when usermode is enabled, it
> insists on needing that probe would defer any firmware requests.
> So, drivers with firmware need to defer probe for the first
> driver's core request, otherwise an useless penalty of 30 seconds
> happens, as udev will refuse to load any firmware.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
> 
> Note: this patch adds an ugly printk there, in order to allow testing it better.
> This will be removed at the final version.
> 
>  drivers/media/video/em28xx/em28xx-cards.c |   39 +++++++++++++++++++++++++----
>  1 file changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index 9229cd2..9a1c16c 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -60,6 +60,8 @@ static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
>  module_param_array(card,  int, NULL, 0444);
>  MODULE_PARM_DESC(card,     "card type");
>  
> +static bool is_em28xx_initialized;
> +
>  /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
>  static unsigned long em28xx_devused;
>  
> @@ -3167,11 +3169,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>  	 * postponed, as udev may not be ready yet to honour firmware
>  	 * load requests.
>  	 */
> +printk("em28xx: init = %d, userspace_is_disabled = %d, needs firmware = %d\n",
> +	is_em28xx_initialized,
> +	is_usermodehelp_disabled(), em28xx_boards[id->driver_info].needs_firmware);

debug code?

Also, this doesn't seem wise.  probe() will be called and
is_em28xx_initialized will be 0 before it can be set if the device is
present when the module is loaded.  But, if a new device is added to the
system after probe() already runs, is_em28xx_initialized will be 1, yet
it isn't true for this new device.

So this doesn't seem like a valid solution, even if you were wanting to
paper over a udev bug.


>  	if (em28xx_boards[id->driver_info].needs_firmware &&
> -	    is_usermodehelp_disabled()) {
> -		printk_once(KERN_DEBUG DRIVER_NAME
> -		            ": probe deferred for board %d.\n",
> -		            (unsigned)id->driver_info);
> +	    (!is_em28xx_initialized || is_usermodehelp_disabled())) {
> +		printk(KERN_DEBUG DRIVER_NAME
> +		       ": probe deferred for board %d.\n",
> +		       (unsigned)id->driver_info);
>  		return -EPROBE_DEFER;
>  	}
>  
> @@ -3456,4 +3461,28 @@ static struct usb_driver em28xx_usb_driver = {
>  	.id_table = em28xx_id_table,
>  };
>  
> -module_usb_driver(em28xx_usb_driver);

Hint, if you are removing this macro, you can almost be assured that you
are doing something wrong :)

thanks,

greg k-h
