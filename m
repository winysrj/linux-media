Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f180.google.com ([209.85.160.180]:56495 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2E2WcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 18:32:22 -0400
Received: by ghbz12 with SMTP id z12so2675973ghb.11
        for <linux-media@vger.kernel.org>; Tue, 29 May 2012 15:32:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5AFVfXgWX=DwqALDLdLz-ZYRMipAegXeyxhDfCX2HN+RA@mail.gmail.com>
References: <1338154013-5124-3-git-send-email-martin.blumenstingl@googlemail.com>
 <1338325692-19684-1-git-send-email-martin.blumenstingl@googlemail.com>
 <CAOMZO5Bmc3cesaJ_y_NgSaAPYQpcwOUtn_6TX=khg7k=4da-Bg@mail.gmail.com>
 <CAFBinCCy4f84F-G8pup5sesc+GNr13pWakKkfzYxxChnrpQx2Q@mail.gmail.com>
 <CAFBinCBeO7Y+HPoWSnv643idxkUW-TU28sosPn_dcgVQHYXxjg@mail.gmail.com> <CAOMZO5AFVfXgWX=DwqALDLdLz-ZYRMipAegXeyxhDfCX2HN+RA@mail.gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Wed, 30 May 2012 00:24:30 +0200
Message-ID: <CAFBinCCuf5Uywqv=3aqO9e10u1T3o2wFVqn4HpRX2QKmO8kxfA@mail.gmail.com>
Subject: Re: [PATCH] [media] em28xx: Show a warning if the board does not
 support remote controls
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What would you use as the first (dev) argument for dev_*?
I simply tried using the USB-device (&dev->udev->dev) there, and I
think it's less
descriptive if one removes the driver name and the board number:
usb 1-1.2: Remote control support is not available for this device.

What do you think about using dev_warn but still including the driver name
and the board number?

On Tue, May 29, 2012 at 11:28 PM, Fabio Estevam <festevam@gmail.com> wrote:
> On Tue, May 29, 2012 at 6:26 PM, Martin Blumenstingl
> <martin.blumenstingl@googlemail.com> wrote:
>> Hello Fabio,
>>
>> I can use dev_err if you want.
>
> Or maybe dev_warn is better since this is a warning.
