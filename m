Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:42309 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938729AbeE1MWE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 08:22:04 -0400
Received: by mail-ua0-f196.google.com with SMTP id x18-v6so979015uaj.9
        for <linux-media@vger.kernel.org>; Mon, 28 May 2018 05:22:03 -0700 (PDT)
Received: from mail-ua0-f180.google.com (mail-ua0-f180.google.com. [209.85.217.180])
        by smtp.gmail.com with ESMTPSA id h47-v6sm14883267uaa.13.2018.05.28.05.22.00
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 May 2018 05:22:01 -0700 (PDT)
Received: by mail-ua0-f180.google.com with SMTP id x18-v6so978935uaj.9
        for <linux-media@vger.kernel.org>; Mon, 28 May 2018 05:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <20180517095349.203865-1-keiichiw@chromium.org> <a618b1b5-48ac-f725-39a6-50ba81b167f0@xs4all.nl>
In-Reply-To: <a618b1b5-48ac-f725-39a6-50ba81b167f0@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 28 May 2018 21:21:48 +0900
Message-ID: <CAAFQd5AR=At5n=_ZyB_LM8cV6Mw5H5cqBqAH7-b6JUeE0b8Q9g@mail.gmail.com>
Subject: Re: [PATCH] media: v4l2-ctrl: Add control for VP9 profile
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Keiichi Watanabe <keiichiw@google.com>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        keiichiw@chromium.org, smitha.t@samsung.com,
        viro@zeniv.linux.org.uk, andriy.shevchenko@linux.intel.com,
        ricardo.ribalda@gmail.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, May 25, 2018 at 6:09 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On 17/05/18 11:53, Keiichi Watanabe wrote:
> > Add a new control V4L2_CID_MPEG_VIDEO_VP9_PROFILE for selecting desired
> > profile for VP9 encoder and querying for supported profiles by VP9
encoder
> > or decoder.
> >
> > An existing control V4L2_CID_MPEG_VIDEO_VPX_PROFILE cannot be
> > used for querying since it is not a menu control but an integer
> > control, which cannot return an arbitrary set of supported profiles.
> >
> > The new control V4L2_CID_MPEG_VIDEO_VP9_PROFILE is a menu control as
> > with controls for other codec profiles. (e.g. H264)

> I don't mind adding this control (although I would like to have an Ack
from
> Sylwester), but we also need this to be used in an actual kernel driver.

> Otherwise we're adding a control that nobody uses.

Indeed. We were supposed to also include a patch for mtk-vcodec driver, but
somehow it went MIA. Keiichi will add it in next revision. Thanks for
giving this a look.

Best regards,
Tomasz
