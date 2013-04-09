Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:36082 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935228Ab3DIKqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 06:46:08 -0400
Date: Tue, 9 Apr 2013 11:46:05 +0100
From: Sean Young <sean@mess.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@redhat.com, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rc: ttusbir: fix potential double free in
 ttusbir_probe()
Message-ID: <20130409104605.GA15918@pequod.mess.org>
References: <CAPgLHd-EpQB2HjpH6pGnDLzvLUyKYSmyPfqQyCWa7CPz0V9d=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-EpQB2HjpH6pGnDLzvLUyKYSmyPfqQyCWa7CPz0V9d=g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 09, 2013 at 05:43:09PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Since rc_unregister_device() frees its argument, the subsequently
> call to rc_free_device() on the same variable will cause a double
> free bug. Fix by set argument to NULL, thus when fall through to
> rc_free_device(), nothing will be done there.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/media/rc/ttusbir.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
> index cf0d47f..891762d 100644
> --- a/drivers/media/rc/ttusbir.c
> +++ b/drivers/media/rc/ttusbir.c
> @@ -347,6 +347,7 @@ static int ttusbir_probe(struct usb_interface *intf,
>  	return 0;
>  out3:
>  	rc_unregister_device(rc);
> +	rc = NULL;
>  out2:
>  	led_classdev_unregister(&tt->led);
>  out:

The patch is right, so thanks for that. However, some else has beaten you
to it, I'm afraid:

http://www.spinics.net/lists/linux-media/msg62058.html

I guess it's up Mauro to decide which one to accept.


Sean
