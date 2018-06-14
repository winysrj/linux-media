Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:37925 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754621AbeFNJMC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 05:12:02 -0400
Received: by mail-lf0-f66.google.com with SMTP id i83-v6so8267004lfh.5
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2018 02:12:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9cb304df-c600-918a-1c73-8daa9644f9c3@linaro.org>
References: <20180614074652.162796-1-keiichiw@chromium.org>
 <20180614074652.162796-3-keiichiw@chromium.org> <9cb304df-c600-918a-1c73-8daa9644f9c3@linaro.org>
From: Keiichi Watanabe <keiichiw@chromium.org>
Date: Thu, 14 Jun 2018 18:12:00 +0900
Message-ID: <CAD90VcZT7M+egaBYXMdyGHUNq4wXmog9qFw3RjiPJ6cNszfkvA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] media: v4l2-ctrl: Add control for VP9 profile
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On Thu, Jun 14, 2018 at 5:06 PM, Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
> Hi Keiichi,
>
> On 06/14/2018 10:46 AM, Keiichi Watanabe wrote:
>> Add a new control V4L2_CID_MPEG_VIDEO_VP9_PROFILE for VP9
>> profiles. This control allows to select a desired profile for VP9
>> encoder and query for supported profiles by VP9 encoder/decoder.
>>
>> Though this control is similar to V4L2_CID_MPEG_VIDEO_VP8_PROFILE, we need to
>> separate this control from it because supported profiles usually differ between
>> VP8 and VP9.
>>
>> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
>> ---
>>  .../media/uapi/v4l/extended-controls.rst      | 25 +++++++++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c          | 11 ++++++++
>>  include/uapi/linux/v4l2-controls.h            |  7 ++++++
>>  3 files changed, 43 insertions(+)
>>
>> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
>> index de99eafb0872..095b42e9d6fe 100644
>> --- a/Documentation/media/uapi/v4l/extended-controls.rst
>> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
>> @@ -1980,6 +1980,31 @@ enum v4l2_mpeg_video_vp8_profile -
>>      * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_3``
>>        - Profile 3
>>
>> +.. _v4l2-mpeg-video-vp9-profile:
>> +
>> +``V4L2_CID_MPEG_VIDEO_VP9_PROFILE``
>> +    (enum)
>> +
>> +enum v4l2_mpeg_video_vp9_profile -
>

> what about vp9 levels, shouldn't we add them too? Or we will add it when
> there is a user.
>
It sounds good, but I don't think we should include them in this
series of patches now.
As you said, we can add them when someone wants to use them.

Best regards,
Keiichi

>
> --
> regards,
> Stan
