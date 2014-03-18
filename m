Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2021 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbaCRNJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 09:09:30 -0400
Message-ID: <53284570.3030002@xs4all.nl>
Date: Tue, 18 Mar 2014 14:09:04 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 36/48] adv7604: Make output format configurable through
 pad format operations
References: <1394493359-14115-37-git-send-email-laurent.pinchart@ideasonboard.com> <1394550634-25242-1-git-send-email-laurent.pinchart@ideasonboard.com> <532812B0.6000109@xs4all.nl> <2557122.W7Piv8LSLZ@avalon>
In-Reply-To: <2557122.W7Piv8LSLZ@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/18/2014 02:02 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 18 March 2014 10:32:32 Hans Verkuil wrote:
>> Hi Laurent,
>>
>> I've tested it and I thought I was going crazy. Everything was fine after
>> applying this patch, but as soon as I applied the next patch (37/48) the
>> colors were wrong. But that patch had nothing whatsoever to do with the
>> bus ordering. You managed to make a small but crucial bug and it was pure
>> bad luck that it ever worked.
>>
>> See details below:
>>
>> On 03/11/14 16:10, Laurent Pinchart wrote:
>>> Replace the dummy video format operations by pad format operations that
>>> configure the output format.
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> ---
>>>
>>>  drivers/media/i2c/adv7604.c | 280 +++++++++++++++++++++++++++++++++++----
>>>  include/media/adv7604.h     |  56 ++++-----
>>>  2 files changed, 275 insertions(+), 61 deletions(-)
>>>
>>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>>> index 851b350..5aa7c29 100644
>>> --- a/drivers/media/i2c/adv7604.c
>>> +++ b/drivers/media/i2c/adv7604.c
>>> @@ -53,6 +53,28 @@ MODULE_LICENSE("GPL");
>>>
>>>  /* ADV7604 system clock frequency */
>>>  #define ADV7604_fsc (28636360)
>>>
>>> +#define ADV7604_RGB_OUT					(1 << 1)
>>> +
>>> +#define ADV7604_OP_FORMAT_SEL_8BIT			(0 << 0)
>>> +#define ADV7604_OP_FORMAT_SEL_10BIT			(1 << 0)
>>> +#define ADV7604_OP_FORMAT_SEL_12BIT			(2 << 0)
>>> +
>>> +#define ADV7604_OP_MODE_SEL_SDR_422			(0 << 5)
>>> +#define ADV7604_OP_MODE_SEL_DDR_422			(1 << 5)
>>> +#define ADV7604_OP_MODE_SEL_SDR_444			(2 << 5)
>>> +#define ADV7604_OP_MODE_SEL_DDR_444			(3 << 5)
>>> +#define ADV7604_OP_MODE_SEL_SDR_422_2X			(4 << 5)
>>> +#define ADV7604_OP_MODE_SEL_ADI_CM			(5 << 5)
>>> +
>>> +#define ADV7604_OP_CH_SEL_GBR				(0 << 5)
>>> +#define ADV7604_OP_CH_SEL_GRB				(1 << 5)
>>> +#define ADV7604_OP_CH_SEL_BGR				(2 << 5)
>>> +#define ADV7604_OP_CH_SEL_RGB				(3 << 5)
>>> +#define ADV7604_OP_CH_SEL_BRG				(4 << 5)
>>> +#define ADV7604_OP_CH_SEL_RBG				(5 << 5)
>>
>> Note that these values are shifted 5 bits to the left...
> 
> [snip]
> 
>>> +struct adv7604_format_info {
>>> +	enum v4l2_mbus_pixelcode code;
>>> +	u8 op_ch_sel;
>>> +	bool rgb_out;
>>> +	bool swap_cb_cr;
>>> +	u8 op_format_sel;
>>> +};
> 
> [snip]
> 
>>> +static const struct adv7604_format_info adv7604_formats[] = {
>>> +	{ V4L2_MBUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_YUYV10_2X10, ADV7604_OP_CH_SEL_RGB, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
>>> +	{ V4L2_MBUS_FMT_YVYU10_2X10, ADV7604_OP_CH_SEL_RGB, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
>>> +	{ V4L2_MBUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +	{ V4L2_MBUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +	{ V4L2_MBUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_UYVY10_1X20, ADV7604_OP_CH_SEL_RBG, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
>>> +	{ V4L2_MBUS_FMT_VYUY10_1X20, ADV7604_OP_CH_SEL_RBG, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
>>> +	{ V4L2_MBUS_FMT_YUYV10_1X20, ADV7604_OP_CH_SEL_RGB, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
>>> +	{ V4L2_MBUS_FMT_YVYU10_1X20, ADV7604_OP_CH_SEL_RGB, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
>>> +	{ V4L2_MBUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +	{ V4L2_MBUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +	{ V4L2_MBUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +	{ V4L2_MBUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +};
>>> +
>>> +static const struct adv7604_format_info adv7611_formats[] = {
>>> +	{ V4L2_MBUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +	{ V4L2_MBUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +	{ V4L2_MBUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
>>> +	{ V4L2_MBUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +	{ V4L2_MBUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +	{ V4L2_MBUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +	{ V4L2_MBUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
>>> +	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
>>> +};
> 
> [snip]
> 
>>> +/*
>>> + * Compute the op_ch_sel value required to obtain on the bus the
>>> component order
>>> + * corresponding to the selected format taking into account bus
>>> reordering
>>> + * applied by the board at the output of the device.
>>> + *
>>> + * The following table gives the op_ch_value from the format component
>>> order
>>> + * (expressed as op_ch_sel value in column) and the bus reordering
>>> (expressed as
>>> + * adv7604_bus_order value in row).
>>> + *
>>> + *           |	GBR(0)	GRB(1)	BGR(2)	RGB(3)	BRG(4)	RBG(5)
>>> + * ----------+-------------------------------------------------
>>> + * RGB (NOP) |	GBR	GRB	BGR	RGB	BRG	RBG
>>> + * GRB (1-2) |	BGR	RGB	GBR	GRB	RBG	BRG
>>> + * RBG (2-3) |	GRB	GBR	BRG	RBG	BGR	RGB
>>> + * BGR (1-3) |	RBG	BRG	RGB	BGR	GRB	GBR
>>> + * BRG (ROR) |	BRG	RBG	GRB	GBR	RGB	BGR
>>> + * GBR (ROL) |	RGB	BGR	RBG	BRG	GBR	GRB
>>> + */
>>> +static unsigned int adv7604_op_ch_sel(struct adv7604_state *state)
>>> +{
>>> +#define _SEL(a,b,c,d,e,f)	{ \
>>> +	ADV7604_OP_CH_SEL_##a, ADV7604_OP_CH_SEL_##b, ADV7604_OP_CH_SEL_##c, 
> \
>>> +	ADV7604_OP_CH_SEL_##d, ADV7604_OP_CH_SEL_##e, ADV7604_OP_CH_SEL_##f }
>>> +#define _BUS(x)			[ADV7604_BUS_ORDER_##x]
>>> +
>>> +	static const unsigned int op_ch_sel[6][6] = {
>>> +		_BUS(RGB) /* NOP */ = _SEL(GBR, GRB, BGR, RGB, BRG, RBG),
>>> +		_BUS(GRB) /* 1-2 */ = _SEL(BGR, RGB, GBR, GRB, RBG, BRG),
>>> +		_BUS(RBG) /* 2-3 */ = _SEL(GRB, GBR, BRG, RBG, BGR, RGB),
>>> +		_BUS(BGR) /* 1-3 */ = _SEL(RBG, BRG, RGB, BGR, GRB, GBR),
>>> +		_BUS(BRG) /* ROR */ = _SEL(BRG, RBG, GRB, GBR, RGB, BGR),
>>> +		_BUS(GBR) /* ROL */ = _SEL(RGB, BGR, RBG, BRG, GBR, GRB),
>>> +	};
>>> +
>>> +	return op_ch_sel[state->pdata.bus_order][state->format->op_ch_sel];
>>
>> But you don't shift state->format->op_ch_sel back 5 bits to the right, so
>> you end up with a random memory value. It should be:
>>
>> 	return op_ch_sel[state->pdata.bus_order][state->format->op_ch_sel >> 5];
>>
>> After correcting this everything worked fine for me.
> 
> Good catch ! Thank you. I've fixed that and submitted v4.
> 
> In addition to this patch, I'm only missing your Acked-by or Reviewed-by tag 
> for patch 47/48 ("adv7604: Add LLC polarity configuration"). Could you please 
> provide that ?

Done.

> I'll then send a pull request to Mauro for the whole series.

I'll test v4 of this patch tomorrow (ping me if you haven't seen anything from me
by 11 am!). If all is well, then I'll reply with my reviewed-by and tested-by
tags.

Regards,

	Hans
