Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DA3C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 13:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0418F214C6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 13:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbfAJNdL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 08:33:11 -0500
Received: from kozue.soulik.info ([108.61.200.231]:42500 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbfAJNdK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 08:33:10 -0500
Received: from [IPv6:2001:470:b30d:2:c604:15ff:0:401] (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:401])
        by kozue.soulik.info (Postfix) with ESMTPSA id F12261012A9;
        Thu, 10 Jan 2019 22:33:49 +0900 (JST)
Subject: Re: [PATCH v2 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
From:   ayaka <ayaka@soulik.info>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, tfiga@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, posciak@chromium.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>,
        nicolas.dufresne@collabora.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <20181115145650.9827-1-maxime.ripard@bootlin.com>
 <20181115145650.9827-2-maxime.ripard@bootlin.com>
 <20190108095228.GA5161@misaki.sumomo.pri>
 <2149617a-6a36-4c0b-26c9-7fdfee9da9c9@soulik.info>
Message-ID: <2e734dd6-d459-9990-61fe-27301df35ff7@soulik.info>
Date:   Thu, 10 Jan 2019 21:33:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <2149617a-6a36-4c0b-26c9-7fdfee9da9c9@soulik.info>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

I forget a important thing, for the rkvdec and rk hevc decoder, it would 
requests cabac table, scaling list, picture parameter set and reference 
picture storing in one or various of DMA buffers. I am not talking about 
the data been parsed, the decoder would requests a raw data.

For the pps and rps, it is possible to reuse the slice header, just let 
the decoder know the offset from the bitstream bufer, I would suggest to 
add three properties(with sps) for them. But I think we need a method to 
mark a OUTPUT side buffer for those aux data.

On 1/9/19 1:01 AM, ayaka wrote:
>
> On 1/8/19 5:52 PM, Randy 'ayaka' Li wrote:
>> On Thu, Nov 15, 2018 at 03:56:49PM +0100, Maxime Ripard wrote:
>>> From: Pawel Osciak <posciak@chromium.org>
>>>
>>> Stateless video codecs will require both the H264 metadata and 
>>> slices in
>>> order to be able to decode frames.
>>>
>>> This introduces the definitions for a new pixel format for H264 
>>> slices that
>>> have been parsed, as well as the structures used to pass the 
>>> metadata from
>>> the userspace to the kernel.
>>>
>>> Co-Developed-by: Maxime Ripard <maxime.ripard@bootlin.com>
>>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>>> Signed-off-by: Guenter Roeck <groeck@chromium.org>
>>> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>>> ---
>>>   Documentation/media/uapi/v4l/biblio.rst       |   9 +
>>>   .../media/uapi/v4l/extended-controls.rst      | 364 
>>> ++++++++++++++++++
>>>   .../media/uapi/v4l/pixfmt-compressed.rst      |  20 +
>>>   .../media/uapi/v4l/vidioc-queryctrl.rst       |  30 ++
>>>   .../media/videodev2.h.rst.exceptions          |   5 +
>>>   drivers/media/v4l2-core/v4l2-ctrls.c          |  42 ++
>>>   drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
>>>   include/media/v4l2-ctrls.h                    |  10 +
>>>   include/uapi/linux/v4l2-controls.h            | 166 ++++++++
>>>   include/uapi/linux/videodev2.h                |  11 +
>>>   10 files changed, 658 insertions(+)
>>> +#define V4L2_H264_DPB_ENTRY_FLAG_VALID        0x01
>>> +#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE        0x02
>>> +#define V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM    0x04
>>> +
>>> +struct v4l2_h264_dpb_entry {
>>> +    __u32 tag;
>>> +    __u16 frame_num;
>>> +    __u16 pic_num;
>> Although the long term reference would use picture order count
>> and short term for frame num, but only one of them is used
>> for a entry of a dpb.
>>
>> Besides, for a frame picture frame_num = pic_num * 2,
>> and frame_num = pic_num * 2 + 1 for a filed.
>
> I mistook something before and something Herman told me is wrong, I 
> read the book explaining the ITU standard.
>
> The index of a short term reference picture would be frame_num or POC 
> and LongTermPicNum for long term.
>
> But stateless hardware decoder usually don't care about whether it is 
> long term or short term, as the real dpb updating or management work 
> are not done by the the driver or device and decoding job would only 
> use the two list(or one list for slice P) for reference pictures. So 
> those flag for long term or status can be removed as well.
>
> Stateless decoder would care about just reference index of this 
> picture and maybe some extra property for the filed coded below. 
> Keeping a property here for the index of a picture is enough.
>
>>> +    /* Note that field is indicated by v4l2_buffer.field */
>>> +    __s32 top_field_order_cnt;
>>> +    __s32 bottom_field_order_cnt;
>>> +    __u8 flags; /* V4L2_H264_DPB_ENTRY_FLAG_* */
>>> +};
>>> +
>>> +struct v4l2_ctrl_h264_decode_param {
>>> +    __u32 num_slices;
>>> +    __u8 idr_pic_flag;
>>> +    __u8 nal_ref_idc;
>>> +    __s32 top_field_order_cnt;
>>> +    __s32 bottom_field_order_cnt;
>>> +    __u8 ref_pic_list_p0[32];
>>> +    __u8 ref_pic_list_b0[32];
>>> +    __u8 ref_pic_list_b1[32];
>> I would prefer to keep only two list, list0 and list 1.
>> Anyway P slice just use the list0 and B would use the both.
>>> +    struct v4l2_h264_dpb_entry dpb[16];
>>> +};
>>> +
>>>   #endif
>>> diff --git a/include/uapi/linux/videodev2.h 
>>> b/include/uapi/linux/videodev2.h
>>> index 173a94d2cbef..dd028e0bf306 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -643,6 +643,7 @@ struct v4l2_pix_format {
>>>   #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* 
>>> H264 with start codes */
>>>   #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* 
>>> H264 without start codes */
>>>   #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* 
>>> H264 MVC */
>>> +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* 
>>> H264 parsed slices */
>>>   #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* 
>>> H263          */
>>>   #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* 
>>> MPEG-1 ES     */
>>>   #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* 
>>> MPEG-2 ES     */
>>> @@ -1631,6 +1632,11 @@ struct v4l2_ext_control {
>>>           __u32 __user *p_u32;
>>>           struct v4l2_ctrl_mpeg2_slice_params __user 
>>> *p_mpeg2_slice_params;
>>>           struct v4l2_ctrl_mpeg2_quantization __user 
>>> *p_mpeg2_quantization;
>>> +        struct v4l2_ctrl_h264_sps __user *p_h264_sps;
>>> +        struct v4l2_ctrl_h264_pps __user *p_h264_pps;
>>> +        struct v4l2_ctrl_h264_scaling_matrix __user *p_h264_scal_mtrx;
>>> +        struct v4l2_ctrl_h264_slice_param __user *p_h264_slice_param;
>>> +        struct v4l2_ctrl_h264_decode_param __user 
>>> *p_h264_decode_param;
>>>           void __user *ptr;
>>>       };
>>>   } __attribute__ ((packed));
>>> @@ -1678,6 +1684,11 @@ enum v4l2_ctrl_type {
>>>       V4L2_CTRL_TYPE_U32         = 0x0102,
>>>       V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS = 0x0103,
>>>       V4L2_CTRL_TYPE_MPEG2_QUANTIZATION = 0x0104,
>>> +    V4L2_CTRL_TYPE_H264_SPS      = 0x0105,
>>> +    V4L2_CTRL_TYPE_H264_PPS      = 0x0106,
>>> +    V4L2_CTRL_TYPE_H264_SCALING_MATRIX = 0x0107,
>>> +    V4L2_CTRL_TYPE_H264_SLICE_PARAMS = 0x0108,
>>> +    V4L2_CTRL_TYPE_H264_DECODE_PARAMS = 0x0109,
>>>   };
>>>     /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
