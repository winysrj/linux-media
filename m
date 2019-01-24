Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621C1C282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 14:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F0F12184B
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 14:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfAXOhc convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:37:32 -0500
Received: from kozue.soulik.info ([108.61.200.231]:56550 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfAXOhc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 09:37:32 -0500
Received: from [192.168.0.49] (unknown [192.168.0.49])
        by kozue.soulik.info (Postfix) with ESMTPSA id A2464100D3B;
        Thu, 24 Jan 2019 23:38:31 +0900 (JST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 1/2] media: uapi: Add H264 low-level decoder API compound controls.
From:   Ayaka <ayaka@soulik.info>
X-Mailer: iPad Mail (16A404)
In-Reply-To: <20190124142353.hnhd5kez6wrwcyrn@flea>
Date:   Thu, 24 Jan 2019 22:37:23 +0800
Cc:     tfiga@chromium.org, acourbot@chromium.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, posciak@chromium.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>,
        nicolas.dufresne@collabora.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2C346EE9-7066-497C-BDE2-D4ED0BC3E8CF@soulik.info>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com> <20181115145650.9827-2-maxime.ripard@bootlin.com> <20190108095228.GA5161@misaki.sumomo.pri> <20190117110130.lvmwqmn6wd5eeoxi@flea> <e589088d-560c-a4e2-c339-27b45a0caa6a@soulik.info> <20190124142353.hnhd5kez6wrwcyrn@flea>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Sent from my iPad

> On Jan 24, 2019, at 10:23 PM, Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> 
> Hi!
> 
> On Sun, Jan 20, 2019 at 08:48:32PM +0800, ayaka wrote:
>>>>> +struct v4l2_ctrl_h264_scaling_matrix {
>>>>> +    __u8 scaling_list_4x4[6][16];
>>>>> +    __u8 scaling_list_8x8[6][64];
>>>>> +};
>>>> I wonder which decoder want this.
>>> I'm not sure I follow you, scaling lists are an important part of the
>>> decoding process, so all of them?
>> 
>> Not actually, when the scaling list is in the sequence(a flag for it), we
>> need to tell the decoder a scaling table.
> 
> Right, that's why the scaling list has a control of its own.
> 
>> But the initial state of that table is known, so for some decoder,
>> it would have a internal table.
> 
> That control is optional, so you can just ignore that setting in that
> case
> 
>> And for some decoder, it wants in the Z order while the others
>> won't.
> 
> We're designing a generic API here, so it doesn't matter. Some will
I know, I just wonder whether the other driver request it
> have to convert it internally in the drivers for the Z order, while
> others will be able to use it as is.
> 
>>>>> +struct v4l2_ctrl_h264_slice_param {
>>>>> +    /* Size in bytes, including header */
>>>>> +    __u32 size;
>>>>> +    /* Offset in bits to slice_data() from the beginning of this slice. */
>>>>> +    __u32 header_bit_size;
>>>>> +
>>>>> +    __u16 first_mb_in_slice;
>>>>> +    __u8 slice_type;
>>>>> +    __u8 pic_parameter_set_id;
>>>>> +    __u8 colour_plane_id;
>>>>> +    __u16 frame_num;
>>>>> +    __u16 idr_pic_id;
>>>>> +    __u16 pic_order_cnt_lsb;
>>>>> +    __s32 delta_pic_order_cnt_bottom;
>>>>> +    __s32 delta_pic_order_cnt0;
>>>>> +    __s32 delta_pic_order_cnt1;
>>>>> +    __u8 redundant_pic_cnt;
>>>>> +
>>>>> +    struct v4l2_h264_pred_weight_table pred_weight_table;
>>>>> +    /* Size in bits of dec_ref_pic_marking() syntax element. */
>>>>> +    __u32 dec_ref_pic_marking_bit_size;
>>>>> +    /* Size in bits of pic order count syntax. */
>>>>> +    __u32 pic_order_cnt_bit_size;
>>>>> +
>>>>> +    __u8 cabac_init_idc;
>>>>> +    __s8 slice_qp_delta;
>>>>> +    __s8 slice_qs_delta;
>>>>> +    __u8 disable_deblocking_filter_idc;
>>>>> +    __s8 slice_alpha_c0_offset_div2;
>>>>> +    __s8 slice_beta_offset_div2;
>>>>> +    __u32 slice_group_change_cycle;
>>>>> +
>>>>> +    __u8 num_ref_idx_l0_active_minus1;
>>>>> +    __u8 num_ref_idx_l1_active_minus1;
>>>>> +    /*  Entries on each list are indices
>>>>> +     *  into v4l2_ctrl_h264_decode_param.dpb[]. */
>>>>> +    __u8 ref_pic_list0[32];
>>>>> +    __u8 ref_pic_list1[32];
>>>>> +
>>>>> +    __u8 flags;
>>>>> +};
>>>>> +
>>>> We need some addtional properties or the Rockchip won't work.
>>>> 1. u16 idr_pic_id for identifies IDR (instantaneous decoding refresh)
>>>> picture
>>> idr_pic_id is already there
>> Sorry for miss that.
>>> 
>>>> 2. u16 ref_pic_mk_len for length of decoded reference picture marking bits
>>>> 3. u8 poc_length for length of picture order count field in stream
>>>> 
>>>> The last two are used for the hardware to skip a part stream.
>>> I'm not sure what you mean here, those parameters are not in the
>>> bitstream, what do you want to use them for?
>> 
>> Or Rockchip's decoder won't work. Their decoder can't find the data part
>> without skip some segments in slice data.
>> 
>> I should say something more about the stateless decoder, it is hard to
>> define what a stateless decoder will do, some would like to parse more
>> information but some won't. You even have no idea on what it would
>> accelerate. OK, I should say for those ISO H serial codec, it would be more
>> simple but for those VPx serial, the decoders design is a mess.
> 
> Can't you use header_bit_size in that case to skip over the the parts
> of the slice you don't care about and go to the data?
> 
No, the decoder request extra size of those two segment of h.264 bitstream
>>>>> +#define V4L2_H264_DPB_ENTRY_FLAG_VALID        0x01
>>>>> +#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE        0x02
>>>>> +#define V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM    0x04
>>>>> +
>>>>> +struct v4l2_h264_dpb_entry {
>>>>> +    __u32 tag;
>>>>> +    __u16 frame_num;
>>>>> +    __u16 pic_num;
>>>> Although the long term reference would use picture order count
>>>> and short term for frame num, but only one of them is used
>>>> for a entry of a dpb.
>>>> 
>>>> Besides, for a frame picture frame_num = pic_num * 2,
>>>> and frame_num = pic_num * 2 + 1 for a filed.
>>> 
>>> I'm not sure what is your point?
>> 
>> I found I was wrong at the last email.
>> 
>> But stateless hardware decoder usually don't care about whether it is long
>> term or short term, as the real dpb updating or management work are not done
>> by the the driver or device and decoding job would only use the two list(or
>> one list for slice P) for reference pictures. So those flag for long term or
>> status can be removed as well.
> 
> I'll remove the LONG_TERM flag then. We do need the other two for the
> Allwinner driver though.
> 
I would ask Paulk and check the manual and vendor library later.
Even there are two register fields, it don’t mean they would be used and required at the same times.
Because it don’t follow ISO manual.
>> And I agree above with my last mail, so I would suggest to keep a property
>> as index for both frame_num and pic_num, as only one of them would be used
>> for a picture decoding once time.
> 
> I'd really prefer to keep everything that is in the bitstream defined
> here. We don't want to cover the usual cases, but all of them even the
> one that haven't been designed yet, so we should be really
> conservative.
As I mention in the other mail, a stateless decoder or encoder like means the device won’t track the previous result. But you have no idea on what data the device would need to process this picture. It is hard to define a standard structure for it.
As you see, even allwinner doesn’t obey all the standard the IOS document said.
In my original suggestion, I would just to add more reservation fields then future driver can use it.
> 
>>>>> +    /* Note that field is indicated by v4l2_buffer.field */
>>>>> +    __s32 top_field_order_cnt;
>>>>> +    __s32 bottom_field_order_cnt;
>>>>> +    __u8 flags; /* V4L2_H264_DPB_ENTRY_FLAG_* */
>>>>> +};
>>>>> +
>>>>> +struct v4l2_ctrl_h264_decode_param {
>>>>> +    __u32 num_slices;
>>>>> +    __u8 idr_pic_flag;
>>>>> +    __u8 nal_ref_idc;
>>>>> +    __s32 top_field_order_cnt;
>>>>> +    __s32 bottom_field_order_cnt;
>>>>> +    __u8 ref_pic_list_p0[32];
>>>>> +    __u8 ref_pic_list_b0[32];
>>>>> +    __u8 ref_pic_list_b1[32];
>>>> 
>>>> I would prefer to keep only two list, list0 and list 1.
>>> 
>>> I'm not even sure why this is needed in the first place
>>> anymore. It's not part of the bitstream, and it seems to come from
>>> ChromeOS' Rockchip driver that uses it though. Do you know why?
>> 
>> You see the P frame would use only a list and B for two list. So for
>> the parameter of a picture, two lists are max. I would suggest only
>> keep two arrays here and rename them as list0 and list1, it would
>> reduce the conflict.
> 
> Right, but those lists are already in v4l2_ctrl_h264_slice_param (with
> the construct you are suggesting). I'm not sure about why the
> redundancy is needed. Alex, Tomasz, do you have any idea why this was
> needed at some point?
> 
I may be wrong or forget.
> Thanks!
> Maxime
> 
> -- 
> Maxime Ripard, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

