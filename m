Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:41218 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933071AbeFGRxg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 13:53:36 -0400
Received: by mail-qk0-f193.google.com with SMTP id w23-v6so7106096qkb.8
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 10:53:36 -0700 (PDT)
Message-ID: <3c852dec2279fa95af268357a438d442ddb70d44.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Tomasz Figa <tfiga@chromium.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: dave.stevenson@raspberrypi.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Thu, 07 Jun 2018 13:53:33 -0400
In-Reply-To: <CAAFQd5BSq+kz0xxrFVFKhA4XFJE1hF8NHomQSGqYzNo+Swdyyw@mail.gmail.com>
References: <20180605103328.176255-1-tfiga@chromium.org>
         <20180605103328.176255-2-tfiga@chromium.org>
         <CAAoAYcOJ5Q2rHqGEmcStxxXj423a3ddKOSzvwRV6R5-UxhM+Hg@mail.gmail.com>
         <b767d9d7-5a26-f6f8-3978-81e8d60769c2@xs4all.nl>
         <CAAFQd5BSq+kz0xxrFVFKhA4XFJE1hF8NHomQSGqYzNo+Swdyyw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 07 juin 2018 à 16:30 +0900, Tomasz Figa a écrit :
> > > v4l2-compliance (so probably one for Hans).
> > > testUnlimitedOpens tries opening the device 100 times. On a normal
> > > device this isn't a significant overhead, but when you're allocating
> > > resources on a per instance basis it quickly adds up.
> > > Internally I have state that has a limit of 64 codec instances (either
> > > encode or decode), so either I allocate at start_streaming and fail on
> > > the 65th one, or I fail on open. I generally take the view that
> > > failing early is a good thing.
> > > Opinions? Is 100 instances of an M2M device really sensible?
> > 
> > Resources should not be allocated by the driver until needed (i.e. the
> > queue_setup op is a good place for that).
> > 
> > It is perfectly legal to open a video node just to call QUERYCAP to
> > see what it is, and I don't expect that to allocate any hardware resources.
> > And if I want to open it 100 times, then that should just work.
> > 
> > It is *always* wrong to limit the number of open arbitrarily.
> 
> That's a valid point indeed. Besides the querying use case, userspace
> might just want to pre-open a bigger number of instances, but it
> doesn't mean that they would be streaming all at the same time indeed.

We have used in GStreamer the open() failure to be able to fallback to
software when the instances are exhausted. The pros was it fails really
early, so falling back is easy. If you remove this, it might not fail
before STREAMON. At least in GStreamer, it too late to fallback to
software.  So I don't have better idea then limiting on Open calls.

Nicolas
