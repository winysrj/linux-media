Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38812 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752777AbdF2Rlr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 13:41:47 -0400
Received: by mail-it0-f52.google.com with SMTP id k192so11446665ith.1
        for <linux-media@vger.kernel.org>; Thu, 29 Jun 2017 10:41:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170601072023.GM6735@localhost>
References: <CAL8_TH8JTPd5ki-v-+T-Z+VGRg-vfsx=rYMjKq_vbUfTBPff3w@mail.gmail.com>
 <20170601072023.GM6735@localhost>
From: Sebastian <sebastian@iseclab.org>
Date: Thu, 29 Jun 2017 19:41:24 +0200
Message-ID: <CAL8_TH8xEd0i2VDgZwsh_Jcpt3f4D=xitbKSR_3YYRxek=denA@mail.gmail.com>
Subject: Re: Null Pointer Dereference in mceusb
To: Johan Hovold <johan@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for the long delay, Johan.

2017-06-01 9:20 GMT+02:00 Johan Hovold <johan@kernel.org>:
> [ +CC: media list ]
>
> On Wed, May 31, 2017 at 08:25:42PM +0200, Sebastian wrote:
>
> What is the lsusb -v output for your device? And have you successfully
> used this device with this driver before?
>

No, the device wasn't successfully used before that- it crashed every time,
so I threw away the usb receiver. This is also the reason why I cannot give
you the lsusb output. But I can give you the VID:PID -> 03ee:2501 if that
is of any help?

>
> Can you reproduce this with a more recent mainline kernel (e.g.
> 4.11.3)?

Unfortunately no :(

>
> This looks like something which could happen if the device is lacking an
> OUT endpoint, and a sanity check to catch that recently went in (and was
> backported to the non-EOL stable trees).

I could buy the same device again and try?

Thanks for your help,
Sebastian
