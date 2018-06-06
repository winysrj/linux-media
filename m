Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:45711 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbeFFLRM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 07:17:12 -0400
Received: by mail-vk0-f68.google.com with SMTP id n134-v6so3407879vke.12
        for <linux-media@vger.kernel.org>; Wed, 06 Jun 2018 04:17:11 -0700 (PDT)
Received: from mail-vk0-f44.google.com (mail-vk0-f44.google.com. [209.85.213.44])
        by smtp.gmail.com with ESMTPSA id x13-v6sm3031571uan.5.2018.06.06.04.17.09
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jun 2018 04:17:09 -0700 (PDT)
Received: by mail-vk0-f44.google.com with SMTP id b134-v6so3402928vke.13
        for <linux-media@vger.kernel.org>; Wed, 06 Jun 2018 04:17:09 -0700 (PDT)
MIME-Version: 1.0
References: <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
 <20180319120043.GA20451@amd> <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
 <20180319095544.7e235a3e@vento.lan> <20180515200117.GA21673@amd>
 <20180515190314.2909e3be@vento.lan> <20180602210145.GB20439@amd>
 <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
 <20180606084612.GB18743@amd> <CAAFQd5CGKd=jP+h5b7HwSgd5HBoQFUX8Vd6pKLzzJFtCSukBLg@mail.gmail.com>
 <20180606105116.GA4328@amd>
In-Reply-To: <20180606105116.GA4328@amd>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 6 Jun 2018 20:16:56 +0900
Message-ID: <CAAFQd5Cy+77D-hr1k7QVrxaGhsGqM8rrqCKAk9Z+GoHEG=Q_mw@mail.gmail.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex pipeline
To: Pavel Machek <pavel@ucw.cz>
Cc: mchehab+samsung@kernel.org, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 6, 2018 at 7:51 PM Pavel Machek <pavel@ucw.cz> wrote:
>
> HI!
>
> > > > Thanks for coming up with this proposal. Please see my comments below.
> > > >
> > > > > Ok, can I get any comments on this one?
> > > > > v4l2_open_complex("/file/with/descriptor", 0) can be used to open
> > > > > whole pipeline at once, and work if it as if it was one device.
> > > >
> > > > I'm not convinced if we should really be piggy backing on libv4l, but
> > > > it's just a matter of where we put the code added by your patch, so
> > > > let's put that aside.
> > >
> > > There was some talk about this before, and libv4l2 is what we came
> > > with. Only libv4l2 is in position to propagate controls to right
> > > devices.
> > >
> > > > Who would be calling this function?
> > > >
> > > > The scenario that I could think of is:
> > > > - legacy app would call open(/dev/video?), which would be handled by
> > > > libv4l open hook (v4l2_open()?),
> > >
> > > I don't think that kind of legacy apps is in use any more. I'd prefer
> > > not to deal with them.
> >
> > In another thread ("[ANN v2] Complex Camera Workshop - Tokyo - Jun,
> > 19"), Mauro has mentioned a number of those:
> >
> > "open source ones (Camorama, Cheese, Xawtv, Firefox, Chromium, ...) and closed
> > source ones (Skype, Chrome, ...)"
>
> Thanks for thread pointer... I may be able to get in using hangouts.
>
> Anyway, there's big difference between open("/dev/video0") and
> v4l2_open("/dev/video0"). I don't care about the first one, but yes we
> should be able to support the second one eventually.
>
> And I don't think Mauro says apps like Camorama are of open() kind.

I don't think there is much difference between open() and v4l2_open(),
since the former can be changed to the latter using LD_PRELOAD.

If we simply add v4l2_open_complex() to libv4l, we would have to get
developers of the applications (regardless of whether they use open()
or v4l2_open()) to also support v4l2_open_complex(). For testing
purposes of kernel developers it would work indeed, but I wonder if it
goes anywhere beyond that.

If all we need is some code to be able to test kernel camera drivers,
I don't think there is any big problem in adding v4l2_open_complex()
to libv4l. However, we must either ensure that either:
a) it's not going to be widely used
OR
b) it is designed well enough to cover the complex cases I mentioned
and which are likely to represent most of the hardware in the wild.

Best regards,
Tomasz
