Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 484A1C6369F
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 12:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22CCC2087E
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 12:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbfATMsp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 07:48:45 -0500
Received: from kozue.soulik.info ([108.61.200.231]:51334 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730536AbfATMso (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 07:48:44 -0500
Received: from [IPv6:2001:470:b30d:2:c604:15ff:0:f0e] (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:f0e])
        by kozue.soulik.info (Postfix) with ESMTPSA id 3D17E100C2B;
        Sun, 20 Jan 2019 21:49:35 +0900 (JST)
Subject: Re: [PATCH v2 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
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
 <20190117110130.lvmwqmn6wd5eeoxi@flea>
From:   ayaka <ayaka@soulik.info>
Message-ID: <e589088d-560c-a4e2-c339-27b45a0caa6a@soulik.info>
Date:   Sun, 20 Jan 2019 20:48:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190117110130.lvmwqmn6wd5eeoxi@flea>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

I am sorry I am a little busy for the lunar new year recently and the 
H.264 syntax rules are little complex, I will try explain my ideas more 
clear here.

On 1/17/19 7:01 PM, Maxime Ripard wrote:
> Hi,
>
> On Tue, Jan 08, 2019 at 05:52:28PM +0800, Randy 'ayaka' Li wrote:
>>> +struct v4l2_ctrl_h264_scaling_matrix {
>>> +	__u8 scaling_list_4x4[6][16];
>>> +	__u8 scaling_list_8x8[6][64];
>>> +};
>> I wonder which decoder want this.
> I'm not sure I follow you, scaling lists are an important part of the
> decoding process, so all of them?
Not actually, when the scaling list is in the sequence(a flag for it), 
we need to tell the decoder a scaling table. But the initial state of 
that table is known, so for some decoder, it would have a internal 
table. And for some decoder, it wants in the Z order while the others won't.
>
>>> +struct v4l2_ctrl_h264_slice_param {
>>> +	/* Size in bytes, including header */
>>> +	__u32 size;
>>> +	/* Offset in bits to slice_data() from the beginning of this slice. */
>>> +	__u32 header_bit_size;
>>> +
>>> +	__u16 first_mb_in_slice;
>>> +	__u8 slice_type;
>>> +	__u8 pic_parameter_set_id;
>>> +	__u8 colour_plane_id;
>>> +	__u16 frame_num;
>>> +	__u16 idr_pic_id;
>>> +	__u16 pic_order_cnt_lsb;
>>> +	__s32 delta_pic_order_cnt_bottom;
>>> +	__s32 delta_pic_order_cnt0;
>>> +	__s32 delta_pic_order_cnt1;
>>> +	__u8 redundant_pic_cnt;
>>> +
>>> +	struct v4l2_h264_pred_weight_table pred_weight_table;
>>> +	/* Size in bits of dec_ref_pic_marking() syntax element. */
>>> +	__u32 dec_ref_pic_marking_bit_size;
>>> +	/* Size in bits of pic order count syntax. */
>>> +	__u32 pic_order_cnt_bit_size;
>>> +
>>> +	__u8 cabac_init_idc;
>>> +	__s8 slice_qp_delta;
>>> +	__s8 slice_qs_delta;
>>> +	__u8 disable_deblocking_filter_idc;
>>> +	__s8 slice_alpha_c0_offset_div2;
>>> +	__s8 slice_beta_offset_div2;
>>> +	__u32 slice_group_change_cycle;
>>> +
>>> +	__u8 num_ref_idx_l0_active_minus1;
>>> +	__u8 num_ref_idx_l1_active_minus1;
>>> +	/*  Entries on each list are indices
>>> +	 *  into v4l2_ctrl_h264_decode_param.dpb[]. */
>>> +	__u8 ref_pic_list0[32];
>>> +	__u8 ref_pic_list1[32];
>>> +
>>> +	__u8 flags;
>>> +};
>>> +
>> We need some addtional properties or the Rockchip won't work.
>> 1. u16 idr_pic_id for identifies IDR (instantaneous decoding refresh)
>> picture
> idr_pic_id is already there
Sorry for miss that.
>
>> 2. u16 ref_pic_mk_len for length of decoded reference picture marking bits
>> 3. u8 poc_length for length of picture order count field in stream
>>
>> The last two are used for the hardware to skip a part stream.
> I'm not sure what you mean here, those parameters are not in the
> bitstream, what do you want to use them for?

Or Rockchip's decoder won't work. Their decoder can't find the data part 
without skip some segments in slice data.

I should say something more about the stateless decoder, it is hard to 
define what a stateless decoder will do, some would like to parse more 
information but some won't. You even have no idea on what it would 
accelerate. OK, I should say for those ISO H serial codec, it would be 
more simple but for those VPx serial, the decoders design is a mess.

>>> +#define V4L2_H264_DPB_ENTRY_FLAG_VALID		0x01
>>> +#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE		0x02
>>> +#define V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM	0x04
>>> +
>>> +struct v4l2_h264_dpb_entry {
>>> +	__u32 tag;
>>> +	__u16 frame_num;
>>> +	__u16 pic_num;
>> Although the long term reference would use picture order count
>> and short term for frame num, but only one of them is used
>> for a entry of a dpb.
>>
>> Besides, for a frame picture frame_num = pic_num * 2,
>> and frame_num = pic_num * 2 + 1 for a filed.
> I'm not sure what is your point?

I found I was wrong at the last email.


But stateless hardware decoder usually don't care about whether it is long
term or short term, as the real dpb updating or management work are not done
by the the driver or device and decoding job would only use the two list(or
one list for slice P) for reference pictures. So those flag for long term or
status can be removed as well.
And I agree above with my last mail, so I would suggest to keep a 
property as index for both frame_num and pic_num, as only one of them 
would be used for a picture decoding once time.

>
>>> +	/* Note that field is indicated by v4l2_buffer.field */
>>> +	__s32 top_field_order_cnt;
>>> +	__s32 bottom_field_order_cnt;
>>> +	__u8 flags; /* V4L2_H264_DPB_ENTRY_FLAG_* */
>>> +};
>>> +
>>> +struct v4l2_ctrl_h264_decode_param {
>>> +	__u32 num_slices;
>>> +	__u8 idr_pic_flag;
>>> +	__u8 nal_ref_idc;
>>> +	__s32 top_field_order_cnt;
>>> +	__s32 bottom_field_order_cnt;
>>> +	__u8 ref_pic_list_p0[32];
>>> +	__u8 ref_pic_list_b0[32];
>>> +	__u8 ref_pic_list_b1[32];
>> I would prefer to keep only two list, list0 and list 1.
> I'm not even sure why this is needed in the first place anymore. It's
> not part of the bitstream, and it seems to come from ChromeOS' Rockchip driver that uses it though. Do you know why?

You see the P frame would use only a list and B for two list. So for the 
parameter of a picture, two lists are max. I would suggest only keep two 
arrays here and rename them as list0 and list1, it would reduce the 
conflict.


Please forget the chrome os driver, there are too many problems leaving 
there. Believe why I made a mistakes in the previous email, because the 
note and confirm of the H.264 syntax from Rockchip is wrong and I found 
it later.

I want to make thing better at designing state.

>
> Thanks!
> Maxime
>
Thank  you all

Randy 'ayaka' Li

