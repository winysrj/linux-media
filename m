Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:44708 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeFGHac (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 03:30:32 -0400
Received: by mail-vk0-f66.google.com with SMTP id x4-v6so5424753vkx.11
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 00:30:31 -0700 (PDT)
Received: from mail-vk0-f43.google.com (mail-vk0-f43.google.com. [209.85.213.43])
        by smtp.gmail.com with ESMTPSA id z34-v6sm10278551uab.14.2018.06.07.00.30.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Jun 2018 00:30:29 -0700 (PDT)
Received: by mail-vk0-f43.google.com with SMTP id w8-v6so5440225vkh.4
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 00:30:29 -0700 (PDT)
MIME-Version: 1.0
References: <20180605103328.176255-1-tfiga@chromium.org> <20180605103328.176255-2-tfiga@chromium.org>
 <CAAoAYcOJ5Q2rHqGEmcStxxXj423a3ddKOSzvwRV6R5-UxhM+Hg@mail.gmail.com> <b767d9d7-5a26-f6f8-3978-81e8d60769c2@xs4all.nl>
In-Reply-To: <b767d9d7-5a26-f6f8-3978-81e8d60769c2@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 7 Jun 2018 16:30:16 +0900
Message-ID: <CAAFQd5BSq+kz0xxrFVFKhA4XFJE1hF8NHomQSGqYzNo+Swdyyw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: dave.stevenson@raspberrypi.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org, nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 7, 2018 at 4:22 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 06/05/2018 03:10 PM, Dave Stevenson wrote:
> > Hi Tomasz.
> >
> > Thanks for formalising this.
> > I'm working on a stateful V4L2 codec driver on the Raspberry Pi and
> > was having to deduce various implementation details from other
> > drivers. I know how much we all tend to hate having to write
> > documentation, but it is useful to have.
> >
> > On 5 June 2018 at 11:33, Tomasz Figa <tfiga@chromium.org> wrote:
> >> Due to complexity of the video decoding process, the V4L2 drivers of
> >> stateful decoder hardware require specific sequencies of V4L2 API call=
s
> >> to be followed. These include capability enumeration, initialization,
> >> decoding, seek, pause, dynamic resolution change, flush and end of
> >> stream.
> >>
> >> Specifics of the above have been discussed during Media Workshops at
> >> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> >> Conference Europe 2014 in D=C3=BCsseldorf. The de facto Codec API that
> >> originated at those events was later implemented by the drivers we alr=
eady
> >> have merged in mainline, such as s5p-mfc or mtk-vcodec.
> >>
> >> The only thing missing was the real specification included as a part o=
f
> >> Linux Media documentation. Fix it now and document the decoder part of
> >> the Codec API.
> >>
> >> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> >> ---
> >>  Documentation/media/uapi/v4l/dev-codec.rst | 771 ++++++++++++++++++++=
+
> >>  Documentation/media/uapi/v4l/v4l2.rst      |  14 +-
> >>  2 files changed, 784 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentatio=
n/media/uapi/v4l/dev-codec.rst
> >> index c61e938bd8dc..0483b10c205e 100644
> >> --- a/Documentation/media/uapi/v4l/dev-codec.rst
> >> +++ b/Documentation/media/uapi/v4l/dev-codec.rst
> >> @@ -34,3 +34,774 @@ the codec and reprogram it whenever another file h=
andler gets access.
> >>  This is different from the usual video node behavior where the video
> >>  properties are global to the device (i.e. changing something through =
one
> >>  file handle is visible through another file handle).
> >
> > I know this isn't part of the changes, but raises a question in
> > v4l2-compliance (so probably one for Hans).
> > testUnlimitedOpens tries opening the device 100 times. On a normal
> > device this isn't a significant overhead, but when you're allocating
> > resources on a per instance basis it quickly adds up.
> > Internally I have state that has a limit of 64 codec instances (either
> > encode or decode), so either I allocate at start_streaming and fail on
> > the 65th one, or I fail on open. I generally take the view that
> > failing early is a good thing.
> > Opinions? Is 100 instances of an M2M device really sensible?
>
> Resources should not be allocated by the driver until needed (i.e. the
> queue_setup op is a good place for that).
>
> It is perfectly legal to open a video node just to call QUERYCAP to
> see what it is, and I don't expect that to allocate any hardware resource=
s.
> And if I want to open it 100 times, then that should just work.
>
> It is *always* wrong to limit the number of open arbitrarily.

That's a valid point indeed. Besides the querying use case, userspace
might just want to pre-open a bigger number of instances, but it
doesn't mean that they would be streaming all at the same time indeed.

Best regards,
Tomasz
