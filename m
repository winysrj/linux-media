Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35684 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbdGCJC7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 05:02:59 -0400
Date: Mon, 3 Jul 2017 11:02:56 +0200
From: Johan Hovold <johan@kernel.org>
To: Lars Melin <larsm17@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Sebastian <sebastian@iseclab.org>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: Null Pointer Dereference in mceusb
Message-ID: <20170703090256.GF7084@localhost>
References: <CAL8_TH8JTPd5ki-v-+T-Z+VGRg-vfsx=rYMjKq_vbUfTBPff3w@mail.gmail.com>
 <20170601072023.GM6735@localhost>
 <CAL8_TH8xEd0i2VDgZwsh_Jcpt3f4D=xitbKSR_3YYRxek=denA@mail.gmail.com>
 <20170703081019.GA7084@localhost>
 <c7dbd628-6176-3a0b-eaec-b8e2549ca50f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7dbd628-6176-3a0b-eaec-b8e2549ca50f@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 03, 2017 at 03:41:59PM +0700, Lars Melin wrote:
> On 2017-07-03 15:10, Johan Hovold wrote:
> > On Thu, Jun 29, 2017 at 07:41:24PM +0200, Sebastian wrote:
> >> Sorry for the long delay, Johan.
> >>
> >> 2017-06-01 9:20 GMT+02:00 Johan Hovold <johan@kernel.org>:
> >>> [ +CC: media list ]
> >>>
> >>> On Wed, May 31, 2017 at 08:25:42PM +0200, Sebastian wrote:
> >>>
> >>> What is the lsusb -v output for your device? And have you successfully
> >>> used this device with this driver before?
> >>>
> >>
> >> No, the device wasn't successfully used before that- it crashed every time,
> >> so I threw away the usb receiver. This is also the reason why I cannot give
> >> you the lsusb output. But I can give you the VID:PID -> 03ee:2501 if that
> >> is of any help?
> > 
> > Ok, so it's not necessarily a (recent) regression at least. I can't seem
> > to find anyone else posting lsusb -v output for that device
> > unfortunately.
> > 
> 
> Googling "03ee:2501 bDescriptorType" leads us to:
> https://sourceforge.net/p/lirc/mailman/message/12852102/

Thanks, Lars. Appears I didn't google hard enough.

Well that device has both a bulk IN and OUT endpoint, so if Sebastian's
device has the same descriptors, I'm left without an hypothesis as to
what would have caused the crash.

We'd need to get this verified on a recent mainline kernel (rather than
an older Ubuntu one) and then take it from there.

Thanks,
Johan
