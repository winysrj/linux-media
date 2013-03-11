Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:51634 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3CKWt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 18:49:59 -0400
Date: Mon, 11 Mar 2013 23:49:45 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] m920x: silence compiler warning
Message-Id: <20130311234945.8c33a51a5fd74b8386a71faf@studenti.unina.it>
In-Reply-To: <1363022710-27886-1-git-send-email-crope@iki.fi>
References: <1363022710-27886-1-git-send-email-crope@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 11 Mar 2013 19:25:10 +0200
Antti Palosaari <crope@iki.fi> wrote:

> drivers/media/usb/dvb-usb/m920x.c: In function ‘m920x_probe’:
> drivers/media/usb/dvb-usb/m920x.c:91:6: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized]
> drivers/media/usb/dvb-usb/m920x.c:70:6: note: ‘ret’ was declared here
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Acked-by: Antonio Ospite <ospite@studenti.unina.it>

And thanks.

BTW Antti, there was another patch for this warning:
http://thread.gmane.org/gmane.linux.kernel/1450717
but your change is easier to validate.

> ---
>  drivers/media/usb/dvb-usb/m920x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
> index 92afeb2..f5e4654 100644
> --- a/drivers/media/usb/dvb-usb/m920x.c
> +++ b/drivers/media/usb/dvb-usb/m920x.c
> @@ -67,7 +67,7 @@ static inline int m920x_write(struct usb_device *udev, u8 request,
>  static inline int m920x_write_seq(struct usb_device *udev, u8 request,
>  				  struct m920x_inits *seq)
>  {
> -	int ret;
> +	int ret = 0;
>  	while (seq->address) {
>  		ret = m920x_write(udev, request, seq->data, seq->address);
>  		if (ret != 0)
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
