Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52618 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728515AbeGQNCS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 09:02:18 -0400
Subject: Re: [PATCH v7 3/6] cx25840: add pin to pad mapping and output format
 configuration
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
References: <cover.1530565770.git.mail@maciej.szmigiero.name>
 <984fbf6359a896f156ddf64b1fb8211c3cca54e3.1530565770.git.mail@maciej.szmigiero.name>
 <3421f58a-3a60-28f1-830c-66f5d1bf5517@xs4all.nl>
 <b9ab4947-b306-3f9e-1951-a4fd62987f8f@maciej.szmigiero.name>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <718c9066-07f0-2b80-f2eb-4f7681b6c9cd@xs4all.nl>
Date: Tue, 17 Jul 2018 14:29:49 +0200
MIME-Version: 1.0
In-Reply-To: <b9ab4947-b306-3f9e-1951-a4fd62987f8f@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/18 23:47, Maciej S. Szmigiero wrote:
> Hi Hans,
> 
> On 04.07.2018 11:05, Hans Verkuil wrote:
>> On 02/07/18 23:23, Maciej S. Szmigiero wrote:
> (..)
>>> @@ -316,6 +319,260 @@ static int cx23885_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
>>>  	return 0;
>>>  }
>>>  
>>> +static u8 cx25840_function_to_pad(struct i2c_client *client, u8 function)
>>> +{
>>> +	switch (function) {
>>> +	case CX25840_PAD_ACTIVE:
>>> +		return 1;
>>> +
>>> +	case CX25840_PAD_VACTIVE:
>>> +		return 2;
>>> +
>>> +	case CX25840_PAD_CBFLAG:
>>> +		return 3;
>>> +
>>> +	case CX25840_PAD_VID_DATA_EXT0:
>>> +		return 4;
>>> +
>>> +	case CX25840_PAD_VID_DATA_EXT1:
>>> +		return 5;
>>> +
>>> +	case CX25840_PAD_GPO0:
>>> +		return 6;
>>> +
>>> +	case CX25840_PAD_GPO1:
>>> +		return 7;
>>> +
>>> +	case CX25840_PAD_GPO2:
>>> +		return 8;
>>> +
>>> +	case CX25840_PAD_GPO3:
>>> +		return 9;
>>> +
>>> +	case CX25840_PAD_IRQ_N:
>>> +		return 10;
>>> +
>>> +	case CX25840_PAD_AC_SYNC:
>>> +		return 11;
>>> +
>>> +	case CX25840_PAD_AC_SDOUT:
>>> +		return 12;
>>> +
>>> +	case CX25840_PAD_PLL_CLK:
>>> +		return 13;
>>> +
>>> +	case CX25840_PAD_VRESET:
>>> +		return 14;
>>> +
>>> +	default:
>>> +		if (function != CX25840_PAD_DEFAULT)
>>> +			v4l_err(client,
>>> +				"invalid function %u, assuming default\n",
>>> +				(unsigned int)function);
>>> +		return 0;
>>> +	}
>>
>> Unless I am mistaken this function boils down to:
>>
>> static u8 cx25840_function_to_pad(struct i2c_client *client, u8 function)
>> {
>> 	return function > CX25840_PAD_VRESET ? 0 : function;
>> }
> 
> Yes, you are right these functions are equivalent (sans a warning when
> a caller passes an invalid function).
> 
> However, these values (CX25840_PAD_*) were meant to be driver-internal.
> If we use them also as register value constants (which is what
> cx25840_function_to_pad() is supposed to return) then we'll need to add
> a comment to their enum cx25840_io_pad so nobody shuffles them or changes
> their values by mistake.

Right. Just add a comment and keep it simple.

> 
>>> @@ -1647,6 +1924,119 @@ static void log_audio_status(struct i2c_client *client)
>>>  	}
>>>  }
>>>  
>>> +#define CX25840_VCONFIG_OPTION(state, cfg_in, opt_msk)			\
>>> +	do {								\
>>> +		if ((cfg_in) & (opt_msk)) {				\
>>> +			(state)->vid_config &= ~(opt_msk);		\
>>> +			(state)->vid_config |= (cfg_in) & (opt_msk);	\
>>> +		}							\
>>> +	} while (0)
>>> +
>>> +#define CX25840_VCONFIG_SET_BIT(state, opt_msk, voc, idx, bit, oneval)	\
>>> +	do {								\
>>> +		if ((state)->vid_config & (opt_msk)) {			\
>>> +			if (((state)->vid_config & (opt_msk)) ==	\
>>> +			    (oneval))					\
>>> +				(voc)[idx] |= BIT(bit);		\
>>> +			else						\
>>> +				(voc)[idx] &= ~BIT(bit);		\
>>> +		}							\
>>> +	} while (0)
>>> +
>>> +int cx25840_vconfig(struct i2c_client *client, u32 cfg_in)
>>> +{
>>> +	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
>>> +	u8 voutctrl[3];
>>> +	unsigned int i;
>>> +
>>> +	/* apply incoming options to the current state */
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_FMT_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_RES_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_VBIRAW_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_ANCDATA_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_TASKBIT_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_ACTIVE_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_VALID_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_HRESETW_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_CLKGATE_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_DCMODE_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_IDID0S_MASK);
>>> +	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_VIPCLAMP_MASK);
>>
>> This appears to be a very complex way of saying:
>>
>> 	state->vid_config = cfg_in;
> 
> This is supposed to change in vid_config only these options that are set
> in the incoming cfg_in, leaving the rest as-is.
> 
> If the code simply assigns cfg_in to vid_config it will also clear all the
> existing options.

Ah yes, but see my reply below at the end.

> 
>>
>>> +
>>> +	for (i = 0; i < 3; i++)
>>> +		voutctrl[i] = cx25840_read(client, 0x404 + i);
>>> +
>>> +	/* apply state to hardware regs */
>>> +	if (state->vid_config & CX25840_VCONFIG_FMT_MASK)
>>> +		voutctrl[0] &= ~3;
>>> +	switch (state->vid_config & CX25840_VCONFIG_FMT_MASK) {
>>> +	case CX25840_VCONFIG_FMT_BT656:
>>> +		voutctrl[0] |= 1;
>>> +		break;
>>> +
>>> +	case CX25840_VCONFIG_FMT_VIP11:
>>> +		voutctrl[0] |= 2;
>>> +		break;
>>> +
>>> +	case CX25840_VCONFIG_FMT_VIP2:
>>> +		voutctrl[0] |= 3;
>>> +		break;
>>> +
>>> +	case CX25840_VCONFIG_FMT_BT601:
>>> +		/* zero */
>>> +	default:
>>> +		break;
>>> +	}
>>> +
>>> +	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_RES_MASK, voutctrl,
>>> +				0, 2, CX25840_VCONFIG_RES_10BIT);
>>> +	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_VBIRAW_MASK, voutctrl,
>>> +				0, 3, CX25840_VCONFIG_VBIRAW_ENABLED);
>>> +	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_ANCDATA_MASK, voutctrl,
>>> +				0, 4, CX25840_VCONFIG_ANCDATA_ENABLED);
>>> +	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_TASKBIT_MASK, voutctrl,
>>> +				0, 5, CX25840_VCONFIG_TASKBIT_ONE);
>>> +	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_ACTIVE_MASK, voutctrl,
>>> +				1, 2, CX25840_VCONFIG_ACTIVE_HORIZONTAL);
>>> +	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_VALID_MASK, voutctrl,
>>> +				1, 3, CX25840_VCONFIG_VALID_ANDACTIVE);
>>> +	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_HRESETW_MASK, voutctrl,
>>> +				1, 4, CX25840_VCONFIG_HRESETW_PIXCLK);
>>> +
>>> +	if (state->vid_config & CX25840_VCONFIG_CLKGATE_MASK)
>>> +		voutctrl[1] &= ~(3 << 6);
>>> +	switch (state->vid_config & CX25840_VCONFIG_CLKGATE_MASK) {
>>> +	case CX25840_VCONFIG_CLKGATE_VALID:
>>> +		voutctrl[1] |= 2;
>>> +		break;
>>> +
>>> +	case CX25840_VCONFIG_CLKGATE_VALIDACTIVE:
>>> +		voutctrl[1] |= 3;
>>> +		break;
>>> +
>>> +	case CX25840_VCONFIG_CLKGATE_NONE:
>>> +		/* zero */
>>> +	default:
>>> +		break;
>>> +	}
>>> +
>>> +
>>> +	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_DCMODE_MASK, voutctrl,
>>> +				2, 0, CX25840_VCONFIG_DCMODE_BYTES);
>>> +	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_IDID0S_MASK, voutctrl,
>>> +				2, 1, CX25840_VCONFIG_IDID0S_LINECNT);
>>> +	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_VIPCLAMP_MASK, voutctrl,
>>> +				2, 4, CX25840_VCONFIG_VIPCLAMP_ENABLED);
>>> +
>>> +	for (i = 0; i < 3; i++)
>>> +		cx25840_write(client, 0x404 + i, voutctrl[i]);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +#undef CX25840_VCONFIG_SET_BIT
>>> +#undef CX25840_VCONFIG_OPTION
>>
>> Why #undef? You would normally never do that.
> 
> The idea here is to catch (unintended) other users of these macros, other
> than cx25840_vconfig() and to not pollute the macro namespace.
> But these #undefs can be removed if they are against the coding style.

Please remove. You do not normally use #undef unless you are redefining a
macro.

> 
>>
>>> +
>>>  /* ----------------------------------------------------------------------- */
>>>  
>>>  /* This load_fw operation must be called to load the driver's firmware.
>>> @@ -1836,6 +2226,9 @@ static int cx25840_s_video_routing(struct v4l2_subdev *sd,
>>>  	if (is_cx23888(state))
>>>  		cx23888_std_setup(client);
>>>  
>>> +	if (is_cx2584x(state) && state->generic_mode)
>>> +		cx25840_vconfig(client, config);
>>> +
>>
>> You do the vconfig configuration when the video routing changes. But isn't this
>> configuration a one-time thing? E.g. something you do only when initializing the
>> board?
>>
>> At least in the cxusb code the cfg_in value is constant and not dependent on what
>> input is chosen.
>>
>> If this is true, then you should add the core init op instead. And as a bonus you
>> can turn on generic_mode if the init op is called instead of having to add it
>> to the platform data.
>>
> 
> The problem here is that the Medion MD95700 has two modes:
> digital (DVB-T) and analog.
> When it is operating in the digital mode the device analog components
> (including the cx25840 chip) have their power cut by the hardware.
> 
> This means that the cx25840 has to be fully reinitialized (firmware
> loaded, format set, etc.) every time the user opens the Medion's v4l2
> video or radio device node if the device has previously operated in the
> DVB-T mode.
> Mode switching is supported transparently by the driver without needing
> to reload the module or reconnect the device.

So? You call the core init op to initialize vconfig (just pass in all the
bits to simplify things), and whenever s_video_routing it called the driver
will just call cx25840_vconfig() with the vconfig value set by the core init op.

As far as I can see all you want to do is to specify a specific vconfig value
that should be applied whenever s_video_routing is called.

So in cxusb_medion_analog_init() you call the core init op, then the
video s_routing op to switch to COMPOSITE1.

I like that much better since vconfig doesn't change when you switch inputs.
It's only needed when you initialize the analog part.

Regards,

	Hans

> 
>>
>> Regards,
>>
>> 	Hans
>>
> 
> Thanks and best regards,
> Maciej
> 
