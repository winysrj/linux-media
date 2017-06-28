Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36404 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbdF1UEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 16:04:47 -0400
Received: by mail-pf0-f194.google.com with SMTP id z6so10246956pfk.3
        for <linux-media@vger.kernel.org>; Wed, 28 Jun 2017 13:04:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1497849055-26583-13-git-send-email-smitha.t@samsung.com>
References: <CGME20170619052521epcas5p36a0bc384d10809dcfe775e6da87ed37b@epcas5p3.samsung.com>
 <1497849055-26583-1-git-send-email-smitha.t@samsung.com> <1497849055-26583-13-git-send-email-smitha.t@samsung.com>
From: Kamil Debski <kamil@wypas.org>
Date: Wed, 28 Jun 2017 22:04:05 +0200
Message-ID: <CAP3TMiG4PtiqeHhCGkHhdX_uvOhPKd=gTyckczyFKDJwnGfwYA@mail.gmail.com>
Subject: Re: [Patch v5 12/12] Documention: v4l: Documentation for HEVC CIDs
To: Smitha T Murthy <smitha.t@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, a.hajda@samsung.com, mchehab@kernel.org,
        pankaj.dubey@samsung.com, krzk@kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please find my comments inline.

On 19 June 2017 at 07:10, Smitha T Murthy <smitha.t@samsung.com> wrote:
> Added V4l2 controls for HEVC encoder
>
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> ---
>  Documentation/media/uapi/v4l/extended-controls.rst | 364 +++++++++++++++++++++
>  1 file changed, 364 insertions(+)
>
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index abb1057..7767c70 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1960,6 +1960,370 @@ enum v4l2_vp8_golden_frame_sel -
>      1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.
>
>

[snip]

> +
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER (integer)``
> +    Selects the hierarchical coding layer. In normal encoding
> +    (non-hierarchial coding), it should be zero. Possible values are 0 ~ 6.
> +    0 indicates HIERARCHICAL CODING LAYER 0, 1 indicates HIERARCHICAL CODING
> +    LAYER 1 and so on.

I would like the above to be more consistent. If HIER is in the name
then HIER in the description should be used as well. Aside from that,
I would recommend using full HIERARCHICAL instead of HIER in the name
of the control. Why? Because it is HIERARCHICAL in controls already
present in V4L2, such as
V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP.

[snip]

> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LF (boolean)``
> +    Indicates loop filtering. Control value 1 indicates loop filtering
> +    is enabled and when set to 0 indicates loop filtering is disabled.
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LF_SLICE_BOUNDARY (boolean)``
> +    Selects whether to apply the loop filter across the slice boundary or not.
> +    If the value is 0, loop filter will not be applied across the slice boundary.
> +    If the value is 1, loop filter will be applied across the slice boundary.

Just a thought. Pretty much the same fucntionality is achieved via the
V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE control. It's an enum having
three states: enabled, disabled and disabled at slice boundary. Maybe
a single control could be introduced? With another legacy define for
API compatibility. Also, I don't like that controls are not consistent
between H264 and HEVC. I would opt for the enum option.

> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2 (integer)``
> +    Selects HEVC loop filter beta offset. The valid range is [-6, +6].
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2 (integer)``
> +    Selects HEVC loop filter tc offset. The valid range is [-6, +6].
> +
> +.. _v4l2-hevc-refresh-type:
> +
> +``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE``
> +    (enum)
> +
[snip]

Best wishes,
Kamil
