Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab1GSMpR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 08:45:17 -0400
Message-ID: <4E257C1A.7080705@redhat.com>
Date: Tue, 19 Jul 2011 09:44:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Doron Cohen <doronc@siano-ms.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@hauppauge.com>,
	Steven Toth <stoth@hauppauge.com>
Subject: Re: FW: [PATCH] drivers: support new Siano tuner devices.
References: <D945C405928A9949A0F33C69E64A1A3BAFFC4B@s-mail.siano-ms.ent> <alpine.LNX.2.00.1107191334400.5752@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1107191334400.5752@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-07-2011 08:35, Jesper Juhl escreveu:
>
> Adding linux-media@vger.kernel.org to CC

Thanks, Jesper!

> On Tue, 19 Jul 2011, Doron Cohen wrote:
>
>>
>> Hi,
>> This is the first time I ever post changes to linux kernel, so excuse me
>> if I have errors in the process.
>> As Siano team member, I would like to update the drivers for Siano
>> devices with the latest and greatest fixes. Unfortunately there is a hug
>> gap between the current code in the kernel and the code Siano has which
>> is more advanced and supports newer devices. I will try to break down
>> the changes into small pieces so each of the changes will be clear and
>> isolated.
>> Here is the first change which is my "test balloon" and includes simple
>> changes which includes support in new devices pulished after the kernel
>> source maintenance has stopped.

Hi Doron,

Breaking them into one patch per logical change is the right thing to do.
We have several documents at linux Documentation/ that helps newer contributors
to understand how things work. The main ones are also at our wiki:
	http://linuxtv.org/wiki/index.php/Developer_Section

For each patch you post, you should use as the subject, a one line description
of what the patch is doing, like:

siano: add new tuner devices

At the body, a long description describing why and how (except if the patch is
really trivial), followed by your Signed-off-by, as described at:
	http://linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Developer.27s_Certificate_of_Origin_1.1

If you need to add extra notes for the reviewers/maintainer, you can add it, after
the description, prepended with "---". So, the email body will look like:

Include newer sms1xxx boards

Signed-off-by: Doron Cohen <doronc@siano-ms.com>

---

some comment that I don't want to go to the kernel for whatever reason

--- a/drivers/media/dvb/siano/sms-cards.c
+++ b/drivers/media/dvb/siano/sms-cards.c
@@ -26,45 +26,66 @@ MODULE_PARM_DESC(cards_dbg, "set debug level (info=1, adv=2 (or-able))");
....


PS.: if you are not the patch author, you should add a From: at the first line of the email
body to say so.


>>
>> diff --git a/drivers/media/dvb/siano/sms-cards.c
>> b/drivers/media/dvb/siano/sms-cards.c
>> index af121db..302a9e3 100644
>> --- a/drivers/media/dvb/siano/sms-cards.c
>> +++ b/drivers/media/dvb/siano/sms-cards.c
>> @@ -26,45 +26,66 @@ MODULE_PARM_DESC(cards_dbg, "set debug level
>> (info=1, adv=2 (or-able))");

Your emailer is not handling patches well: it is breaking long lines, damaging it.
You need either to fix it by removing long line breaks or to use another emailer.

>>
>>   static struct sms_board sms_boards[] = {
>>   	[SMS_BOARD_UNKNOWN] = {
>> -		.name	= "Unknown board",
>> +	/* 0 */

Why do you need to add a sequence number?

>> +		.name = "Unknown board",

Please, don't mix pure whitespace changes with other things.
It makes harder to analyze what really changed.

>> +		.type = SMS_UNKNOWN_TYPE,
>> +		.default_mode = DEVICE_MODE_NONE,
>>   	},
>>   	[SMS1XXX_BOARD_SIANO_STELLAR] = {
>> -		.name	= "Siano Stellar Digital Receiver",
>> -		.type	= SMS_STELLAR,
>> +	/* 1 */
>> +		.name =
>> +		"Siano Stellar Digital Receiver",
>> +		.type = SMS_STELLAR,
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>>   	},
>>   	[SMS1XXX_BOARD_SIANO_NOVA_A] = {
>> -		.name	= "Siano Nova A Digital Receiver",
>> -		.type	= SMS_NOVA_A0,
>> +	/* 2 */
>> +		.name = "Siano Nova A Digital Receiver",
>> +		.type = SMS_NOVA_A0,
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>>   	},
>>   	[SMS1XXX_BOARD_SIANO_NOVA_B] = {
>> -		.name	= "Siano Nova B Digital Receiver",
>> -		.type	= SMS_NOVA_B0,
>> +	/* 3 */
>> +		.name = "Siano Nova B Digital Receiver",
>> +		.type = SMS_NOVA_B0,
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>>   	},
>>   	[SMS1XXX_BOARD_SIANO_VEGA] = {
>> -		.name	= "Siano Vega Digital Receiver",
>> -		.type	= SMS_VEGA,
>> +	/* 4 */
>> +		.name = "Siano Vega Digital Receiver",
>> +		.type = SMS_VEGA,
>> +		.default_mode = DEVICE_MODE_CMMB,
>>   	},
>>   	[SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT] = {
>> -		.name	= "Hauppauge Catamount",
>> -		.type	= SMS_STELLAR,
>> -		.fw[DEVICE_MODE_DVBT_BDA] =
>> "sms1xxx-stellar-dvbt-01.fw",
>> +	/* 5 */
>> +		.name = "Hauppauge Catamount",
>> +		.type = SMS_STELLAR,
>> +		.fw[DEVICE_MODE_DVBT_BDA] =
>> +		"sms1xxx-stellar-dvbt-01.fw",
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>>   	},
>>   	[SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A] = {
>> -		.name	= "Hauppauge Okemo-A",
>> -		.type	= SMS_NOVA_A0,
>> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-a-dvbt-01.fw",
>> +	/* 6 */
>> +		.name = "Hauppauge Okemo-A",
>> +		.type = SMS_NOVA_A0,
>> +		.fw[DEVICE_MODE_DVBT_BDA] =
>> +		"sms1xxx-nova-a-dvbt-01.fw",
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>>   	},
>>   	[SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B] = {
>> -		.name	= "Hauppauge Okemo-B",
>> -		.type	= SMS_NOVA_B0,
>> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-b-dvbt-01.fw",
>> +	/* 7 */
>> +		.name = "Hauppauge Okemo-B",
>> +		.type = SMS_NOVA_B0,
>> +		.fw[DEVICE_MODE_DVBT_BDA] =
>> +		"sms1xxx-nova-b-dvbt-01.fw",

Wrong indent. I would just do:
		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-b-dvbt-01.fw",
even if the line is bigger than 80 columns.

>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>>   	},
>>   	[SMS1XXX_BOARD_HAUPPAUGE_WINDHAM] = {
>> -		.name	= "Hauppauge WinTV MiniStick",
>> -		.type	= SMS_NOVA_B0,
>> -		.fw[DEVICE_MODE_ISDBT_BDA] =
>> "sms1xxx-hcw-55xxx-isdbt-02.fw",
>> +	/* 8 */
>> +		.name = "Hauppauge WinTV MiniStick",
>> +		.type = SMS_NOVA_B0,
>>   		.fw[DEVICE_MODE_DVBT_BDA] =
>> "sms1xxx-hcw-55xxx-dvbt-02.fw",
>> -		.rc_codes = RC_MAP_HAUPPAUGE,

This change breaks IR support.

>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>>   		.board_cfg.leds_power = 26,
>>   		.board_cfg.led0 = 27,
>>   		.board_cfg.led1 = 28,
>> @@ -74,30 +95,92 @@ static struct sms_board sms_boards[] = {
>>   		.led_hi    = 28,
>>   	},
>>   	[SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD] = {
>> +	/* 9 */
>>   		.name	= "Hauppauge WinTV MiniCard",
>>   		.type	= SMS_NOVA_B0,
>>   		.fw[DEVICE_MODE_DVBT_BDA] =
>> "sms1xxx-hcw-55xxx-dvbt-02.fw",
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>>   		.lna_ctrl  = 29,
>>   		.board_cfg.foreign_lna0_ctrl = 29,
>>   		.rf_switch = 17,
>>   		.board_cfg.rf_switch_uhf = 17,
>>   	},
>>   	[SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2] = {
>> -		.name	= "Hauppauge WinTV MiniCard",
>> -		.type	= SMS_NOVA_B0,
>> +	/* 10 */
>> +		.name = "Hauppauge WinTV MiniCard",
>> +		.type = SMS_NOVA_B0,
>>   		.fw[DEVICE_MODE_DVBT_BDA] =
>> "sms1xxx-hcw-55xxx-dvbt-02.fw",
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>> +		.board_cfg.foreign_lna0_ctrl = 1,
>>   		.lna_ctrl  = -1,
>>   	},
>>   	[SMS1XXX_BOARD_SIANO_NICE] = {
>>   	/* 11 */
>>   		.name = "Siano Nice Digital Receiver",
>>   		.type = SMS_NOVA_B0,
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>>   	},
>>   	[SMS1XXX_BOARD_SIANO_VENICE] = {
>>   	/* 12 */
>>   		.name = "Siano Venice Digital Receiver",
>> -		.type = SMS_VEGA,
>> +		.type = SMS_VENICE,
>> +		.default_mode = DEVICE_MODE_CMMB,
>>   	},
>> +	[SMS1XXX_BOARD_SIANO_STELLAR_ROM] = {
>> +	/* 13 */
>> +		.name =
>> +		"Siano Stellar Digital Receiver ROM",
>> +		.type = SMS_STELLAR,
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>> +		.intf_num = 1,
>> +	},
>> +	[SMS1XXX_BOARD_ZTE_DVB_DATA_CARD] = {
>> +	/* 14 */
>> +		.name = "ZTE Data Card Digital Receiver",
>> +		.type = SMS_NOVA_B0,
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>> +		.intf_num = 5,
>> +		.mtu = 15792,
>> +	},
>> +	[SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD] = {
>> +	/* 15 */
>> +		.name = "ONDA Data Card Digital Receiver",
>> +		.type = SMS_NOVA_B0,
>> +		.default_mode = DEVICE_MODE_DVBT_BDA,
>> +		.intf_num = 6,
>> +		.mtu = 15792,
>> +	},
>> +	[SMS1XXX_BOARD_SIANO_MING] = {
>> +	/* 16 */
>> +		.name = "Siano Ming Digital Receiver",
>> +		.type = SMS_MING,
>> +		.default_mode = DEVICE_MODE_CMMB,
>> +	},
>> +	[SMS1XXX_BOARD_SIANO_PELE] = {
>> +	/* 17 */
>> +		.name = "Siano Pele Digital Receiver",
>> +		.type = SMS_PELE,
>> +		.default_mode = DEVICE_MODE_ISDBT_BDA,
>> +	},
>> +	[SMS1XXX_BOARD_SIANO_RIO] = {
>> +	/* 18 */
>> +		.name = "Siano Rio Digital Receiver",
>> +		.type = SMS_RIO,
>> +		.default_mode = DEVICE_MODE_ISDBT_BDA,
>> +	},
>> +	[SMS1XXX_BOARD_SIANO_DENVER_1530] = {
>> +    /* 19 */
>> +        .name = "Siano Denver (ATSC-M/H) Digital Receiver",
>> +        .type = SMS_DENVER_1530,
>> +        .default_mode = DEVICE_MODE_ATSC,
>> +	.crystal = 2400,
>> +    },
>> +    [SMS1XXX_BOARD_SIANO_DENVER_2160] = {
>> +    /* 20 */
>> +        .name = "Siano Denver (TDMB) Digital Receiver",
>> +        .type = SMS_DENVER_2160,
>> +        .default_mode = DEVICE_MODE_DAB_TDMB,
>> +    },
>>   };

The above is the board inclusion. However, the changes bellow are not just new board
addition. One rule we have is that a patch should never cause any regressions to the
existing devices. That's the main reason why we want patches to be broken into logical
changes: it makes easier for reviewers to check what is changing at the code and
trying to identify potential regressions.

So, before the board addition patches, submit patches with the changes at the
board configuration logic that allow us to better review what's there.


>>
>>   struct sms_board *sms_get_board(unsigned id)
>> @@ -109,31 +192,108 @@ struct sms_board *sms_get_board(unsigned id)
>>   EXPORT_SYMBOL_GPL(sms_get_board);
>>   static inline void sms_gpio_assign_11xx_default_led_config(
>>   		struct smscore_gpio_config *pGpioConfig) {
>> -	pGpioConfig->Direction = SMS_GPIO_DIRECTION_OUTPUT;
>> -	pGpioConfig->InputCharacteristics =
>> -		SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL;
>> -	pGpioConfig->OutputDriving = SMS_GPIO_OUTPUT_DRIVING_4mA;
>> -	pGpioConfig->OutputSlewRate =
>> SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS;
>> -	pGpioConfig->PullUpDown = SMS_GPIO_PULL_UP_DOWN_NONE;
>> +	pGpioConfig->direction = SMS_GPIO_DIRECTION_OUTPUT;
>> +	pGpioConfig->input_characteristics =
>> SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL;
>> +	pGpioConfig->output_driving = SMS_GPIO_OUTPUTDRIVING_4mA;
>> +	pGpioConfig->output_slew_rate =
>> SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS;
>> +	pGpioConfig->pull_up_down = SMS_GPIO_PULL_UP_DOWN_NONE;
>>   }
>>
>>   int sms_board_event(struct smscore_device_t *coredev,
>>   		enum SMS_BOARD_EVENTS gevent) {
>> +	int board_id = smscore_get_board_id(coredev);
>> +	struct sms_board *board = sms_get_board(board_id);
>>   	struct smscore_gpio_config MyGpioConfig;
>>
>>   	sms_gpio_assign_11xx_default_led_config(&MyGpioConfig);
>>
>>   	switch (gevent) {
>>   	case BOARD_EVENT_POWER_INIT: /* including hotplug */
>> +		switch (board_id) {
>> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
>> +			/* set I/O and turn off all LEDs */
>> +			smscore_gpio_configure(coredev,
>> +					board->board_cfg.leds_power,
>> +					&MyGpioConfig);
>> +			smscore_gpio_set_level(coredev,
>> +					board->board_cfg.leds_power, 0);
>> +			smscore_gpio_configure(coredev,
>> board->board_cfg.led0,
>> +					&MyGpioConfig);
>> +			smscore_gpio_set_level(coredev,
>> +					board->board_cfg.led0, 0);
>> +			smscore_gpio_configure(coredev,
>> board->board_cfg.led1,
>> +					&MyGpioConfig);
>> +			smscore_gpio_set_level(coredev,
>> +					board->board_cfg.led1, 0);
>> +			break;
>> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
>> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
>> +			/* set I/O and turn off LNA */
>> +			smscore_gpio_configure(coredev,
>> +
>> board->board_cfg.foreign_lna0_ctrl,
>> +					&MyGpioConfig);
>> +			smscore_gpio_set_level(coredev,
>> +
>> board->board_cfg.foreign_lna0_ctrl,
>> +					0);
>> +			break;
>> +		}
>>   		break; /* BOARD_EVENT_BIND */
>>
>>   	case BOARD_EVENT_POWER_SUSPEND:
>> +		switch (board_id) {
>> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
>> +			smscore_gpio_set_level(coredev,
>> +
>> board->board_cfg.leds_power, 0);
>> +			smscore_gpio_set_level(coredev,
>> +						board->board_cfg.led0,
>> 0);
>> +			smscore_gpio_set_level(coredev,
>> +						board->board_cfg.led1,
>> 0);
>> +			break;
>> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
>> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
>> +			smscore_gpio_set_level(coredev,
>> +
>> board->board_cfg.foreign_lna0_ctrl,
>> +					0);
>> +			break;
>> +		}
>>   		break; /* BOARD_EVENT_POWER_SUSPEND */
>>
>>   	case BOARD_EVENT_POWER_RESUME:
>> +		switch (board_id) {
>> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
>> +			smscore_gpio_set_level(coredev,
>> +
>> board->board_cfg.leds_power, 1);
>> +			smscore_gpio_set_level(coredev,
>> +						board->board_cfg.led0,
>> 1);
>> +			smscore_gpio_set_level(coredev,
>> +						board->board_cfg.led1,
>> 0);
>> +			break;
>> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
>> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
>> +			smscore_gpio_set_level(coredev,
>> +
>> board->board_cfg.foreign_lna0_ctrl,
>> +					1);
>> +			break;
>> +		}
>>   		break; /* BOARD_EVENT_POWER_RESUME */
>>
>>   	case BOARD_EVENT_BIND:
>> +		switch (board_id) {
>> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
>> +			smscore_gpio_set_level(coredev,
>> +				board->board_cfg.leds_power, 1);
>> +			smscore_gpio_set_level(coredev,
>> +				board->board_cfg.led0, 1);
>> +			smscore_gpio_set_level(coredev,
>> +				board->board_cfg.led1, 0);
>> +			break;
>> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
>> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
>> +			smscore_gpio_set_level(coredev,
>> +
>> board->board_cfg.foreign_lna0_ctrl,
>> +					1);
>> +			break;
>> +		}
>>   		break; /* BOARD_EVENT_BIND */
>>
>>   	case BOARD_EVENT_SCAN_PROG:
>> @@ -143,8 +303,20 @@ int sms_board_event(struct smscore_device_t
>> *coredev,
>>   	case BOARD_EVENT_EMERGENCY_WARNING_SIGNAL:
>>   		break; /* BOARD_EVENT_EMERGENCY_WARNING_SIGNAL */
>>   	case BOARD_EVENT_FE_LOCK:
>> +		switch (board_id) {
>> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
>> +			smscore_gpio_set_level(coredev,
>> +			board->board_cfg.led1, 1);
>> +			break;
>> +		}
>>   		break; /* BOARD_EVENT_FE_LOCK */
>>   	case BOARD_EVENT_FE_UNLOCK:
>> +		switch (board_id) {
>> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
>> +			smscore_gpio_set_level(coredev,
>> +						board->board_cfg.led1,
>> 0);
>> +			break;
>> +		}

Hmm... Hauppauge wanted to use a different logic for setting GPIO's for some reason.
So, they nacked some Uri patches related to it. If you're just doing a diff between
your tree and ours, I suspect that you're trying to push the changes that were
already nacked by them.

>>   		break; /* BOARD_EVENT_FE_UNLOCK */
>>   	case BOARD_EVENT_DEMOD_LOCK:
>>   		break; /* BOARD_EVENT_DEMOD_LOCK */
>> @@ -177,12 +349,12 @@ static int sms_set_gpio(struct smscore_device_t
>> *coredev, int pin, int enable)
>>   {
>>   	int lvl, ret;
>>   	u32 gpio;
>> -	struct smscore_config_gpio gpioconfig = {
>> +	struct smscore_gpio_config gpioconfig = {
>>   		.direction            = SMS_GPIO_DIRECTION_OUTPUT,
>> -		.pullupdown           = SMS_GPIO_PULLUPDOWN_NONE,
>> -		.inputcharacteristics =
>> SMS_GPIO_INPUTCHARACTERISTICS_NORMAL,
>> -		.outputslewrate       = SMS_GPIO_OUTPUTSLEWRATE_FAST,
>> -		.outputdriving        = SMS_GPIO_OUTPUTDRIVING_4mA,
>> +		.pull_up_down           = SMS_GPIO_PULL_UP_DOWN_NONE,
>> +		.input_characteristics =
>> SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL,
>> +		.output_slew_rate       =
>> SMS_GPIO_OUTPUT_SLEW_RATE_FAST,
>> +		.output_driving        = SMS_GPIO_OUTPUTDRIVING_4mA,
>>   	};
>>
>>   	if (pin == 0)
>> @@ -197,11 +369,11 @@ static int sms_set_gpio(struct smscore_device_t
>> *coredev, int pin, int enable)
>>   		lvl = enable ? 1 : 0;
>>   	}
>>
>> -	ret = smscore_configure_gpio(coredev, gpio,&gpioconfig);
>> +	ret = smscore_gpio_configure(coredev, gpio,&gpioconfig);
>>   	if (ret<  0)
>>   		return ret;
>>
>> -	return smscore_set_gpio(coredev, gpio, lvl);
>> +	return smscore_gpio_set_level(coredev, gpio, lvl);
>>   }
>>
>>   int sms_board_setup(struct smscore_device_t *coredev)
>> @@ -211,6 +383,7 @@ int sms_board_setup(struct smscore_device_t
>> *coredev)
>>
>>   	switch (board_id) {
>>   	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
>> +		smscore_gpio_set_level(coredev, board->board_cfg.led1,
>> 1);
>>   		/* turn off all LEDs */
>>   		sms_set_gpio(coredev, board->led_power, 0);
>>   		sms_set_gpio(coredev, board->led_hi, 0);
>> @@ -233,6 +406,7 @@ int sms_board_power(struct smscore_device_t
>> *coredev, int onoff)
>>
>>   	switch (board_id) {
>>   	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
>> +		smscore_gpio_set_level(coredev,	board->board_cfg.led1,
>> 0);
>>   		/* power LED */
>>   		sms_set_gpio(coredev,
>>   			     board->led_power, onoff ? 1 : 0);
>> diff --git a/drivers/media/dvb/siano/sms-cards.h
>> b/drivers/media/dvb/siano/sms-cards.h
>> index d8cdf75..b4abde5 100644
>> --- a/drivers/media/dvb/siano/sms-cards.h
>> +++ b/drivers/media/dvb/siano/sms-cards.h
>> @@ -37,6 +37,14 @@
>>   #define SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2 10
>>   #define SMS1XXX_BOARD_SIANO_NICE	11
>>   #define SMS1XXX_BOARD_SIANO_VENICE	12
>> +#define SMS1XXX_BOARD_SIANO_STELLAR_ROM 13
>> +#define SMS1XXX_BOARD_ZTE_DVB_DATA_CARD	14
>> +#define SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD 15
>> +#define SMS1XXX_BOARD_SIANO_MING	16
>> +#define SMS1XXX_BOARD_SIANO_PELE	17
>> +#define SMS1XXX_BOARD_SIANO_RIO		18
>> +#define SMS1XXX_BOARD_SIANO_DENVER_1530	19
>> +#define SMS1XXX_BOARD_SIANO_DENVER_2160 20
>>
>>   struct sms_board_gpio_cfg {
>>   	int lna_vhf_exist;
>> @@ -79,6 +87,12 @@ struct sms_board {
>>
>>   	/* gpios */
>>   	int led_power, led_hi, led_lo, lna_ctrl, rf_switch;
>> +	enum ir_kb_type ir_kb_type;
>> +	char intf_num;
>> +	int default_mode;
>> +	unsigned int mtu;
>> +	unsigned int crystal;
>> +	struct sms_antenna_config_ST* antenna_config;
>>   };
>>
>>   struct sms_board *sms_get_board(unsigned id);
>> diff --git a/drivers/media/dvb/siano/smscoreapi.c
>> b/drivers/media/dvb/siano/smscoreapi.c
>> index 78765ed..d1bcbc3 100644
>> --- a/drivers/media/dvb/siano/smscoreapi.c
>> +++ b/drivers/media/dvb/siano/smscoreapi.c
>> @@ -1290,53 +1290,6 @@ int smsclient_sendrequest(struct smscore_client_t
>> *client,
>>   EXPORT_SYMBOL_GPL(smsclient_sendrequest);
>>
>>
>> -/* old GPIO managements implementation */
>> -int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
>> -			   struct smscore_config_gpio *pinconfig)
>> -{

Again, I think that this is due to Hauppauge device. Assuming that this
is the case, I'm OK if you want to rename it to something like
hvr_legacy_configure_gpio to let it clearer, but if you want to remove
the code, please get their acks on that.

>> -	struct {
>> -		struct SmsMsgHdr_ST hdr;
>> -		u32 data[6];
>> -	} msg;
>> -
>> -	if (coredev->device_flags&  SMS_DEVICE_FAMILY2) {
>> -		msg.hdr.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
>> -		msg.hdr.msgDstId = HIF_TASK;
>> -		msg.hdr.msgFlags = 0;
>> -		msg.hdr.msgType  = MSG_SMS_GPIO_CONFIG_EX_REQ;
>> -		msg.hdr.msgLength = sizeof(msg);
>> -
>> -		msg.data[0] = pin;
>> -		msg.data[1] = pinconfig->pullupdown;
>> -
>> -		/* Convert slew rate for Nova: Fast(0) = 3 / Slow(1) =
>> 0; */
>> -		msg.data[2] = pinconfig->outputslewrate == 0 ? 3 : 0;
>> -
>> -		switch (pinconfig->outputdriving) {
>> -		case SMS_GPIO_OUTPUTDRIVING_16mA:
>> -			msg.data[3] = 7; /* Nova - 16mA */
>> -			break;
>> -		case SMS_GPIO_OUTPUTDRIVING_12mA:
>> -			msg.data[3] = 5; /* Nova - 11mA */
>> -			break;
>> -		case SMS_GPIO_OUTPUTDRIVING_8mA:
>> -			msg.data[3] = 3; /* Nova - 7mA */
>> -			break;
>> -		case SMS_GPIO_OUTPUTDRIVING_4mA:
>> -		default:
>> -			msg.data[3] = 2; /* Nova - 4mA */
>> -			break;
>> -		}
>> -
>> -		msg.data[4] = pinconfig->direction;
>> -		msg.data[5] = 0;
>> -	} else /* TODO: SMS_DEVICE_FAMILY1 */
>> -		return -EINVAL;
>> -
>> -	return coredev->sendrequest_handler(coredev->context,
>> -					&msg, sizeof(msg));
>> -}
>> -
>>   int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int
>> level)
>>   {
>>   	struct {
>> @@ -1460,19 +1413,19 @@ int smscore_gpio_configure(struct
>> smscore_device_t *coredev, u8 PinNum,
>>
>>   		pMsg->msgData[1] = TranslatedPinNum;
>>   		pMsg->msgData[2] = GroupNum;
>> -		ElectricChar = (pGpioConfig->PullUpDown)
>> -				| (pGpioConfig->InputCharacteristics<<
>> 2)
>> -				| (pGpioConfig->OutputSlewRate<<  3)
>> -				| (pGpioConfig->OutputDriving<<  4);
>> +		ElectricChar = (pGpioConfig->pull_up_down)
>> +				| (pGpioConfig->input_characteristics<<
>> 2)
>> +				| (pGpioConfig->output_slew_rate<<  3)
>> +				| (pGpioConfig->output_driving<<  4);

Not a big issue, but, as you're moving from CamelCase, it would be good
if you could also fix the CodingStyle, by adding an space before the "<<"
operation.

As a rule, always check your patches against codingStyle with
	./scripts/checkpatch.pl my_patch.patch

>>   		pMsg->msgData[3] = ElectricChar;
>> -		pMsg->msgData[4] = pGpioConfig->Direction;
>> +		pMsg->msgData[4] = pGpioConfig->direction;
>>   		pMsg->msgData[5] = groupCfg;
>>   	} else {
>>   		pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_CONFIG_EX_REQ;
>> -		pMsg->msgData[1] = pGpioConfig->PullUpDown;
>> -		pMsg->msgData[2] = pGpioConfig->OutputSlewRate;
>> -		pMsg->msgData[3] = pGpioConfig->OutputDriving;
>> -		pMsg->msgData[4] = pGpioConfig->Direction;
>> +		pMsg->msgData[1] = pGpioConfig->pull_up_down;
>> +		pMsg->msgData[2] = pGpioConfig->output_slew_rate;
>> +		pMsg->msgData[3] = pGpioConfig->output_driving;
>> +		pMsg->msgData[4] = pGpioConfig->direction;
>>   		pMsg->msgData[5] = 0;
>>   	}
>>
>> diff --git a/drivers/media/dvb/siano/smscoreapi.h
>> b/drivers/media/dvb/siano/smscoreapi.h
>> index 8ecadec..d2a184e 100644
>> --- a/drivers/media/dvb/siano/smscoreapi.h
>> +++ b/drivers/media/dvb/siano/smscoreapi.h
>> @@ -2,7 +2,7 @@
>>
>>   Siano Mobile Silicon, Inc.
>>   MDTV receiver kernel modules.
>> -Copyright (C) 2006-2008, Uri Shkolnik, Anatoly Greenblat
>> +Copyright (C) 2006-2011, Doron Cohen

Please, don't remove the existing copyrights. Just add yours bellow.

>>
>>   This program is free software: you can redistribute it and/or modify
>>   it under the terms of the GNU General Public License as published by
>> @@ -51,15 +51,23 @@ along with this program.  If not, see
>> <http://www.gnu.org/licenses/>.
>>   #define SMS_ALIGN_ADDRESS(addr) \
>>   	((((uintptr_t)(addr)) + (SMS_DMA_ALIGNMENT-1))&
>> ~(SMS_DMA_ALIGNMENT-1))
>>
>> +#define SMS_DEVICE_FAMILY1				0
>>   #define SMS_DEVICE_FAMILY2				1
>>   #define SMS_ROM_NO_RESPONSE				2
>>   #define SMS_DEVICE_NOT_READY				0x8000000
>>
>>   enum sms_device_type_st {
>> +	SMS_UNKNOWN_TYPE = -1,
>>   	SMS_STELLAR = 0,
>>   	SMS_NOVA_A0,
>>   	SMS_NOVA_B0,
>>   	SMS_VEGA,
>> +	SMS_VENICE,
>> +	SMS_MING,
>> +	SMS_PELE,
>> +	SMS_RIO,
>> +	SMS_DENVER_1530,
>> +	SMS_DENVER_2160,
>>   	SMS_NUM_OF_DEVICE_TYPES
>>   };
>>
>> @@ -278,6 +286,9 @@ enum SMS_DEVICE_MODE {
>>   	DEVICE_MODE_ISDBT_BDA,
>>   	DEVICE_MODE_CMMB,
>>   	DEVICE_MODE_RAW_TUNER,
>> +	DEVICE_MODE_FM_TUNER,
>> +	DEVICE_MODE_FM_TUNER_BDA,
>> +	DEVICE_MODE_ATSC,
>>   	DEVICE_MODE_MAX,
>>   };
>>
>> @@ -624,46 +635,21 @@ struct SMSHOSTLIB_I2C_RES_ST {
>>   };
>>
>>
>> -struct smscore_config_gpio {
>> -#define SMS_GPIO_DIRECTION_INPUT  0
>> -#define SMS_GPIO_DIRECTION_OUTPUT 1
>> -	u8 direction;
>> -
>> -#define SMS_GPIO_PULLUPDOWN_NONE     0
>> -#define SMS_GPIO_PULLUPDOWN_PULLDOWN 1
>> -#define SMS_GPIO_PULLUPDOWN_PULLUP   2
>> -#define SMS_GPIO_PULLUPDOWN_KEEPER   3
>> -	u8 pullupdown;
>> -
>> -#define SMS_GPIO_INPUTCHARACTERISTICS_NORMAL  0
>> -#define SMS_GPIO_INPUTCHARACTERISTICS_SCHMITT 1
>> -	u8 inputcharacteristics;
>> -
>> -#define SMS_GPIO_OUTPUTSLEWRATE_FAST 0
>> -#define SMS_GPIO_OUTPUTSLEWRATE_SLOW 1
>> -	u8 outputslewrate;
>> -
>> -#define SMS_GPIO_OUTPUTDRIVING_4mA  0
>> -#define SMS_GPIO_OUTPUTDRIVING_8mA  1
>> -#define SMS_GPIO_OUTPUTDRIVING_12mA 2
>> -#define SMS_GPIO_OUTPUTDRIVING_16mA 3
>> -	u8 outputdriving;
>> -};
>>
>>   struct smscore_gpio_config {
>>   #define SMS_GPIO_DIRECTION_INPUT  0
>>   #define SMS_GPIO_DIRECTION_OUTPUT 1
>> -	u8 Direction;
>> +	u8 direction;
>>
>>   #define SMS_GPIO_PULL_UP_DOWN_NONE     0
>>   #define SMS_GPIO_PULL_UP_DOWN_PULLDOWN 1
>>   #define SMS_GPIO_PULL_UP_DOWN_PULLUP   2
>>   #define SMS_GPIO_PULL_UP_DOWN_KEEPER   3
>> -	u8 PullUpDown;
>> +	u8 pull_up_down;
>>
>>   #define SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL  0
>>   #define SMS_GPIO_INPUT_CHARACTERISTICS_SCHMITT 1
>> -	u8 InputCharacteristics;
>> +	u8 input_characteristics;
>>
>>   #define SMS_GPIO_OUTPUT_SLEW_RATE_SLOW		1 /* 10xx */
>>   #define SMS_GPIO_OUTPUT_SLEW_RATE_FAST		0 /* 10xx */
>> @@ -673,22 +659,22 @@ struct smscore_gpio_config {
>>   #define SMS_GPIO_OUTPUT_SLEW_RATE_0_9_V_NS	1 /* 11xx */
>>   #define SMS_GPIO_OUTPUT_SLEW_RATE_1_7_V_NS	2 /* 11xx */
>>   #define SMS_GPIO_OUTPUT_SLEW_RATE_3_3_V_NS	3 /* 11xx */
>> -	u8 OutputSlewRate;
>> -
>> -#define SMS_GPIO_OUTPUT_DRIVING_S_4mA		0 /* 10xx */
>> -#define SMS_GPIO_OUTPUT_DRIVING_S_8mA		1 /* 10xx */
>> -#define SMS_GPIO_OUTPUT_DRIVING_S_12mA		2 /* 10xx */
>> -#define SMS_GPIO_OUTPUT_DRIVING_S_16mA		3 /* 10xx */
>> -
>> -#define SMS_GPIO_OUTPUT_DRIVING_1_5mA		0 /* 11xx */
>> -#define SMS_GPIO_OUTPUT_DRIVING_2_8mA		1 /* 11xx */
>> -#define SMS_GPIO_OUTPUT_DRIVING_4mA		2 /* 11xx */
>> -#define SMS_GPIO_OUTPUT_DRIVING_7mA		3 /* 11xx */
>> -#define SMS_GPIO_OUTPUT_DRIVING_10mA		4 /* 11xx */
>> -#define SMS_GPIO_OUTPUT_DRIVING_11mA		5 /* 11xx */
>> -#define SMS_GPIO_OUTPUT_DRIVING_14mA		6 /* 11xx */
>> -#define SMS_GPIO_OUTPUT_DRIVING_16mA		7 /* 11xx */
>> -	u8 OutputDriving;
>> +	u8 output_slew_rate;
>> +
>> +#define SMS_GPIO_OUTPUTDRIVING_S_4mA		0 /* 10xx */
>> +#define SMS_GPIO_OUTPUTDRIVING_S_8mA		1 /* 10xx */
>> +#define SMS_GPIO_OUTPUTDRIVING_S_12mA		2 /* 10xx */
>> +#define SMS_GPIO_OUTPUTDRIVING_S_16mA		3 /* 10xx */
>> +
>> +#define SMS_GPIO_OUTPUTDRIVING_1_5mA		0 /* 11xx */
>> +#define SMS_GPIO_OUTPUTDRIVING_2_8mA		1 /* 11xx */
>> +#define SMS_GPIO_OUTPUTDRIVING_4mA		2 /* 11xx */
>> +#define SMS_GPIO_OUTPUTDRIVING_7mA		3 /* 11xx */
>> +#define SMS_GPIO_OUTPUTDRIVING_10mA		4 /* 11xx */
>> +#define SMS_GPIO_OUTPUTDRIVING_11mA		5 /* 11xx */
>> +#define SMS_GPIO_OUTPUTDRIVING_14mA		6 /* 11xx */
>> +#define SMS_GPIO_OUTPUTDRIVING_16mA		7 /* 11xx */
>> +	u8 output_driving;
>>   };
>>
>>   extern void smscore_registry_setmode(char *devpath, int mode);
>> @@ -732,10 +718,6 @@ struct smscore_buffer_t *smscore_getbuffer(struct
>> smscore_device_t *coredev);
>>   extern void smscore_putbuffer(struct smscore_device_t *coredev,
>>   			      struct smscore_buffer_t *cb);
>>
>> -/* old GPIO management */
>> -int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
>> -			   struct smscore_config_gpio *pinconfig);
>> -int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int
>> level);
>>
>>   /* new GPIO management */
>>   extern int smscore_gpio_configure(struct smscore_device_t *coredev, u8
>> PinNum,
>> diff --git a/drivers/media/dvb/siano/smsir.h
>> b/drivers/media/dvb/siano/smsir.h
>> index ae92b3a..1a694bc 100644
>> --- a/drivers/media/dvb/siano/smsir.h
>> +++ b/drivers/media/dvb/siano/smsir.h
>> @@ -32,6 +32,11 @@ along with this program.  If not, see
>> <http://www.gnu.org/licenses/>.
>>
>>   #define IR_DEFAULT_TIMEOUT		100
>>
>> +enum ir_kb_type {
>> +	SMS_IR_KB_DEFAULT_TV,
>> +	SMS_IR_KB_HCW_SILVER
>> +};
>> +

This change looks wrong. The entire siano IR code were wrong, not supporting
most of the needed features for a proper RC support.

I've re-designed the IR completely, using the Remote Controller subsystem
sometime ago. As a bonus, now RC5, NEC, RC6, SONY, ... protocols are supported,
and also the LIRC interface. Users can also use the standard tools to replace
the default keytable with others, if they want to use more sophisticated remotes.

The code become simpler and easier to understand.

Now, all that it is needed to enable a remote controller is to point the GPIO
used by id, and the corresponding keymap withadd something like:

	.rc_codes = RC_MAP_HAUPPAUGE,
	.board_cfg.ir = 9,

at the boards table. In the above example, it will use the Remote Controller
keymap table described at rc-hauppauge.c file:

	$ grep RC_MAP_HAUPPAUGE drivers/media/rc/keymaps/*
	drivers/media/rc/keymaps/rc-hauppauge.c:		.name    = RC_MAP_HAUPPAUGE,

I suggest that you should sync the IR part in the reverse direction, using our
upstream code on your internal trees.

>>   struct smscore_device_t;
>>
>>   struct ir_t {
>> diff --git a/drivers/media/dvb/siano/smsusb.c
>> b/drivers/media/dvb/siano/smsusb.c
>> index 0b8da57..b5b09bf 100644
>> --- a/drivers/media/dvb/siano/smsusb.c
>> +++ b/drivers/media/dvb/siano/smsusb.c
>> @@ -483,7 +483,7 @@ static int smsusb_resume(struct usb_interface *intf)
>>
>>   static const struct usb_device_id smsusb_id_table[] __devinitconst = {
>>   	{ USB_DEVICE(0x187f, 0x0010),
>> -		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
>> +		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR_ROM },
>>   	{ USB_DEVICE(0x187f, 0x0100),
>>   		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
>>   	{ USB_DEVICE(0x187f, 0x0200),
>> @@ -526,6 +526,22 @@ static const struct usb_device_id smsusb_id_table[]
>> __devinitconst = {
>>   		.driver_info = SMS1XXX_BOARD_SIANO_NICE },
>>   	{ USB_DEVICE(0x187f, 0x0301),
>>   		.driver_info = SMS1XXX_BOARD_SIANO_VENICE },
>> +	{ USB_DEVICE(0x187f, 0x0302),
>> +		.driver_info = SMS1XXX_BOARD_SIANO_VENICE },
>> +	{ USB_DEVICE(0x187f, 0x0310),
>> +		.driver_info = SMS1XXX_BOARD_SIANO_MING },	
>> +	{ USB_DEVICE(0x187f, 0x0500),
>> +		.driver_info = SMS1XXX_BOARD_SIANO_PELE },
>>
>> +	{ USB_DEVICE(0x187f, 0x0600),
>> +		.driver_info = SMS1XXX_BOARD_SIANO_RIO },
>> +	{ USB_DEVICE(0x187f, 0x0700),
>> +		.driver_info = SMS1XXX_BOARD_SIANO_DENVER_2160 },	
>> +	{ USB_DEVICE(0x187f, 0x0800),
>> +		.driver_info = SMS1XXX_BOARD_SIANO_DENVER_1530 },
>> +	{ USB_DEVICE(0x19D2, 0x0086),
>> +		.driver_info = SMS1XXX_BOARD_ZTE_DVB_DATA_CARD },
>> +	{ USB_DEVICE(0x19D2, 0x0078),
>> +		.driver_info = SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD },
>>   	{ USB_DEVICE(0x2040, 0xb900),
>>   		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
>>   	{ USB_DEVICE(0x2040, 0xb910),
>>
>>
>>
>> Thanks,
>> Doron
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>

