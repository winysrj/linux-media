Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48919 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755240AbcJMVQe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 17:16:34 -0400
Date: Thu, 13 Oct 2016 22:14:07 +0100
From: Sean Young <sean@mess.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] dib0700: Fix uninitialized protocol for NEC
 repeat codes
Message-ID: <20161013211407.GB21731@gofer.mess.org>
References: <1476366699-21611-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1476366699-21611-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2016 at 03:51:39PM +0200, Geert Uytterhoeven wrote:
>     drivers/media/usb/dvb-usb/dib0700_core.c: In function ‘dib0700_rc_urb_completion’:
>     drivers/media/usb/dvb-usb/dib0700_core.c:679: warning: ‘protocol’ may be used uninitialized in this function
> 
> When receiving an NEC repeat code, protocol is indeed not initialized.
> Set it to RC_TYPE_NECX to fix this.
> 
> Fixes: 2ceeca0499d74521 ("[media] rc: split nec protocol into its three variants")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Is RC_TYPE_NECX correct, or should it be RC_TYPE_NEC?
> I used RC_TYPE_NECX based on the checks for {,not_}data and
> {,not_}system for the other cases.

It should be the protocol that the last scancode was received with. This
code path is very broken; it calls:

	rc_keydown(d->rc_dev, protocol, keycode, toggle);

But keycode in this codepath is never set. Luckily keycode is declared as:

	u32 uninitialized_var(keycode);

I've got another patch for this which I'll send as a reply to this.


Sean


> ---
>  drivers/media/usb/dvb-usb/dib0700_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
> index f3196658fb700706..5878ae4d20ad27ed 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_core.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_core.c
> @@ -718,6 +718,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
>  		    poll_reply->nec.data       == 0x00 &&
>  		    poll_reply->nec.not_data   == 0xff) {
>  			poll_reply->data_state = 2;
> +			protocol = RC_TYPE_NECX;
>  			break;
>  		}
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
