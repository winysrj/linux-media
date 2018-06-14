Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:32983 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754633AbeFNIGX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 04:06:23 -0400
Received: by mail-wr0-f196.google.com with SMTP id k16-v6so5355668wro.0
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2018 01:06:23 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] media: v4l2-ctrl: Add control for VP9 profile
To: Keiichi Watanabe <keiichiw@chromium.org>,
        linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
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
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        s.nawrocki@samsung.com
References: <20180614074652.162796-1-keiichiw@chromium.org>
 <20180614074652.162796-3-keiichiw@chromium.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <9cb304df-c600-918a-1c73-8daa9644f9c3@linaro.org>
Date: Thu, 14 Jun 2018 11:06:20 +0300
MIME-Version: 1.0
In-Reply-To: <20180614074652.162796-3-keiichiw@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Keiichi,

On 06/14/2018 10:46 AM, Keiichi Watanabe wrote:
> Add a new control V4L2_CID_MPEG_VIDEO_VP9_PROFILE for VP9
> profiles. This control allows to select a desired profile for VP9
> encoder and query for supported profiles by VP9 encoder/decoder.
> 
> Though this control is similar to V4L2_CID_MPEG_VIDEO_VP8_PROFILE, we need to
> separate this control from it because supported profiles usually differ between
> VP8 and VP9.
> 
> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
> ---
>  .../media/uapi/v4l/extended-controls.rst      | 25 +++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c          | 11 ++++++++
>  include/uapi/linux/v4l2-controls.h            |  7 ++++++
>  3 files changed, 43 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index de99eafb0872..095b42e9d6fe 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1980,6 +1980,31 @@ enum v4l2_mpeg_video_vp8_profile -
>      * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_3``
>        - Profile 3
> 
> +.. _v4l2-mpeg-video-vp9-profile:
> +
> +``V4L2_CID_MPEG_VIDEO_VP9_PROFILE``
> +    (enum)
> +
> +enum v4l2_mpeg_video_vp9_profile -

what about vp9 levels, shouldn't we add them too? Or we will add it when
there is a user.


-- 
regards,
Stan
