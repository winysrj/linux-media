Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:47398 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaEOGPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 May 2014 02:15:23 -0400
Received: by mail-qc0-f179.google.com with SMTP id x3so1021166qcv.24
        for <linux-media@vger.kernel.org>; Wed, 14 May 2014 23:15:22 -0700 (PDT)
Received: from mail-qg0-f45.google.com (mail-qg0-f45.google.com [209.85.192.45])
        by mx.google.com with ESMTPSA id j7sm6504543qab.27.2014.05.14.23.15.22
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 14 May 2014 23:15:22 -0700 (PDT)
Received: by mail-qg0-f45.google.com with SMTP id z60so986571qgd.18
        for <linux-media@vger.kernel.org>; Wed, 14 May 2014 23:15:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <037201cf6f7e$7ca1ba90$75e52fb0$%debski@samsung.com>
References: <1394085820-3784-1-git-send-email-arun.kk@samsung.com> <037201cf6f7e$7ca1ba90$75e52fb0$%debski@samsung.com>
From: Pawel Osciak <posciak@chromium.org>
Date: Thu, 15 May 2014 15:14:41 +0900
Message-ID: <CACHYQ-rsL66nV5s4yh0kkJ33ho=n9FmTqPEPscnRjEwZhG3pCA@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-mfc: Add a control for IVF format for VP8 encoder
To: Kamil Debski <k.debski@samsung.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Arun Kumar <arunkk.samsung@gmail.com>, hans.verkuil@cisco.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 14, 2014 at 11:12 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi Pawel, Hans,
>
> I think we talked some time ago on IRC about this patch.
> If I remember correctly, the conclusion was that it would be better to use
> a specific pixel formats for this kind of out codec output.
>
> Akin to:
> V4L2_PIX_FMT_H264                       'H264'  H264 video elementary stream
> with start codes.
> V4L2_PIX_FMT_H264_NO_SC         'AVC1'  H264 video elementary stream without
> start codes.
>
> Could you confirm this?

Hi Kamil.
Yes, that was the conclusion.
Pawel

>
> Best wishes,
> --
> Kamil Debski
> Samsung R&D Institute Poland
>
>
>> -----Original Message-----
>> From: Arun Kumar K [mailto:arunkk.samsung@gmail.com] On Behalf Of Arun
>> Kumar K
>> Sent: Thursday, March 06, 2014 7:04 AM
>> To: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
>> Cc: k.debski@samsung.com; s.nawrocki@samsung.com; posciak@chromium.org;
>> arunkk.samsung@gmail.com
>> Subject: [PATCH] [media] s5p-mfc: Add a control for IVF format for VP8
>> encoder
>>
>> From: Pawel Osciak <posciak@chromium.org>
>>
>> Add a control to enable/disable IVF output stream format for VP8 encode.
>> Set the IVF format output to disabled as default.
>>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  Documentation/DocBook/media/v4l/controls.xml    |    8 ++++++++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 +
>>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   11 +++++++++++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    2 ++
>>  drivers/media/v4l2-core/v4l2-ctrls.c            |    1 +
>>  include/uapi/linux/v4l2-controls.h              |    1 +
>>  6 files changed, 24 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>> b/Documentation/DocBook/media/v4l/controls.xml
>> index 0e1770c..07fb64a 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -3222,6 +3222,14 @@ V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD
>> as a golden frame.</entry>  Acceptable values are 0, 1, 2 and 3
>> corresponding to encoder profiles 0, 1, 2 and 3.</entry>
>>             </row>
>>
>> +           <row><entry></entry></row>
>> +           <row>
>> +             <entry
>> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_IVF_FORMAT</constant>&n
>> bsp;</entry>
>> +             <entry>boolean</entry>
>> +           </row>
>> +           <row><entry spanname="descr">Outputs the VP8 encoded stream
>> in IVF file format.</entry>
>> +           </row>
>> +
>>            <row><entry></entry></row>
>>          </tbody>
>>        </tgroup>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> index 5c28cc3..4d17df9 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> @@ -418,6 +418,7 @@ struct s5p_mfc_vp8_enc_params {
>>       u8 rc_frame_qp;
>>       u8 rc_p_frame_qp;
>>       u8 profile;
>> +     bool ivf;
>>  };
>>
>>  /**
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> index df83cd1..a67913e 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> @@ -676,6 +676,14 @@ static struct mfc_control controls[] = {
>>               .step = 1,
>>               .default_value = 0,
>>       },
>> +     {
>> +             .id = V4L2_CID_MPEG_VIDEO_VPX_IVF_FORMAT,
>> +             .type = V4L2_CTRL_TYPE_BOOLEAN,
>> +             .minimum = 0,
>> +             .maximum = 1,
>> +             .step = 1,
>> +             .default_value = 0,
>> +     },
>>  };
>>
>>  #define NUM_CTRLS ARRAY_SIZE(controls)
>> @@ -1636,6 +1644,9 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl
>> *ctrl)
>>       case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
>>               p->codec.vp8.profile = ctrl->val;
>>               break;
>> +     case V4L2_CID_MPEG_VIDEO_VPX_IVF_FORMAT:
>> +             p->codec.vp8.ivf = ctrl->val;
>> +             break;
>>       default:
>>               v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n",
>>                                                       ctrl->id,
> ctrl->val);
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
>> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
>> index f64621a..90edb19 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
>> @@ -1243,6 +1243,8 @@ static int s5p_mfc_set_enc_params_vp8(struct
>> s5p_mfc_ctx *ctx)
>>
>>       /* VP8 specific params */
>>       reg = 0;
>> +     /* Bit set to 1 disables IVF stream format. */
>> +     reg |= p_vp8->ivf ? 0 : (0x1 << 12);
>>       reg |= (p_vp8->imd_4x4 & 0x1) << 10;
>>       switch (p_vp8->num_partitions) {
>>       case V4L2_CID_MPEG_VIDEO_VPX_1_PARTITION:
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-
>> core/v4l2-ctrls.c
>> index e9e12c4..19e78df 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -752,6 +752,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>>       case V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP:                return "VPX
> I-
>> Frame QP Value";
>>       case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:                return "VPX
> P-
>> Frame QP Value";
>>       case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:                   return "VPX
>> Profile";
>> +     case V4L2_CID_MPEG_VIDEO_VPX_IVF_FORMAT:                return "VPX
> Output
>> stream in IVF format";
>>
>>       /* CAMERA controls */
>>       /* Keep the order of the 'case's the same as in videodev2.h! */
>> diff --git a/include/uapi/linux/v4l2-controls.h
>> b/include/uapi/linux/v4l2-controls.h
>> index cda6fa0..b2763d6 100644
>> --- a/include/uapi/linux/v4l2-controls.h
>> +++ b/include/uapi/linux/v4l2-controls.h
>> @@ -565,6 +565,7 @@ enum v4l2_vp8_golden_frame_sel {
>>  #define V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP
>>       (V4L2_CID_MPEG_BASE+509)
>>  #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP
>>       (V4L2_CID_MPEG_BASE+510)
>>  #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE
>>       (V4L2_CID_MPEG_BASE+511)
>> +#define V4L2_CID_MPEG_VIDEO_VPX_IVF_FORMAT
>>       (V4L2_CID_MPEG_BASE+512)
>>
>>  /*  MPEG-class control IDs specific to the CX2341x driver as defined
>> by V4L2 */
>>  #define V4L2_CID_MPEG_CX2341X_BASE
>>       (V4L2_CTRL_CLASS_MPEG | 0x1000)
>> --
>> 1.7.9.5
>
