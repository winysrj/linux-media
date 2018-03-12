Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:40262 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751118AbeCLI3a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 04:29:30 -0400
Received: by mail-vk0-f51.google.com with SMTP id n82so5693329vkf.7
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2018 01:29:30 -0700 (PDT)
Received: from mail-vk0-f48.google.com (mail-vk0-f48.google.com. [209.85.213.48])
        by smtp.gmail.com with ESMTPSA id 93sm1451271uar.13.2018.03.12.01.29.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Mar 2018 01:29:27 -0700 (PDT)
Received: by mail-vk0-f48.google.com with SMTP id z190so5708960vkg.1
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2018 01:29:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1520843103.1513.8.camel@bootlin.com>
References: <20180220044425.169493-20-acourbot@chromium.org>
 <1520440654.1092.15.camel@bootlin.com> <6470b45d-e9dc-0a22-febc-cd18ae1092be@gmail.com>
 <1520842245.1513.5.camel@bootlin.com> <CAAFQd5A9mSP8Ufe-gn2Epa55M_NNOVaBL_cdWjdZ5PycbTvqbA@mail.gmail.com>
 <1520843103.1513.8.camel@bootlin.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 12 Mar 2018 17:29:06 +0900
Message-ID: <CAAFQd5BwXURe=6-Wu5MV1ak=JWrMa5Kw71HPA2i_g-3OGqYwxg@mail.gmail.com>
Subject: Re: [RFCv4,19/21] media: vim2m: add request support
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Dmitry Osipenko <digetx@gmail.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 12, 2018 at 5:25 PM, Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
> Hi,
>
> On Mon, 2018-03-12 at 17:15 +0900, Tomasz Figa wrote:
>> Hi Paul, Dmitry,
>>
>> On Mon, Mar 12, 2018 at 5:10 PM, Paul Kocialkowski
>> <paul.kocialkowski@bootlin.com> wrote:
>> > Hi,
>> >
>> > On Sun, 2018-03-11 at 22:42 +0300, Dmitry Osipenko wrote:
>> > > Hello,
>> > >
>> > > On 07.03.2018 19:37, Paul Kocialkowski wrote:
>> > > > Hi,
>> > > >
>> > > > First off, I'd like to take the occasion to say thank-you for
>> > > > your
>> > > > work.
>> > > > This is a major piece of plumbing that is required for me to add
>> > > > support
>> > > > for the Allwinner CedarX VPU hardware in upstream Linux. Other
>> > > > drivers,
>> > > > such as tegra-vde (that was recently merged in staging) are also
>> > > > badly
>> > > > in need of this API.
>> > >
>> > > Certainly it would be good to have a common UAPI. Yet I haven't
>> > > got my
>> > > hands on
>> > > trying to implement the V4L interface for the tegra-vde driver,
>> > > but
>> > > I've taken a
>> > > look at Cedrus driver and for now I've one question:
>> > >
>> > > Would it be possible (or maybe already is) to have a single IOCTL
>> > > that
>> > > takes input/output buffers with codec parameters, processes the
>> > > request(s) and returns to userspace when everything is done?
>> > > Having 5
>> > > context switches for a single frame decode (like Cedrus VAAPI
>> > > driver
>> > > does) looks like a bit of overhead.
>> >
>> > The V4L2 interface exposes ioctls for differents actions and I don't
>> > think there's a combined ioctl for this. The request API was
>> > introduced
>> > precisely because we need to have consistency between the various
>> > ioctls
>> > needed for each frame. Maybe one single (atomic) ioctl would have
>> > worked
>> > too, but that's apparently not how the V4L2 API was designed.
>> >
>> > I don't think there is any particular overhead caused by having n
>> > ioctls
>> > instead of a single one. At least that would be very surprising
>> > IMHO.
>>
>> Well, there is small syscall overhead, which normally shouldn't be
>> very painful, although with all the speculative execution hardening,
>> can't be sure of anything anymore. :)
>
> Oh, my mistake then, I had it in mind that it is not really something
> noticeable. Hopefully, it won't be a limiting factor in our cases.

With typical frame rates achievable by hardware codecs, I doubt that
it would be a limiting factor. We're using a similar API (a WiP
version of pre-Request API prototype from long ago) in Chrome OS
already without any performance issues.
