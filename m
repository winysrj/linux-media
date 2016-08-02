Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:43775 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbcHBL2x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2016 07:28:53 -0400
Subject: Re: [PATCH 4/6] media: rcar-vin: add support for V4L2_FIELD_ALTERNATE
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
 <20160729174012.14331-5-niklas.soderlund+renesas@ragnatech.se>
 <8a7c5144-cbab-323f-746d-45923fe748df@xs4all.nl>
 <20160802103204.GG3672@bigcity.dyn.berto.se>
 <7ce712b8-e0cb-4a14-74e3-f7cc03fdf19f@xs4all.nl>
 <20160802110219.GH3672@bigcity.dyn.berto.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com,
	lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c5fd092e-2921-f18a-3aa2-3c613caf2cc2@xs4all.nl>
Date: Tue, 2 Aug 2016 13:21:06 +0200
MIME-Version: 1.0
In-Reply-To: <20160802110219.GH3672@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/02/2016 01:02 PM, Niklas Söderlund wrote:
> On 2016-08-02 12:39:40 +0200, Hans Verkuil wrote:
>>
>>
>> On 08/02/2016 12:32 PM, Niklas Söderlund wrote:
>>> Hi Hans,
>>>
>>> Thanks for your feedback.
>>>
>>> On 2016-08-02 11:41:15 +0200, Hans Verkuil wrote:
>>>>
>>>>
>>>> On 07/29/2016 07:40 PM, Niklas Söderlund wrote:
>>>>> The HW can capture both ODD and EVEN fields in separate buffers so it's
>>>>> possible to support this field mode.
>>>>>
>>>>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>>>> ---
>>>>>  drivers/media/platform/rcar-vin/rcar-dma.c  | 26 ++++++++++++++++++++------
>>>>>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 12 ++++++++++++
>>>>>  2 files changed, 32 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
>>>>> index dad3b03..bcdec46 100644
>>>>> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
>>>>> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
>>>>> @@ -95,6 +95,7 @@
>>>>>  /* Video n Module Status Register bits */
>>>>>  #define VNMS_FBS_MASK		(3 << 3)
>>>>>  #define VNMS_FBS_SHIFT		3
>>>>> +#define VNMS_FS			(1 << 2)
>>>>>  #define VNMS_AV			(1 << 1)
>>>>>  #define VNMS_CA			(1 << 0)
>>>>>  
>>>>> @@ -147,6 +148,7 @@ static int rvin_setup(struct rvin_dev *vin)
>>>>>  	case V4L2_FIELD_INTERLACED_BT:
>>>>>  		vnmc = VNMC_IM_FULL | VNMC_FOC;
>>>>>  		break;
>>>>> +	case V4L2_FIELD_ALTERNATE:
>>>>>  	case V4L2_FIELD_NONE:
>>>>>  		if (vin->continuous) {
>>>>>  			vnmc = VNMC_IM_ODD_EVEN;
>>>>> @@ -322,15 +324,26 @@ static bool rvin_capture_active(struct rvin_dev *vin)
>>>>>  	return rvin_read(vin, VNMS_REG) & VNMS_CA;
>>>>>  }
>>>>>  
>>>>> -static int rvin_get_active_slot(struct rvin_dev *vin)
>>>>> +static int rvin_get_active_slot(struct rvin_dev *vin, u32 vnms)
>>>>>  {
>>>>>  	if (vin->continuous)
>>>>> -		return (rvin_read(vin, VNMS_REG) & VNMS_FBS_MASK)
>>>>> -			>> VNMS_FBS_SHIFT;
>>>>> +		return (vnms & VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
>>>>>  
>>>>>  	return 0;
>>>>>  }
>>>>>  
>>>>> +static enum v4l2_field rvin_get_active_field(struct rvin_dev *vin, u32 vnms)
>>>>> +{
>>>>> +	if (vin->format.field == V4L2_FIELD_ALTERNATE) {
>>>>> +		/* If FS is set it's a Even field */
>>>>> +		if (vnms & VNMS_FS)
>>>>> +			return V4L2_FIELD_BOTTOM;
>>>>> +		return V4L2_FIELD_TOP;
>>>>> +	}
>>>>> +
>>>>> +	return vin->format.field;
>>>>> +}
>>>>> +
>>>>>  static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr)
>>>>>  {
>>>>>  	const struct rvin_video_format *fmt;
>>>>> @@ -871,7 +884,7 @@ static bool rvin_fill_hw(struct rvin_dev *vin)
>>>>>  static irqreturn_t rvin_irq(int irq, void *data)
>>>>>  {
>>>>>  	struct rvin_dev *vin = data;
>>>>> -	u32 int_status;
>>>>> +	u32 int_status, vnms;
>>>>>  	int slot;
>>>>>  	unsigned int sequence, handled = 0;
>>>>>  	unsigned long flags;
>>>>> @@ -898,7 +911,8 @@ static irqreturn_t rvin_irq(int irq, void *data)
>>>>>  	}
>>>>>  
>>>>>  	/* Prepare for capture and update state */
>>>>> -	slot = rvin_get_active_slot(vin);
>>>>> +	vnms = rvin_read(vin, VNMS_REG);
>>>>> +	slot = rvin_get_active_slot(vin, vnms);
>>>>>  	sequence = vin->sequence++;
>>>>>  
>>>>>  	vin_dbg(vin, "IRQ %02d: %d\tbuf0: %c buf1: %c buf2: %c\tmore: %d\n",
>>>>> @@ -913,7 +927,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
>>>>>  		goto done;
>>>>>  
>>>>>  	/* Capture frame */
>>>>> -	vin->queue_buf[slot]->field = vin->format.field;
>>>>> +	vin->queue_buf[slot]->field = rvin_get_active_field(vin, vnms);
>>>>>  	vin->queue_buf[slot]->sequence = sequence;
>>>>>  	vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
>>>>>  	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
>>>>> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
>>>>> index b6e40ea..00ac2b6 100644
>>>>> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
>>>>> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
>>>>> @@ -109,6 +109,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
>>>>>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>>>>>  	};
>>>>>  	struct v4l2_mbus_framefmt *mf = &fmt.format;
>>>>> +	v4l2_std_id std;
>>>>>  	int ret;
>>>>>  
>>>>>  	fmt.pad = vin->src_pad_idx;
>>>>> @@ -122,9 +123,19 @@ static int rvin_reset_format(struct rvin_dev *vin)
>>>>>  	vin->format.colorspace	= mf->colorspace;
>>>>>  	vin->format.field	= mf->field;
>>>>>  
>>>>> +	/* If we have a video standard use HW to deinterlace */
>>>>> +	if (vin->format.field == V4L2_FIELD_ALTERNATE &&
>>>>> +	    !v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
>>>>> +		if (std & V4L2_STD_625_50)
>>>>> +			vin->format.field = V4L2_FIELD_INTERLACED_TB;
>>>>> +		else
>>>>> +			vin->format.field = V4L2_FIELD_INTERLACED_BT;
>>>>> +	}
>>>>
>>>> Huh? ALTERNATE means that the fields are captured separately, i.e. one buffer
>>>> per field.
>>>>
>>>> There is no HW deinterlacing going on in that case, and ALTERNATE is certainly
>>>> not equal to FIELD_INTERLACED_BT/TB.
>>>>
>>>> If ALTERNATE is chosen as the field format, then VIDIOC_G_FMT should return
>>>> ALTERNATE as the field format, but in struct v4l2_buffer the field will always
>>>> be TOP or BOTTOM.
>>>
>>> Yes, if S_FMT request ALTERNATE then G_FMT will return ALTERNATE. This 
>>> code was meant to make INTERLACE_{TB,BT} the default field selection if 
>>> the subdevice uses V4L2_FIELD_ALTERNATE. The rvin_reset_format() is only 
>>> called in the following cases:
>>>
>>> - When the driver is first probed to get initial default values from the 
>>>   subdevice.
>>>
>>> - S_STD is called and the width, hight and other parameters from the 
>>>   subdevice needs to be updated.
>>>
>>> Is it wrong to use an INTERLACE field as default if the subdevice 
>>> provides ALTERNATE? My goal was to not change the behavior of the 
>>> rcar-vin driver which default uses INTERLACE today? I'm happy to drop 
>>> this part for v2 if it's the wrong thing to do in this case.
>>
>> It depends. If the subdev returns ALTERNATE, then the SoC receives the
>> video data as successive fields. How are those processed? Are they combined
>> into frames? If so, then INTERLACED would be correct. If they are kept as
>> separate fields, then the rcar driver should say ALTERNATE as well. If they
>> are placed in one buffer as the top field followed by the bottom field, then
>> SEQ_BT/TB is the correct field format.
> 
> The driver can process video data received as separate successive fields 
> in two ways.
> 
> 1. It can keep them in separate fields and provide them in separate 
>    buffers to userspace in the ALTERNATE field format. In this mode it 
>    will sett the ODD and EVEN field type to each buffer. This is what 
>    happens if the driver is asked with S_FMT to use the ALTERNATE field 
>    format.
> 
> 2. It can combined the two fields into a frame and present that in one 
>    buffer to userspace. This is what happens if the driver is asked with 
>    S_FMT to use a INTERLACED field format.
> 
> 
> I added the logic in question to try to keep the current behavior of the 
> rcar-vin driver which would default to a INTERLACED format if it was 
> hooked up a adv7180 subdevice.
> 
> So the question in this case as I see it is if it's sane to try to 
> preserve that or if I should just drop the logic above and default to 
> whatever field format the subdevice is using.

No, combining the two fields into a single interlaced frame is the way to
go by default. Most applications expect INTERLACED. Support for ALTERNATE
is a lot less common.

It would probably be helpful if you added a few comments about this to the
code.

> The only filed mode I can't figure out how to support with the VIN HW is 
> the SEQ_{BT,TB} formats. I guess I can do some tricks with doing two 
> captures in to the same buffer only changing the offset. I do however do 
> not see a need to add support for this field mode right now.

These are rarely used and few applications can handle this.

I understand that you're working on a v2 of this patch series? If so, then
I'll review that v2 with this information in mind.

Regards,

	Hans
