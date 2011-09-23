Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1IWWYS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 18:24:18 -0400
Message-ID: <4E7D070D.2030301@redhat.com>
Date: Fri, 23 Sep 2011 19:24:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 6/17]DVB:Siano drivers -  Add support in various boards
 implemented with siano devices.
References: <1316514673.5199.84.camel@Doron-Ubuntu>
In-Reply-To: <1316514673.5199.84.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-09-2011 07:31, Doron Cohen escreveu:
> Hi,
> This patch adds support in various boards implemented with Siano
> devices.

This one looks ok, except that it was mangled by your emailer.

> 
> Thanks,
> Doron Cohen
> 
> 
> 
> ------------------------------
>>From becf520ccaba483a80e242622b471d10bd74024e Mon Sep 17 00:00:00 2001
> From: Doron Cohen <doronc@siano-ms.com>
> Date: Mon, 19 Sep 2011 13:57:40 +0300
> Subject: [PATCH 09/21] Add support in various boards with SMS devices
> 
> ---
>  drivers/media/dvb/siano/sms-cards.c |  224
> ++++++++++++++++++++++++++++++-----
>  1 files changed, 195 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/sms-cards.c
> b/drivers/media/dvb/siano/sms-cards.c
> index 00c6c5f..66b302e 100644
> --- a/drivers/media/dvb/siano/sms-cards.c
> +++ b/drivers/media/dvb/siano/sms-cards.c
> @@ -18,53 +18,66 @@
>   */
>  
>  #include "sms-cards.h"
> +#ifdef SMS_RC_SUPPORT_SUBSYS
>  #include "smsir.h"
> -
> -static int sms_dbg;
> -module_param_named(cards_dbg, sms_dbg, int, 0644);
> -MODULE_PARM_DESC(cards_dbg, "set debug level (info=1, adv=2
> (or-able))");
> -
> +#endif
>  static struct sms_board sms_boards[] = {
>  	[SMS_BOARD_UNKNOWN] = {
> -		.name	= "Unknown board",
> +	/* 0 */
> +		.name = "Unknown board",
> +		.type = SMS_UNKNOWN_TYPE,
> +		.default_mode = SMSHOSTLIB_DEVMD_NONE,
>  	},
>  	[SMS1XXX_BOARD_SIANO_STELLAR] = {
> -		.name	= "Siano Stellar Digital Receiver",
> -		.type	= SMS_STELLAR,
> +	/* 1 */
> +		.name =	"Siano Stellar Digital Receiver",
> +		.type = SMS_STELLAR,
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
>  	},
>  	[SMS1XXX_BOARD_SIANO_NOVA_A] = {
> -		.name	= "Siano Nova A Digital Receiver",
> -		.type	= SMS_NOVA_A0,
> +	/* 2 */
> +		.name = "Siano Nova A Digital Receiver",
> +		.type = SMS_NOVA_A0,
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
>  	},
>  	[SMS1XXX_BOARD_SIANO_NOVA_B] = {
> -		.name	= "Siano Nova B Digital Receiver",
> -		.type	= SMS_NOVA_B0,
> +	/* 3 */
> +		.name = "Siano Nova B Digital Receiver",
> +		.type = SMS_NOVA_B0,
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
>  	},
>  	[SMS1XXX_BOARD_SIANO_VEGA] = {
> -		.name	= "Siano Vega Digital Receiver",
> -		.type	= SMS_VEGA,
> +	/* 4 */
> +		.name = "Siano Vega Digital Receiver",
> +		.type = SMS_VEGA,
> +		.default_mode = SMSHOSTLIB_DEVMD_CMMB,
>  	},
>  	[SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT] = {
> -		.name	= "Hauppauge Catamount",
> -		.type	= SMS_STELLAR,
> +	/* 5 */
> +		.name = "Hauppauge Catamount",
> +		.type = SMS_STELLAR,
>  		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-stellar-dvbt-01.fw",
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
>  	},
>  	[SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A] = {
> -		.name	= "Hauppauge Okemo-A",
> -		.type	= SMS_NOVA_A0,
> +	/* 6 */
> +		.name = "Hauppauge Okemo-A",
> +		.type = SMS_NOVA_A0,
>  		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-nova-a-dvbt-01.fw",
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
>  	},
>  	[SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B] = {
> -		.name	= "Hauppauge Okemo-B",
> -		.type	= SMS_NOVA_B0,
> +	/* 7 */
> +		.name = "Hauppauge Okemo-B",
> +		.type = SMS_NOVA_B0,
>  		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-nova-b-dvbt-01.fw",
>  	},
>  	[SMS1XXX_BOARD_HAUPPAUGE_WINDHAM] = {
> -		.name	= "Hauppauge WinTV MiniStick",
> -		.type	= SMS_NOVA_B0,
> -		.fw[SMSHOSTLIB_DEVMD_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
> +	/* 8 */
> +		.name = "Hauppauge WinTV MiniStick",
> +		.type = SMS_NOVA_B0,
>  		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
> -		.rc_codes = RC_MAP_HAUPPAUGE,
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
>  		.board_cfg.leds_power = 26,
>  		.board_cfg.led0 = 27,
>  		.board_cfg.led1 = 28,
> @@ -74,29 +87,91 @@ static struct sms_board sms_boards[] = {
>  		.led_hi    = 28,
>  	},
>  	[SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD] = {
> +	/* 9 */
>  		.name	= "Hauppauge WinTV MiniCard",
>  		.type	= SMS_NOVA_B0,
>  		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
>  		.lna_ctrl  = 29,
>  		.board_cfg.foreign_lna0_ctrl = 29,
>  		.rf_switch = 17,
>  		.board_cfg.rf_switch_uhf = 17,
>  	},
>  	[SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2] = {
> -		.name	= "Hauppauge WinTV MiniCard",
> -		.type	= SMS_NOVA_B0,
> +	/* 10 */
> +		.name = "Hauppauge WinTV MiniCard",
> +		.type = SMS_NOVA_B0,
>  		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
> +		.board_cfg.foreign_lna0_ctrl = 1,
>  		.lna_ctrl  = -1,
>  	},
>  	[SMS1XXX_BOARD_SIANO_NICE] = {
>  	/* 11 */
>  		.name = "Siano Nice Digital Receiver",
>  		.type = SMS_NOVA_B0,
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
>  	},
>  	[SMS1XXX_BOARD_SIANO_VENICE] = {
>  	/* 12 */
>  		.name = "Siano Venice Digital Receiver",
> -		.type = SMS_VEGA,
> +		.type = SMS_VENICE,
> +		.default_mode = SMSHOSTLIB_DEVMD_CMMB,
> +	},
> +	[SMS1XXX_BOARD_SIANO_STELLAR_ROM] = {
> +	/* 13 */
> +		.name =
> +		"Siano Stellar Digital Receiver ROM",
> +		.type = SMS_STELLAR,
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
> +		.intf_num = 1,
> +	},
> +	[SMS1XXX_BOARD_ZTE_DVB_DATA_CARD] = {
> +	/* 14 */
> +		.name = "ZTE Data Card Digital Receiver",
> +		.type = SMS_NOVA_B0,
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
> +		.intf_num = 5,
> +		.mtu = 15792,
> +	},
> +	[SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD] = {
> +	/* 15 */
> +		.name = "ONDA Data Card Digital Receiver",
> +		.type = SMS_NOVA_B0,
> +		.default_mode = SMSHOSTLIB_DEVMD_DVBT_BDA,
> +		.intf_num = 6,
> +		.mtu = 15792,
> +	},
> +	[SMS1XXX_BOARD_SIANO_MING] = {
> +	/* 16 */
> +		.name = "Siano Ming Digital Receiver",
> +		.type = SMS_MING,
> +		.default_mode = SMSHOSTLIB_DEVMD_CMMB,
> +	},
> +	[SMS1XXX_BOARD_SIANO_PELE] = {
> +	/* 17 */
> +		.name = "Siano Pele Digital Receiver",
> +		.type = SMS_PELE,
> +		.default_mode = SMSHOSTLIB_DEVMD_ISDBT_BDA,
> +	},
> +	[SMS1XXX_BOARD_SIANO_RIO] = {
> +	/* 18 */
> +		.name = "Siano Rio Digital Receiver",
> +		.type = SMS_RIO,
> +		.default_mode = SMSHOSTLIB_DEVMD_ISDBT_BDA,
> +	},
> +	[SMS1XXX_BOARD_SIANO_DENVER_1530] = {
> +    /* 19 */
> +        .name = "Siano Denver (ATSC-M/H) Digital Receiver",
> +        .type = SMS_DENVER_1530,
> +        .default_mode = SMSHOSTLIB_DEVMD_ATSC,
> +	.crystal = 2400,
> +    },
> +    [SMS1XXX_BOARD_SIANO_DENVER_2160] = {
> +    /* 20 */
> +        .name = "Siano Denver (TDMB) Digital Receiver",
> +        .type = SMS_DENVER_2160,
> +        .default_mode = SMSHOSTLIB_DEVMD_DAB_TDMB,
>  	},
>  };
>  
> @@ -110,8 +185,7 @@ EXPORT_SYMBOL_GPL(sms_get_board);
>  static inline void sms_gpio_assign_11xx_default_led_config(
>  		struct smscore_gpio_config *pGpioConfig) {
>  	pGpioConfig->direction = SMS_GPIO_DIRECTION_OUTPUT;
> -	pGpioConfig->input_characteristics =
> -		SMS_GPIO_INPUTCHARACTERISTICS_NORMAL;
> +	pGpioConfig->input_characteristics =
> SMS_GPIO_INPUTCHARACTERISTICS_NORMAL;
>  	pGpioConfig->output_driving = SMS_GPIO_OUTPUTDRIVING_4mA;
>  	pGpioConfig->output_slew_rate = SMS_GPIO_OUTPUTSLEWRATE_0_45_V_NS;
>  	pGpioConfig->pull_up_down = SMS_GPIO_PULLUPDOWN_NONE;
> @@ -119,21 +193,99 @@ static inline void
> sms_gpio_assign_11xx_default_led_config(
>  
>  int sms_board_event(struct smscore_device_t *coredev,
>  		enum SMS_BOARD_EVENTS gevent) {
> +	int board_id = smscore_get_board_id(coredev);
> +	struct sms_board *board = sms_get_board(board_id);
>  	struct smscore_gpio_config MyGpioConfig;
>  
>  	sms_gpio_assign_11xx_default_led_config(&MyGpioConfig);
>  
>  	switch (gevent) {
>  	case BOARD_EVENT_POWER_INIT: /* including hotplug */
> +		switch (board_id) {
> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> +			/* set I/O and turn off all LEDs */
> +			smscore_gpio_configure(coredev,
> +					board->board_cfg.leds_power,
> +					&MyGpioConfig);
> +			smscore_gpio_set_level(coredev,
> +					board->board_cfg.leds_power, 0);
> +			smscore_gpio_configure(coredev, board->board_cfg.led0,
> +					&MyGpioConfig);
> +			smscore_gpio_set_level(coredev,
> +					board->board_cfg.led0, 0);
> +			smscore_gpio_configure(coredev, board->board_cfg.led1,
> +					&MyGpioConfig);
> +			smscore_gpio_set_level(coredev,
> +					board->board_cfg.led1, 0);
> +			break;
> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> +			/* set I/O and turn off LNA */
> +			smscore_gpio_configure(coredev,
> +					board->board_cfg.foreign_lna0_ctrl,
> +					&MyGpioConfig);
> +			smscore_gpio_set_level(coredev,
> +					board->board_cfg.foreign_lna0_ctrl,
> +					0);
> +			break;
> +		}
>  		break; /* BOARD_EVENT_BIND */
>  
>  	case BOARD_EVENT_POWER_SUSPEND:
> +		switch (board_id) {
> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> +			smscore_gpio_set_level(coredev,
> +						board->board_cfg.leds_power, 0);
> +			smscore_gpio_set_level(coredev,
> +						board->board_cfg.led0, 0);
> +			smscore_gpio_set_level(coredev,
> +						board->board_cfg.led1, 0);
> +			break;
> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> +			smscore_gpio_set_level(coredev,
> +					board->board_cfg.foreign_lna0_ctrl,
> +					0);
> +			break;
> +		}
>  		break; /* BOARD_EVENT_POWER_SUSPEND */
>  
>  	case BOARD_EVENT_POWER_RESUME:
> +		switch (board_id) {
> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> +			smscore_gpio_set_level(coredev,
> +						board->board_cfg.leds_power, 1);
> +			smscore_gpio_set_level(coredev,
> +						board->board_cfg.led0, 1);
> +			smscore_gpio_set_level(coredev,
> +						board->board_cfg.led1, 0);
> +			break;
> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> +			smscore_gpio_set_level(coredev,
> +					board->board_cfg.foreign_lna0_ctrl,
> +					1);
> +			break;
> +		}
>  		break; /* BOARD_EVENT_POWER_RESUME */
>  
>  	case BOARD_EVENT_BIND:
> +		switch (board_id) {
> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> +			smscore_gpio_set_level(coredev,
> +				board->board_cfg.leds_power, 1);
> +			smscore_gpio_set_level(coredev,
> +				board->board_cfg.led0, 1);
> +			smscore_gpio_set_level(coredev,
> +				board->board_cfg.led1, 0);
> +			break;
> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> +			smscore_gpio_set_level(coredev,
> +					board->board_cfg.foreign_lna0_ctrl,
> +					1);
> +			break;
> +		}
>  		break; /* BOARD_EVENT_BIND */
>  
>  	case BOARD_EVENT_SCAN_PROG:
> @@ -143,8 +295,20 @@ int sms_board_event(struct smscore_device_t
> *coredev,
>  	case BOARD_EVENT_EMERGENCY_WARNING_SIGNAL:
>  		break; /* BOARD_EVENT_EMERGENCY_WARNING_SIGNAL */
>  	case BOARD_EVENT_FE_LOCK:
> +		switch (board_id) {
> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> +			smscore_gpio_set_level(coredev,
> +			board->board_cfg.led1, 1);
> +			break;
> +		}
>  		break; /* BOARD_EVENT_FE_LOCK */
>  	case BOARD_EVENT_FE_UNLOCK:
> +		switch (board_id) {
> +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> +			smscore_gpio_set_level(coredev,
> +						board->board_cfg.led1, 0);
> +			break;
> +		}
>  		break; /* BOARD_EVENT_FE_UNLOCK */
>  	case BOARD_EVENT_DEMOD_LOCK:
>  		break; /* BOARD_EVENT_DEMOD_LOCK */
> @@ -211,6 +375,7 @@ int sms_board_setup(struct smscore_device_t
> *coredev)
>  
>  	switch (board_id) {
>  	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> +		smscore_gpio_set_level(coredev, board->board_cfg.led1, 1);
>  		/* turn off all LEDs */
>  		sms_set_gpio(coredev, board->led_power, 0);
>  		sms_set_gpio(coredev, board->led_hi, 0);
> @@ -233,6 +398,7 @@ int sms_board_power(struct smscore_device_t
> *coredev, int onoff)
>  
>  	switch (board_id) {
>  	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> +		smscore_gpio_set_level(coredev,	board->board_cfg.led1, 0);
>  		/* power LED */
>  		sms_set_gpio(coredev,
>  			     board->led_power, onoff ? 1 : 0);

