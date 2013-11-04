Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33558 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3KDAuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:50:04 -0500
Received: by mail-pd0-f172.google.com with SMTP id w10so6058620pde.17
        for <linux-media@vger.kernel.org>; Sun, 03 Nov 2013 16:50:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1383399097-11615-29-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
	<1383399097-11615-29-git-send-email-m.chehab@samsung.com>
Date: Sun, 3 Nov 2013 19:50:02 -0500
Message-ID: <CAOcJUbzNZUE0RxM+2wcgfHnPudq+H7mzbKjY0QaO6L0pdq+Gsw@mail.gmail.com>
Subject: Re: [PATCHv2 28/29] mxl111sf: Don't use dynamic static allocation
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 2, 2013 at 9:31 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Dynamic static allocation is evil, as Kernel stack is too low, and
> compilation complains about it on some archs:
>
>         drivers/media/usb/dvb-usb-v2/mxl111sf.c:74:1: warning: 'mxl111sf_ctrl_msg' uses dynamic stack allocation [enabled by default]
>
> Instead, let's enforce a limit for the buffer to be the max size of
> a control URB payload data (80 bytes).
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Michael Krufky <mkrufky@kernellabs.com>
> ---
>  drivers/media/usb/dvb-usb-v2/mxl111sf.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> index e97964ef7f56..6538fd54c84e 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> @@ -57,7 +57,12 @@ int mxl111sf_ctrl_msg(struct dvb_usb_device *d,
>  {
>         int wo = (rbuf == NULL || rlen == 0); /* write-only */
>         int ret;
> -       u8 sndbuf[1+wlen];
> +       u8 sndbuf[80];
> +
> +       if (1 + wlen > sizeof(sndbuf)) {
> +               pr_warn("%s: len=%d is too big!\n", __func__, wlen);
> +               return -EREMOTEIO;
> +       }
>
>         pr_debug("%s(wlen = %d, rlen = %d)\n", __func__, wlen, rlen);
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I don't really love this, but I see your point. You're right - this
needs to be fixed.

AFAIK, the largest transfer the driver ever does is 61 bytes, but I'd
have to double check to be sure...

Is there a #define'd macro that we could place there instead of the
hardcoded '80' ?  I really don't like the number '80' there,
*especially* not without a comment explaining it.  Is 80 even the
maximum size of control urb payload data?  Are you sure it isn't 64?

http://wiki.osdev.org/Universal_Serial_Bus#Maximum_Data_Payload_Size

...as per the article above, we should be able to read the actual
maximum size from the USB endpoint itself, but then again, that would
leave us with another dynamic static allocation.

How about if we kzalloc the buffer instead?  (maybe not - that isn't
very efficient either)

If it has to be a static allocation (and it probably should be),
please #define the size rather than sticking in the number 80.

This feedback applies to your entire "Don't use dynamic static
allocation" patch series.  Please don't merge those without at least
#define'ing the size value and adding an appropriate inline comment to
explain why the maximum is defined as such.

Cheers,

Mike
