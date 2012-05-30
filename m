Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34088 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2E3Mt5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 08:49:57 -0400
Received: by yhmm54 with SMTP id m54so3165082yhm.19
        for <linux-media@vger.kernel.org>; Wed, 30 May 2012 05:49:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFBinCCuf5Uywqv=3aqO9e10u1T3o2wFVqn4HpRX2QKmO8kxfA@mail.gmail.com>
References: <1338154013-5124-3-git-send-email-martin.blumenstingl@googlemail.com>
	<1338325692-19684-1-git-send-email-martin.blumenstingl@googlemail.com>
	<CAOMZO5Bmc3cesaJ_y_NgSaAPYQpcwOUtn_6TX=khg7k=4da-Bg@mail.gmail.com>
	<CAFBinCCy4f84F-G8pup5sesc+GNr13pWakKkfzYxxChnrpQx2Q@mail.gmail.com>
	<CAFBinCBeO7Y+HPoWSnv643idxkUW-TU28sosPn_dcgVQHYXxjg@mail.gmail.com>
	<CAOMZO5AFVfXgWX=DwqALDLdLz-ZYRMipAegXeyxhDfCX2HN+RA@mail.gmail.com>
	<CAFBinCCuf5Uywqv=3aqO9e10u1T3o2wFVqn4HpRX2QKmO8kxfA@mail.gmail.com>
Date: Wed, 30 May 2012 09:49:56 -0300
Message-ID: <CALF0-+Wp7VS8jPWZV0NiX2d352R8QQaRT8M0L3pAwHY79ruV2g@mail.gmail.com>
Subject: Re: [PATCH] [media] em28xx: Show a warning if the board does not
 support remote controls
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Tue, May 29, 2012 at 7:24 PM, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> What would you use as the first (dev) argument for dev_*?
> I simply tried using the USB-device (&dev->udev->dev) there, and I
> think it's less
> descriptive if one removes the driver name and the board number:
> usb 1-1.2: Remote control support is not available for this device.
>
> What do you think about using dev_warn but still including the driver name
> and the board number?

You should use em28xx_warn, or any other em28xx_XXX for em28xx tracing.
This way you'll get all the driver name in your message.

#define em28xx_warn(fmt, arg...) do {\
        printk(KERN_WARNING "%s: "fmt,\
                        dev->name , ##arg); } while (0)

Hope it helps,
Ezequiel.
