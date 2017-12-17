Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:46926 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757373AbdLQRab (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 12:30:31 -0500
Subject: Re: [PATCH v2 1/6] cx25840: add pin to pad mapping and output format
 configuration
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <0bccfd81-e224-ffcc-bc95-d23ddd7d00b9@maciej.szmigiero.name>
 <20171211132738.42476937@vento.lan>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <3c381668-06db-3965-ffde-1feda40e8c40@maciej.szmigiero.name>
Date: Sun, 17 Dec 2017 18:30:27 +0100
MIME-Version: 1.0
In-Reply-To: <20171211132738.42476937@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.12.2017 16:27, Mauro Carvalho Chehab wrote:
> Em Tue, 10 Oct 2017 23:34:45 +0200
> "Maciej S. Szmigiero" <mail@maciej.szmigiero.name> escreveu:
> 
>> This commit adds pin to pad mapping and output format configuration support
>> in CX2584x-series chips to cx25840 driver.
>>
>> This functionality is then used to allow disabling ivtv-specific hacks
>> (called a "generic mode"), so cx25840 driver can be used for other devices
>> not needing them without risking compatibility problems.
>>
>> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
>> ---
>>  drivers/media/i2c/cx25840/cx25840-core.c | 394 ++++++++++++++++++++++++++++++-
>>  drivers/media/i2c/cx25840/cx25840-core.h |  11 +
>>  drivers/media/i2c/cx25840/cx25840-vbi.c  |   3 +
>>  drivers/media/pci/ivtv/ivtv-i2c.c        |   1 +
>>  include/media/drv-intf/cx25840.h         |  74 +++++-
>>  5 files changed, 481 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
>> index f38bf819d805..a1efc975852c 100644
>> --- a/drivers/media/i2c/cx25840/cx25840-core.c
>> +++ b/drivers/media/i2c/cx25840/cx25840-core.c
(..)
>> @@ -1630,6 +1907,117 @@ static void log_audio_status(struct i2c_client *client)
>>  	}
>>  }
>>  
>> +#define CX25840_VCONFIG_OPTION(option_mask)				\
>> +	do {								\
>> +		if (config_in & (option_mask)) {			\
>> +			state->vid_config &= ~(option_mask);		\
>> +			state->vid_config |= config_in & (option_mask); \
> 
> Don't do that: the "config_in" var is not at the macro's parameter.
> It only works if this macro is called at cx25840_vconfig() function.
> The same applies to state. That makes harder for anyone reviewing the
> code to understand it. Also, makes harder to use it on any other place.
> 
> If you want to use a macro, please add all required vars to the macro
> parameters.
> 
>> +		}							\
>> +	} while (0)
>> +
>> +#define CX25840_VCONFIG_SET_BIT(optionmask, reg, bit, oneval)		\
>> +	do {								\
>> +		if (state->vid_config & (optionmask)) {		\
>> +			if ((state->vid_config & (optionmask)) ==	\
>> +			    (oneval))					\
>> +				voutctrl[reg] |= BIT(bit);		\
>> +			else						\
>> +				voutctrl[reg] &= ~BIT(bit);		\
>> +		}							\
>> +	} while (0)
> 
> Same applies here: state and voutctrl aren't at macro's parameters.
> 
>> +
>> +int cx25840_vconfig(struct i2c_client *client, u32 config_in)
>> +{
>> +	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
>> +	u8 voutctrl[3];
>> +	unsigned int i;
>> +
>> +	/* apply incoming options to the current state */
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_FMT_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_RES_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_VBIRAW_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_ANCDATA_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_TASKBIT_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_ACTIVE_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_VALID_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_HRESETW_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_CLKGATE_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_DCMODE_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_IDID0S_MASK);
>> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_VIPCLAMP_MASK);
> 
> The entire logic here sounds complex, without need. Wouldn't be
> better/clearer if you rewrite it as:
> 
> 	u32 option_mask = CX25840_VCONFIG_FMT_MASK
> 	       | CX25840_VCONFIG_RES_MASK
> ...
> 	       | CX25840_VCONFIG_VIPCLAMP_MASK;
> 
> 	state->vid_config &= ~option_mask;
> 	state->vid_config |= config_in & option_mask;
> 
> 

Unfortunately, this would zero the current configuration in
state->vid_config for every possible parameter, whereas the macros above
only touch these parameters that are provided to a cx25840_vconfig()
invocation, leaving the rest as-is.

(All other your comments were implemented in a respin).

> 
> Thanks,
> Mauro
> 

Thanks,
Maciej
