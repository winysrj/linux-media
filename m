Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38086
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932247AbcKHVil (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2016 16:38:41 -0500
Date: Tue, 8 Nov 2016 19:38:34 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Benjamin Larsson <benjamin@southpole.se>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [v4.9-rc4] dvb-usb/cinergyT2 NULL pointer dereference
Message-ID: <20161108193834.4b90145b@vento.lan>
In-Reply-To: <354bc87c-79a1-bb37-6225-988c8fa429a5@southpole.se>
References: <CADDKRnD6sQLsxwObi1Bo6k69P5ceqQHw7beT6C7TqZjUsDby+w@mail.gmail.com>
        <CA+55aFxXoc3GzAXWPZL=RB2xhmhP1acR3m2S_mdoiO97+80kDA@mail.gmail.com>
        <20161108182215.41f1f3d2@vento.lan>
        <354bc87c-79a1-bb37-6225-988c8fa429a5@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 8 Nov 2016 22:15:24 +0100
Benjamin Larsson <benjamin@southpole.se> escreveu:

> On 11/08/2016 09:22 PM, Mauro Carvalho Chehab wrote:
> > Em Tue, 8 Nov 2016 10:42:03 -0800
> > Linus Torvalds <torvalds@linux-foundation.org> escreveu:
> >
> >> On Sun, Nov 6, 2016 at 7:40 AM, Jörg Otte <jrg.otte@gmail.com> wrote:
> >>> Since v4.9-rc4 I get following crash in dvb-usb-cinergyT2 module.
> >>
> >> Looks like it's commit 5ef8ed0e5608f ("[media] cinergyT2-core: don't
> >> do DMA on stack"), which movced the DMA data array from the stack to
> >> the "private" pointer. In the process it also added serialization in
> >> the form of "data_mutex", but and now it oopses on that mutex because
> >> the private pointer is NULL.
> >>
> >> It looks like the "->private" pointer is allocated in dvb_usb_adapter_init()
> >>
> >> cinergyt2_usb_probe ->
> >>   dvb_usb_device_init ->
> >>     dvb_usb_init() ->
> >>       dvb_usb_adapter_init()
> >>
> >> but the dvb_usb_init() function calls dvb_usb_device_power_ctrl()
> >> (which calls the "power_ctrl" function, which is
> >> cinergyt2_power_ctrl() for that drive) *before* it initializes the
> >> private field.
> >>
> >> Mauro, Patrick, could dvb_usb_adapter_init() be called earlier, perhaps?
> >
> > Calling it earlier won't work, as we need to load the firmware before
> > sending the power control commands on some devices.
> >
> > Probably the best here is to pass an extra optional function parameter
> > that will initialize the mutex before calling any functions.
> >
> > Btw, if it broke here, the DMA fixes will likely break on other drivers.
> > So, after Jörg tests this patch, I'll work on a patch series addressing
> > this issue on the other drivers I touched.
> >
> > Regards,
> > Mauro
> 
> Just for reference I got the following call trace a week ago. I looks 
> like this confirms that other drivers are affected also.

Yeah, I avoided serializing the logic that detects if the firmware is
loaded, but forgot that the power control had the same issue. The
newer dvb usb drivers use the dvb-usb-v2, so I didn't touch this
code for a while.

I'll need to review all touched drivers to be sure that they'll all
do the right thing. The good news is that it will likely simplify
the drivers' logic a little bit.

Thanks,
Mauro
