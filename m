Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:33191 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdFHI5d (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 04:57:33 -0400
Received: by mail-yb0-f177.google.com with SMTP id 202so8152207ybd.0
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 01:57:33 -0700 (PDT)
Received: from mail-yw0-f182.google.com (mail-yw0-f182.google.com. [209.85.161.182])
        by smtp.gmail.com with ESMTPSA id v75sm1833029ywa.51.2017.06.08.01.57.30
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2017 01:57:30 -0700 (PDT)
Received: by mail-yw0-f182.google.com with SMTP id 141so10886898ywe.2
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 01:57:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <48b04997-bd80-5640-4272-2c4d69c25a97@st.com>
References: <2890f845-eef2-5689-f154-fc76ae6abc8b@st.com> <816ba2d8-f1e7-ce34-3524-b2a3f1bf3d74@xs4all.nl>
 <fb4a4815-e1ff-081e-787a-0213e32a5405@st.com> <8f93f4f2df49431cb2750963c2f7b168@SFHDAG5NODE2.st.com>
 <48b04997-bd80-5640-4272-2c4d69c25a97@st.com>
From: Pawel Osciak <posciak@chromium.org>
Date: Thu, 8 Jun 2017 01:56:49 -0700
Message-ID: <CACHYQ-pb9tRaWq9c0h7OXTmpUVH16i3d6-8B_Y+YSzAqWGPEqA@mail.gmail.com>
Subject: Re: [RFC] V4L2 unified low-level decoder API
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        "florent.revest@free-electrons.com"
        <florent.revest@free-electrons.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "randy.li@rock-chips.com" <randy.li@rock-chips.com>,
        "jung.zhao@rock-chips.com" <jung.zhao@rock-chips.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        acourbot@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, May 19, 2017 at 1:08 AM, Hugues FRUCHET <hugues.fruchet@st.com> wrote:
> Before merging this work Hans would like to have feedback from peers, in
> order to be sure that this is inline with other SoC vendors drivers
> expectations.
>
> Thomasz, Pawel, could you give your view regarding ChromeOS and Rockchip
> driver ?

The drivers for Rockchip codecs are submitted to the public Chromium OS kernel
and working on our RK-based platforms. We have also since added a VP9 API as
well, which is also working on devices that support it. This gives us
a set of H.264,
VP8 and VP9 APIs on both kernel and userspace side (in the open source
Chromium browser) that are working currently and can be used for
further testing.

We are interested in merging the API patches as well as these drivers upstream
(they were posted on this list two years ago), however we've been blocked by the
progress of request API, which is required for this. Alexandre Courbot
is currently
looking into creating a minimal version of the request API that would provide
enough functionality for stateless codecs, and also plans to further work on
re-submitting the particular codec API patches, once the request API
is finalized.

Thanks,
Pawel
