Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35693 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbdEEPok (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 11:44:40 -0400
Received: by mail-wm0-f66.google.com with SMTP id b10so2115543wmh.2
        for <linux-media@vger.kernel.org>; Fri, 05 May 2017 08:44:40 -0700 (PDT)
Date: Fri, 5 May 2017 17:44:37 +0200
From: Thomas Hollstegge <thomas.hollstegge@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] em28xx: support for Sundtek MediaTV Digital Home
Message-ID: <20170505154435.GA18161@googlemail.com>
References: <20170504222115.GA26659@googlemail.com>
 <CA+O4pCJqqSqE_YFDM6unU8pvuVoRJijkNOv64AWD6CPdbxD5qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+O4pCJqqSqE_YFDM6unU8pvuVoRJijkNOv64AWD6CPdbxD5qA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Markus Rechberger <mrechberger@gmail.com> schrieb am Fri, 05. May 08:06:
> On Fri, May 5, 2017 at 6:21 AM, Thomas Hollstegge
> <thomas.hollstegge@gmail.com> wrote:
> > Sundtek MediaTV Digital Home is a rebranded MaxMedia UB425-TC with the
> > following components:
> >
> > USB bridge: Empia EM2874B
> > Demodulator: Micronas DRX 3913KA2
> > Tuner: NXP TDA18271HDC2
> >
> 
> Not that it matters a lot anymore for those units however the USB ID
> is allocated for multiple different units, this patch will break some
> of them.

I searched the kernel sources for USB IDs but didn't find any mention.
So what exactly will break with this commit? Is there a better way to
detect different devices besides USB IDs?

> If you want to use that use the unit with this driver you're on your
> own and have to assign it via sysfs and usb/bind.

I did, and it works fine. However, it would be nice if the driver
supported the devices directly.

> It was a joint project many years ago before we also started to design
> and manufacture our own units.

Interesting, thanks for sharing this insight!

Cheers
Thomas
