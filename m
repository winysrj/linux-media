Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33440 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbdGCIKX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 04:10:23 -0400
Date: Mon, 3 Jul 2017 10:10:19 +0200
From: Johan Hovold <johan@kernel.org>
To: Sebastian <sebastian@iseclab.org>
Cc: Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: Null Pointer Dereference in mceusb
Message-ID: <20170703081019.GA7084@localhost>
References: <CAL8_TH8JTPd5ki-v-+T-Z+VGRg-vfsx=rYMjKq_vbUfTBPff3w@mail.gmail.com>
 <20170601072023.GM6735@localhost>
 <CAL8_TH8xEd0i2VDgZwsh_Jcpt3f4D=xitbKSR_3YYRxek=denA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL8_TH8xEd0i2VDgZwsh_Jcpt3f4D=xitbKSR_3YYRxek=denA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 29, 2017 at 07:41:24PM +0200, Sebastian wrote:
> Sorry for the long delay, Johan.
> 
> 2017-06-01 9:20 GMT+02:00 Johan Hovold <johan@kernel.org>:
> > [ +CC: media list ]
> >
> > On Wed, May 31, 2017 at 08:25:42PM +0200, Sebastian wrote:
> >
> > What is the lsusb -v output for your device? And have you successfully
> > used this device with this driver before?
> >
> 
> No, the device wasn't successfully used before that- it crashed every time,
> so I threw away the usb receiver. This is also the reason why I cannot give
> you the lsusb output. But I can give you the VID:PID -> 03ee:2501 if that
> is of any help?

Ok, so it's not necessarily a (recent) regression at least. I can't seem
to find anyone else posting lsusb -v output for that device
unfortunately.

> > Can you reproduce this with a more recent mainline kernel (e.g.
> > 4.11.3)?
> 
> Unfortunately no :(
> 
> >
> > This looks like something which could happen if the device is lacking an
> > OUT endpoint, and a sanity check to catch that recently went in (and was
> > backported to the non-EOL stable trees).
> 
> I could buy the same device again and try?

If you're willing to that, that'd very helpful; either to verify that
the crash is already fixed (as mentioned above), or to allow us to track
down the separate issue.

Thanks,
Johan
