Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:39196 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751056AbeFHJbx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 05:31:53 -0400
Received: by mail-vk0-f65.google.com with SMTP id r83-v6so2538459vkf.6
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2018 02:31:53 -0700 (PDT)
Received: from mail-vk0-f44.google.com (mail-vk0-f44.google.com. [209.85.213.44])
        by smtp.gmail.com with ESMTPSA id r20-v6sm787557vke.54.2018.06.08.02.31.51
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Jun 2018 02:31:51 -0700 (PDT)
Received: by mail-vk0-f44.google.com with SMTP id w8-v6so7840286vkh.4
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2018 02:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <20180530071613.125768-1-keiichiw@chromium.org>
 <20180530071613.125768-2-keiichiw@chromium.org> <a16dca32-4198-72c1-cf22-83f18a8cfcb6@xs4all.nl>
In-Reply-To: <a16dca32-4198-72c1-cf22-83f18a8cfcb6@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 8 Jun 2018 18:31:39 +0900
Message-ID: <CAAFQd5B8W0KqnPXs3yo8-ndKTE2n5yYmNEjbCWq6yR6iQYjouA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: v4l2-ctrl: Add control for VP9 profile
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: keiichiw@chromium.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        smitha.t@samsung.com, tom.saeger@oracle.com,
        andriy.shevchenko@linux.intel.com,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mediatek@lists.infradead.org, svarbanov@mm-sol.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jun 8, 2018 at 6:29 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 05/30/2018 09:16 AM, Keiichi Watanabe wrote:
> > Add a new control V4L2_CID_MPEG_VIDEO_VP9_PROFILE for selecting desired
> > profile for VP9 encoder and querying for supported profiles by VP9 encoder
> > or decoder.
> >
> > An existing control V4L2_CID_MPEG_VIDEO_VPX_PROFILE cannot be
> > used for querying since it is not a menu control but an integer
> > control, which cannot return an arbitrary set of supported profiles.
> >
> > The new control V4L2_CID_MPEG_VIDEO_VP9_PROFILE is a menu control as
> > with controls for other codec profiles. (e.g. H264)
>
> Please ignore my reply to patch 2/2. I looked at this a bit more and what you
> should do is to change the type of V4L2_CID_MPEG_VIDEO_VPX_PROFILE to enum.

Note that we still need a way to query VP8 and VP9 separately, since
the supported profiles will differ. (Most of hardware we have today
support all 4 profiles of VP8 and only profile 0 of VP9.)

Best regards,
Tomasz

>
> All other codec profile controls are all enums, so the fact that VPX_PROFILE
> isn't is a bug. Changing the type should not cause any problems since the same
> control value is used when you set the control.
>
> Sylwester: I see that s5p-mfc uses this control, but it is explicitly added
> as an integer type control, so the s5p-mfc driver should not be affected by
> changing the type of this control.
>
> Stanimir: this will slightly change the venus driver, but since it is a very
> recent driver I think we can get away with changing the core type of the
> VPX_PROFILE control. I think that's better than ending up with two controls
> that do the same thing.
>
> Regards,
>
>         Hans
>
> >
> > Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
> > ---
> >  .../media/uapi/v4l/extended-controls.rst      | 26 +++++++++++++++++++
> >  drivers/media/v4l2-core/v4l2-ctrls.c          | 12 +++++++++
> >  include/uapi/linux/v4l2-controls.h            |  8 ++++++
> >  3 files changed, 46 insertions(+)
> >
> > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> > index 03931f9b1285..4f7f128a4998 100644
> > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > @@ -1959,6 +1959,32 @@ enum v4l2_vp8_golden_frame_sel -
> >      Select the desired profile for VPx encoder. Acceptable values are 0,
> >      1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.
> >
> > +.. _v4l2-mpeg-video-vp9-profile:
> > +
> > +``V4L2_CID_MPEG_VIDEO_VP9_PROFILE``
> > +    (enum)
> > +
> > +enum v4l2_mpeg_video_vp9_profile -
> > +    This control allows to select the profile for VP9 encoder.
> > +    This is also used to enumerate supported profiles by VP9 encoder or decoder.
> > +    Possible values are:
> > +
> > +
> > +
> > +.. flat-table::
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +
> > +    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_0``
> > +      - Profile 0
> > +    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_1``
> > +      - Profile 1
> > +    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_2``
> > +      - Profile 2
> > +    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_3``
> > +      - Profile 3
> > +
> > +
> >
> >  High Efficiency Video Coding (HEVC/H.265) Control Reference
> >  -----------------------------------------------------------
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> > index d29e45516eb7..401ce21c2e63 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -431,6 +431,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
> >               "Use Previous Specific Frame",
> >               NULL,
> >       };
> > +     static const char * const vp9_profile[] = {
> > +             "0",
> > +             "1",
> > +             "2",
> > +             "3",
> > +             NULL,
> > +     };
> >
> >       static const char * const flash_led_mode[] = {
> >               "Off",
> > @@ -614,6 +621,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
> >               return mpeg4_profile;
> >       case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
> >               return vpx_golden_frame_sel;
> > +     case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:
> > +             return vp9_profile;
> >       case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
> >               return jpeg_chroma_subsampling;
> >       case V4L2_CID_DV_TX_MODE:
> > @@ -841,6 +850,8 @@ const char *v4l2_ctrl_get_name(u32 id)
> >       case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:                return "VPX P-Frame QP Value";
> >       case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:                   return "VPX Profile";
> >
> > +     case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:                   return "VP9 Profile";
> > +
> >       /* HEVC controls */
> >       case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP:               return "HEVC I-Frame QP Value";
> >       case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP:               return "HEVC P-Frame QP Value";
> > @@ -1180,6 +1191,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
> >       case V4L2_CID_DEINTERLACING_MODE:
> >       case V4L2_CID_TUNE_DEEMPHASIS:
> >       case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
> > +     case V4L2_CID_MPEG_VIDEO_VP9_PROFILE:
> >       case V4L2_CID_DETECT_MD_MODE:
> >       case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
> >       case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
> > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > index 8d473c979b61..56203b7b715c 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -589,6 +589,14 @@ enum v4l2_vp8_golden_frame_sel {
> >  #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP           (V4L2_CID_MPEG_BASE+510)
> >  #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE                      (V4L2_CID_MPEG_BASE+511)
> >
> > +#define V4L2_CID_MPEG_VIDEO_VP9_PROFILE                      (V4L2_CID_MPEG_BASE+512)
> > +enum v4l2_mpeg_video_vp9_profile {
> > +     V4L2_MPEG_VIDEO_VP9_PROFILE_0                           = 0,
> > +     V4L2_MPEG_VIDEO_VP9_PROFILE_1                           = 1,
> > +     V4L2_MPEG_VIDEO_VP9_PROFILE_2                           = 2,
> > +     V4L2_MPEG_VIDEO_VP9_PROFILE_3                           = 3,
> > +};
> > +
> >  /* CIDs for HEVC encoding. */
> >
> >  #define V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP              (V4L2_CID_MPEG_BASE + 600)
> > --
> > 2.17.0.921.gf22659ad46-goog
> >
>
