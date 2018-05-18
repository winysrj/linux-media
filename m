Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:46489 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeERPlp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 11:41:45 -0400
Received: by mail-vk0-f54.google.com with SMTP id i190-v6so5073245vkd.13
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 08:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <20180517160708.74811cfb@vento.lan> <3216261.G88TfqiCiH@avalon>
 <20180518082447.3068c34c@vento.lan> <1568098.156aR60jyk@avalon> <7f9f800349eb45fb9c3a96b37f238fab0a610ee4.camel@ndufresne.ca>
In-Reply-To: <7f9f800349eb45fb9c3a96b37f238fab0a610ee4.camel@ndufresne.ca>
From: Tomasz Figa <tfiga@google.com>
Date: Sat, 19 May 2018 00:41:32 +0900
Message-ID: <CAAFQd5A9ZexVKqavyzdWyfOwxPd8+CTafk6Zpi161R_3hXCAVA@mail.gmail.com>
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based cameras
 on generic apps
To: nicolas@ndufresne.ca
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab+samsung@kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        wtaymans@redhat.com, schaller@redhat.com,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 19, 2018 at 12:15 AM Nicolas Dufresne <nicolas@ndufresne.ca>
wrote:

> Le vendredi 18 mai 2018 =C3=A0 15:38 +0300, Laurent Pinchart a =C3=A9crit=
 :
> > > Before libv4l, media support for a given device were limited to a few
> > > apps that knew how to decode the format. There were even cases were a
> > > proprietary app were required, as no open source decoders were
available.
> > >
> > > From my PoV, the biggest gain with libv4l is that the same group of
> > > maintainers can ensure that the entire solution (Kernel driver and
> > > low level userspace support) will provide everything required for an
> > > open source app to work with it.
> > >
> > > I'm not sure how we would keep enforcing it if the pipeline setting
> > > and control propagation logic for an specific hardware will be
> > > delegated to PipeWire. It seems easier to keep doing it on a libv4l
> > > (version 2) and let PipeWire to use it.
> >
> > I believe we need to first study pipewire in more details. I have no
personal
> > opinion yet as I haven't had time to investigate it. That being said, I
don't
> > think that libv4l with closed-source plugins would be much better than =
a
> > closed-source pipewire plugin. What main concern once we provide a
userspace
> > camera stack API is that vendors might implement that API in a
closed-source
> > component that calls to a kernel driver implementing a custom API, with
all
> > knowledge about the camera located in the closed-source component. I'm
not
> > sure how to prevent that, my best proposal would be to make V4L2 so
useful
> > that vendors wouldn't even think about a different solution (possibly
coupled
> > by the pressure put by platform vendors such as Google who mandate
upstream
> > kernel drivers for Chrome OS, but that's still limited as even when it
comes
> > to Google there's no such pressure on the Android side).

> If there is proprietary plugins, then I don't think it will make any
> difference were this is implemented. The difference is the feature set
> we expose. 3A is per device, but multiple streams, with per request
> controls is also possible. PipeWire gives central place to manage this,
> while giving multiple process access to the camera streams. I think in
> the end, what fits better would be something like or the Android Camera
> HAL2. But we could encourage OSS by maintaining a base implementation
> that covers all the V4L2 aspect, leaving only the 3A aspect of the work
> to be done. Maybe we need to come up with an abstraction that does not
> prevent multi-streams, but only requires 3A per vendors (saying per
> vendors, as some of this could be Open Source by third parties).

> just thinking out loud now ;-P
> Nicolas

> p.s. Do we have the Intel / IPU3 folks in in the loop ? This is likely
> the most pressing HW as it's shipping on many laptops now.

Yes, I added Jerry, Raj and Sakari to the first post and also this one.

Best regards,
Tomasz
