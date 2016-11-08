Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:54849 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752196AbcKHLXq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 06:23:46 -0500
Date: Tue, 8 Nov 2016 11:23:42 +0000
From: Sean Young <sean@mess.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@kernel.org, wsa-dev@sang-engineering.com,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        akpm@linux-foundation.org, patrick.boettcher@posteo.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: fix uninitialized variable warning in
 dib0700_rc_urb_completion()
Message-ID: <20161108112341.GA20598@gofer.mess.org>
References: <20161107154114.26803-1-shuahkh@osg.samsung.com>
 <20161107154114.26803-2-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161107154114.26803-2-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 07, 2016 at 08:41:12AM -0700, Shuah Khan wrote:
> Fix the following uninitialized variable compiler warning:
> 
> drivers/media/usb/dvb-usb/dib0700_core.c: In function ‘dib0700_rc_urb_completion’:
>  drivers/media/usb/dvb-usb/dib0700_core.c:763:2: warning: ‘protocol’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    rc_keydown(d->rc_dev, protocol, keycode, toggle);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/usb/dvb-usb/dib0700_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
> index f319665..cfe28ec 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_core.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_core.c
> @@ -676,7 +676,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
>  {
>  	struct dvb_usb_device *d = purb->context;
>  	struct dib0700_rc_response *poll_reply;
> -	enum rc_type protocol;
> +	enum rc_type protocol = RC_TYPE_UNKNOWN;
>  	u32 uninitialized_var(keycode);
>  	u8 toggle;
>  

There is another (better) fix for it here:

https://patchwork.linuxtv.org/patch/37516/


Thanks
Sean
