Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1IWWXO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 18:23:14 -0400
Message-ID: <4E7D06C4.3010704@redhat.com>
Date: Fri, 23 Sep 2011 19:23:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org, Michael Krufky <mkrufky@hauppauge.com>
Subject: Re: [PATCH  5/17]DVB:Siano drivers -  Chnage smscoreapi.h definitions
 to match Siano FW structures.
References: <1316514669.5199.83.camel@Doron-Ubuntu>
In-Reply-To: <1316514669.5199.83.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-09-2011 07:31, Doron Cohen escreveu:
> Hi,
> This patch chnages smscoreapi.h definitions to match Siano FW
> structures. Updating the usage of all these tructures in all files.
> 
> Thanks,
> Doron Cohen

Doron,

I suggest you to take a look at the past history of Siano's submission at the
mailing list. I'm seeing several things on this series that were already
discussed at the time Uri submitted us his sync patches.

See bellow.

> 
> --------------
> 
>>From b28eee750a30ebc943951722081de343f380332e Mon Sep 17 00:00:00 2001
> From: Doron Cohen <doronc@siano-ms.com>
> Date: Mon, 19 Sep 2011 13:41:28 +0300
> Subject: [PATCH 08/21] Chnage smscoreapi.h definitions to match Siano FW
> structures. Updating the usage of all these tructures in all files.
> 
> ---
>  drivers/media/dvb/siano/Kconfig      |   18 +-
>  drivers/media/dvb/siano/sms-cards.c  |   40 +-
>  drivers/media/dvb/siano/sms-cards.h  |    7 +-
>  drivers/media/dvb/siano/smscoreapi.c |  201 ++---
>  drivers/media/dvb/siano/smscoreapi.h | 2147
> +++++++++++++++++++++++++---------

Patch is likely mangled.

>  drivers/media/dvb/siano/smsdvb.c     |  342 +++---
>  drivers/media/dvb/siano/smssdio.c    |    4 +-
>  drivers/media/dvb/siano/smsspidrv.c  |   13 +-
>  drivers/media/dvb/siano/smsspiphy.c  |    3 +-
>  drivers/media/dvb/siano/smsusb.c     |   18 +-
>  10 files changed, 1865 insertions(+), 928 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/Kconfig
> b/drivers/media/dvb/siano/Kconfig
> index bb91911..3596321 100644
> --- a/drivers/media/dvb/siano/Kconfig
> +++ b/drivers/media/dvb/siano/Kconfig
> @@ -3,7 +3,7 @@
>  #
>  
>  config SMS_SIANO_MDTV
> -	tristate "Siano SMS1xxx based MDTV receiver"
> +	tristate "Siano SMSxxxx based MDTV receiver"
>  	depends on DVB_CORE && HAS_DMA
>  	---help---
>  	  Choose Y or M here if you have MDTV receiver with a Siano chipset.
> @@ -26,26 +26,14 @@ config SMS_RC_SUPPORT_SUBSYS
>  	---help---
>  	Choose if you would like to have Siano's ir remote control sub-system
> support.
>  
> -config SMS_HOSTLIB_SUBSYS
> -	bool "Host Library Subsystem support"
> -	default n
> -	---help---
> -	Choose if you would like to have Siano's host library kernel
> sub-system support.
>  
> -if SMS_HOSTLIB_SUBSYS
> -config SMS_NET_SUBSYS
> -	tristate "Siano Network Adapter"
> -	depends on NET
> -	default n
> -	---help---
> -	Choose if you would like to have Siano's network adapter support.
> -endif # SMS_HOSTLIB_SUBSYS

Why are you changing those symbols again? What does the above have to
do with the "siano FW structures"?

>  
>  # Hardware interfaces support
>  
>  config SMS_USB_DRV
>  	tristate "USB interface support"
>  	depends on DVB_CORE && USB
> +	default y if USB
>  	---help---
>  	  Choose if you would like to have Siano's support for USB interface
>  
> @@ -57,7 +45,7 @@ config SMS_SDIO_DRV
>  
>  config SMS_SPI_DRV
>  	tristate "SPI interface support"
> -	depends on SPI
> +	depends on DVB_CORE && SPI
>  	default y if SPI
>  	---help---
>  	Choose if you would like to have Siano's support for PXA 310 SPI
> interface
> diff --git a/drivers/media/dvb/siano/sms-cards.c
> b/drivers/media/dvb/siano/sms-cards.c
> index af121db..00c6c5f 100644
> --- a/drivers/media/dvb/siano/sms-cards.c
> +++ b/drivers/media/dvb/siano/sms-cards.c
> @@ -47,23 +47,23 @@ static struct sms_board sms_boards[] = {
>  	[SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT] = {
>  		.name	= "Hauppauge Catamount",
>  		.type	= SMS_STELLAR,
> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-stellar-dvbt-01.fw",
> +		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-stellar-dvbt-01.fw",
>  	},
>  	[SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A] = {
>  		.name	= "Hauppauge Okemo-A",
>  		.type	= SMS_NOVA_A0,
> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-a-dvbt-01.fw",
> +		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-nova-a-dvbt-01.fw",
>  	},
>  	[SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B] = {
>  		.name	= "Hauppauge Okemo-B",
>  		.type	= SMS_NOVA_B0,
> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-b-dvbt-01.fw",
> +		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-nova-b-dvbt-01.fw",
>  	},
>  	[SMS1XXX_BOARD_HAUPPAUGE_WINDHAM] = {
>  		.name	= "Hauppauge WinTV MiniStick",
>  		.type	= SMS_NOVA_B0,
> -		.fw[DEVICE_MODE_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
> +		.fw[SMSHOSTLIB_DEVMD_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
> +		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
>  		.rc_codes = RC_MAP_HAUPPAUGE,
>  		.board_cfg.leds_power = 26,
>  		.board_cfg.led0 = 27,
> @@ -76,7 +76,7 @@ static struct sms_board sms_boards[] = {
>  	[SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD] = {
>  		.name	= "Hauppauge WinTV MiniCard",
>  		.type	= SMS_NOVA_B0,
> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
> +		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
>  		.lna_ctrl  = 29,
>  		.board_cfg.foreign_lna0_ctrl = 29,
>  		.rf_switch = 17,
> @@ -85,7 +85,7 @@ static struct sms_board sms_boards[] = {
>  	[SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2] = {
>  		.name	= "Hauppauge WinTV MiniCard",
>  		.type	= SMS_NOVA_B0,
> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
> +		.fw[SMSHOSTLIB_DEVMD_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
>  		.lna_ctrl  = -1,
>  	},
>  	[SMS1XXX_BOARD_SIANO_NICE] = {
> @@ -109,12 +109,12 @@ struct sms_board *sms_get_board(unsigned id)
>  EXPORT_SYMBOL_GPL(sms_get_board);
>  static inline void sms_gpio_assign_11xx_default_led_config(
>  		struct smscore_gpio_config *pGpioConfig) {
> -	pGpioConfig->Direction = SMS_GPIO_DIRECTION_OUTPUT;
> -	pGpioConfig->InputCharacteristics =
> -		SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL;
> -	pGpioConfig->OutputDriving = SMS_GPIO_OUTPUT_DRIVING_4mA;
> -	pGpioConfig->OutputSlewRate = SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS;
> -	pGpioConfig->PullUpDown = SMS_GPIO_PULL_UP_DOWN_NONE;
> +	pGpioConfig->direction = SMS_GPIO_DIRECTION_OUTPUT;
> +	pGpioConfig->input_characteristics =
> +		SMS_GPIO_INPUTCHARACTERISTICS_NORMAL;
> +	pGpioConfig->output_driving = SMS_GPIO_OUTPUTDRIVING_4mA;
> +	pGpioConfig->output_slew_rate = SMS_GPIO_OUTPUTSLEWRATE_0_45_V_NS;
> +	pGpioConfig->pull_up_down = SMS_GPIO_PULLUPDOWN_NONE;
>  }
>  
>  int sms_board_event(struct smscore_device_t *coredev,
> @@ -177,12 +177,12 @@ static int sms_set_gpio(struct smscore_device_t
> *coredev, int pin, int enable)
>  {
>  	int lvl, ret;
>  	u32 gpio;
> -	struct smscore_config_gpio gpioconfig = {
> +	struct smscore_gpio_config gpioconfig = {
>  		.direction            = SMS_GPIO_DIRECTION_OUTPUT,
> -		.pullupdown           = SMS_GPIO_PULLUPDOWN_NONE,
> -		.inputcharacteristics = SMS_GPIO_INPUTCHARACTERISTICS_NORMAL,
> -		.outputslewrate       = SMS_GPIO_OUTPUTSLEWRATE_FAST,
> -		.outputdriving        = SMS_GPIO_OUTPUTDRIVING_4mA,
> +		.pull_up_down           = SMS_GPIO_PULLUPDOWN_NONE,
> +		.input_characteristics = SMS_GPIO_INPUTCHARACTERISTICS_NORMAL,
> +		.output_slew_rate       = SMS_GPIO_OUTPUTSLEWRATE_FAST,
> +		.output_driving        = SMS_GPIO_OUTPUTDRIVING_4mA,
>  	};
>  
>  	if (pin == 0)
> @@ -197,11 +197,11 @@ static int sms_set_gpio(struct smscore_device_t
> *coredev, int pin, int enable)
>  		lvl = enable ? 1 : 0;
>  	}
>  
> -	ret = smscore_configure_gpio(coredev, gpio, &gpioconfig);
> +	ret = smscore_gpio_configure(coredev, gpio, &gpioconfig);
>  	if (ret < 0)
>  		return ret;
>  
> -	return smscore_set_gpio(coredev, gpio, lvl);
> +	return smscore_gpio_set_level(coredev, gpio, lvl);
>  }
>  
>  int sms_board_setup(struct smscore_device_t *coredev)
> diff --git a/drivers/media/dvb/siano/sms-cards.h
> b/drivers/media/dvb/siano/sms-cards.h
> index 1c2159b..7b13d15 100644
> --- a/drivers/media/dvb/siano/sms-cards.h
> +++ b/drivers/media/dvb/siano/sms-cards.h
> @@ -83,12 +83,17 @@ struct sms_board_gpio_cfg {
>  
>  struct sms_board {
>  	enum sms_device_type_st type;
> -	char *name, *fw[DEVICE_MODE_MAX];
> +	char *name, *fw[SMSHOSTLIB_DEVMD_MAX];
>  	struct sms_board_gpio_cfg board_cfg;
>  	char *rc_codes;				/* Name of IR codes table */
>  
>  	/* gpios */
>  	int led_power, led_hi, led_lo, lna_ctrl, rf_switch;
> +	char intf_num;
> +	int default_mode;
> +	unsigned int mtu;
> +	unsigned int crystal;
> +	struct sms_antenna_config_ST* antenna_config;
>  };
>  
>  struct sms_board *sms_get_board(unsigned id);
> diff --git a/drivers/media/dvb/siano/smscoreapi.c
> b/drivers/media/dvb/siano/smscoreapi.c
> index 7c74544..9738bad 100644
> --- a/drivers/media/dvb/siano/smscoreapi.c
> +++ b/drivers/media/dvb/siano/smscoreapi.c
> @@ -36,11 +36,14 @@
>  
>  #include "smscoreapi.h"
>  #include "sms-cards.h"
> +#ifdef SMS_RC_SUPPORT_SUBSYS
>  #include "smsir.h"
> +#endif
>  #include "smsendian.h"


Again?

>  
> -int sms_dbg;
> -module_param_named(debug, sms_dbg, int, 0644);
> +#define MAX_GPIO_PIN_NUMBER	31
> +
> +int sms_debug;
>  MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
>  
>  struct smscore_device_notifyee_t {
> @@ -151,7 +154,7 @@ static enum sms_device_type_st
> smscore_registry_gettype(char *devpath)
>  	else
>  		sms_err("No registry found.");
>  
> -	return -1;
> +	return SMS_UNKNOWN_TYPE;

 Return codes should use the standard linux errors. -ENODEV?

>  }
>  
>  void smscore_registry_setmode(char *devpath, int mode)
> @@ -386,7 +389,9 @@ int smscore_register_device(struct
> smsdevice_params_t *params,
>  
>  	sms_info("allocated %d buffers", dev->num_buffers);
>  
> -	dev->mode = DEVICE_MODE_NONE;
> +	dev->mode = SMSHOSTLIB_DEVMD_NONE;
> +	dev->board_id = SMS_BOARD_UNKNOWN;
> +
>  	dev->context = params->context;
>  	dev->device = params->device;
>  	dev->setmode_handler = params->setmode_handler;
> @@ -398,6 +403,9 @@ int smscore_register_device(struct
> smsdevice_params_t *params,
>  	dev->device_flags = params->flags;
>  	strcpy(dev->devpath, params->devpath);
>  
> +	/* clear fw start address */
> +	dev->start_address = 0; 
> +
>  	smscore_registry_settype(dev->devpath, params->device_type);
>  
>  	/* add device to devices list */
> @@ -446,22 +454,22 @@ static int smscore_init_ir(struct smscore_device_t
> *coredev)
>  			sms_err("Error initialization DTV IR sub-module");
>  		else 
>  		{
> -			buffer = kmalloc(sizeof(struct SmsMsgData_ST2) +
> +			buffer = kmalloc(sizeof(struct SmsMsgData2Args_S) +
>  						SMS_DMA_ALIGNMENT,
>  						GFP_KERNEL | GFP_DMA);
>  			if (buffer) {
> -				struct SmsMsgData_ST2 *msg =
> -				(struct SmsMsgData_ST2 *)
> +				struct SmsMsgData2Args_S *msg =
> +				(struct SmsMsgData2Args_S *)
>  				SMS_ALIGN_ADDRESS(buffer);
>  
>  				SMS_INIT_MSG(&msg->xMsgHeader,
>  						MSG_SMS_START_IR_REQ,
> -						sizeof(struct SmsMsgData_ST2));
> +						sizeof(struct SmsMsgData2Args_S));
>  				msg->msgData[0] = coredev->ir.controller;
>  				msg->msgData[1] = coredev->ir.timeout;
>  
>  				smsendian_handle_tx_message(
> -					(struct SmsMsgHdr_ST2 *)msg);
> +					(struct SmsMsgHdr_S2 *)msg);

Why do you need a typecast here? msg has already (struct SmsMsgHdr_S2 * type.

>  				rc = smscore_sendrequest_and_wait(coredev, msg,
>  						msg->xMsgHeader. msgLength,
>  						&coredev->ir_init_done);
> @@ -515,7 +523,7 @@ static int smscore_load_firmware_family2(struct
> smscore_device_t *coredev,
>  					 void *buffer, size_t size)
>  {
>  	struct SmsFirmware_ST *firmware = (struct SmsFirmware_ST *) buffer;
> -	struct SmsMsgHdr_ST *msg;
> +	struct SmsMsgHdr_S *msg;
>  	u32 mem_address;
>  	u8 *payload = firmware->Payload;
>  	int rc = 0;
> @@ -537,10 +545,10 @@ static int smscore_load_firmware_family2(struct
> smscore_device_t *coredev,
>  	if (!msg)
>  		return -ENOMEM;
>  
> -	if (coredev->mode != DEVICE_MODE_NONE) {
> +	if (coredev->mode != SMSHOSTLIB_DEVMD_NONE) {
>  		sms_debug("sending reload command.");
>  		SMS_INIT_MSG(msg, MSG_SW_RELOAD_START_REQ,
> -			     sizeof(struct SmsMsgHdr_ST));
> +			     sizeof(struct SmsMsgHdr_S));
>  		rc = smscore_sendrequest_and_wait(coredev, msg,
>  						  msg->msgLength,
>  						  &coredev->reload_start_done);
> @@ -548,19 +556,19 @@ static int smscore_load_firmware_family2(struct
> smscore_device_t *coredev,
>  	}
>  
>  	while (size && rc >= 0) {
> -		struct SmsDataDownload_ST *DataMsg =
> -			(struct SmsDataDownload_ST *) msg;
> +		struct SmsDataDownload_S *DataMsg =
> +			(struct SmsDataDownload_S *) msg;

Again, typecast is not needed here. Please, only use typecast when absolutelly
needed, as it can hide some troubles.

>  		int payload_size = min((int) size, SMS_MAX_PAYLOAD_SIZE);
>  
>  		SMS_INIT_MSG(msg, MSG_SMS_DATA_DOWNLOAD_REQ,
> -			     (u16)(sizeof(struct SmsMsgHdr_ST) +
> +			     (u16)(sizeof(struct SmsMsgHdr_S) +
>  				      sizeof(u32) + payload_size));
>  
>  		DataMsg->MemAddr = mem_address;
>  		memcpy(DataMsg->Payload, payload, payload_size);
>  
>  		if ((coredev->device_flags & SMS_ROM_NO_RESPONSE) &&
> -		    (coredev->mode == DEVICE_MODE_NONE))
> +		    (coredev->mode == SMSHOSTLIB_DEVMD_NONE))
>  			rc = coredev->sendrequest_handler(
>  				coredev->context, DataMsg,
>  				DataMsg->xMsgHeader.msgLength);
> @@ -576,12 +584,12 @@ static int smscore_load_firmware_family2(struct
> smscore_device_t *coredev,
>  	}
>  
>  	if (rc >= 0) {
> -		if (coredev->mode == DEVICE_MODE_NONE) {
> -			struct SmsMsgData_ST *TriggerMsg =
> -				(struct SmsMsgData_ST *) msg;
> +		if (coredev->mode == SMSHOSTLIB_DEVMD_NONE) {
> +			struct SmsMsgData_S *TriggerMsg =
> +				(struct SmsMsgData_S *) msg;

Again, just remove the typecast. (I won't repeat myself again... use it as
a general rule for all patches submitted upstream).
>  
>  			SMS_INIT_MSG(msg, MSG_SMS_SWDOWNLOAD_TRIGGER_REQ,
> -				     sizeof(struct SmsMsgHdr_ST) +
> +				     sizeof(struct SmsMsgHdr_S) +
>  				     sizeof(u32) * 5);
>  
>  			TriggerMsg->msgData[0] = firmware->StartAddress;
> @@ -603,7 +611,7 @@ static int smscore_load_firmware_family2(struct
> smscore_device_t *coredev,
>  					&coredev->trigger_done);
>  		} else {
>  			SMS_INIT_MSG(msg, MSG_SW_RELOAD_EXEC_REQ,
> -				     sizeof(struct SmsMsgHdr_ST));
> +				     sizeof(struct SmsMsgHdr_S));
>  
>  			rc = coredev->sendrequest_handler(coredev->context,
>  							  msg, msg->msgLength);
> @@ -739,17 +747,17 @@ EXPORT_SYMBOL_GPL(smscore_unregister_device);
>  
>  static int smscore_detect_mode(struct smscore_device_t *coredev)
>  {
> -	void *buffer = kmalloc(sizeof(struct SmsMsgHdr_ST) +
> SMS_DMA_ALIGNMENT,
> +	void *buffer = kmalloc(sizeof(struct SmsMsgHdr_S) + SMS_DMA_ALIGNMENT,
>  			       GFP_KERNEL | GFP_DMA);
> -	struct SmsMsgHdr_ST *msg =
> -		(struct SmsMsgHdr_ST *) SMS_ALIGN_ADDRESS(buffer);
> +	struct SmsMsgHdr_S *msg =
> +		(struct SmsMsgHdr_S *) SMS_ALIGN_ADDRESS(buffer);
>  	int rc;
>  
>  	if (!buffer)
>  		return -ENOMEM;
>  
>  	SMS_INIT_MSG(msg, MSG_SMS_GET_VERSION_EX_REQ,
> -		     sizeof(struct SmsMsgHdr_ST));
> +		     sizeof(struct SmsMsgHdr_S));
>  
>  	rc = smscore_sendrequest_and_wait(coredev, msg, msg->msgLength,
>  					  &coredev->version_ex_done);
> @@ -818,7 +826,7 @@ int smscore_set_device_mode(struct smscore_device_t
> *coredev, int mode)
>  
>  	sms_debug("set device mode to %d", mode);
>  	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
> -		if (mode < DEVICE_MODE_DVBT || mode >= DEVICE_MODE_RAW_TUNER) {
> +		if (mode < SMSHOSTLIB_DEVMD_DVBT || mode >=
> SMSHOSTLIB_DEVMD_RAW_TUNER) {
>  			sms_err("invalid mode specified %d", mode);
>  			return -EINVAL;
>  		}
> @@ -868,15 +876,15 @@ int smscore_set_device_mode(struct
> smscore_device_t *coredev, int mode)
>  			sms_info("mode %d supported by running "
>  				 "firmware", mode);
>  
> -		buffer = kmalloc(sizeof(struct SmsMsgData_ST) +
> +		buffer = kmalloc(sizeof(struct SmsMsgData_S) +
>  				 SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
>  		if (buffer) {
> -			struct SmsMsgData_ST *msg =
> -				(struct SmsMsgData_ST *)
> +			struct SmsMsgData_S *msg =
> +				(struct SmsMsgData_S *)
>  					SMS_ALIGN_ADDRESS(buffer);
>  
>  			SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_INIT_DEVICE_REQ,
> -				     sizeof(struct SmsMsgData_ST));
> +				     sizeof(struct SmsMsgData_S));
>  			msg->msgData[0] = mode;
>  
>  			rc = smscore_sendrequest_and_wait(
> @@ -890,7 +898,7 @@ int smscore_set_device_mode(struct smscore_device_t
> *coredev, int mode)
>  			rc = -ENOMEM;
>  		}
>  	} else {
> -		if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_DVBT_BDA) {
> +		if (mode < SMSHOSTLIB_DEVMD_DVBT || mode > SMSHOSTLIB_DEVMD_DVBT_BDA)
> {
>  			sms_err("invalid mode specified %d", mode);
>  			return -EINVAL;
>  		}
> @@ -981,7 +989,7 @@ smscore_client_t *smscore_find_client(struct
> smscore_device_t *coredev,
>   */
>  void smscore_onresponse(struct smscore_device_t *coredev,
>  		struct smscore_buffer_t *cb) {
> -	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) ((u8 *) cb->p
> +	struct SmsMsgHdr_S *phdr = (struct SmsMsgHdr_S *) ((u8 *) cb->p
>  			+ cb->offset);
>  	struct smscore_client_t *client;
>  	int rc = -EBUSY;
> @@ -1005,7 +1013,7 @@ void smscore_onresponse(struct smscore_device_t
> *coredev,
>  	/* Do we need to re-route? */
>  	if ((phdr->msgType == MSG_SMS_HO_PER_SLICES_IND) ||
>  			(phdr->msgType == MSG_SMS_TRANSMISSION_IND)) {
> -		if (coredev->mode == DEVICE_MODE_DVBT_BDA)
> +		if (coredev->mode == SMSHOSTLIB_DEVMD_DVBT_BDA)
>  			phdr->msgDstId = DVBT_BDA_CONTROL_MSG_ID;
>  	}
>  
> @@ -1021,16 +1029,16 @@ void smscore_onresponse(struct smscore_device_t
> *coredev,
>  		switch (phdr->msgType) {
>  		case MSG_SMS_GET_VERSION_EX_RES:
>  		{
> -			struct SmsVersionRes_ST *ver =
> -				(struct SmsVersionRes_ST *) phdr;
> +			struct SmsVersionRes_S *ver =
> +				(struct SmsVersionRes_S *) phdr;
>  			sms_debug("MSG_SMS_GET_VERSION_EX_RES "
>  				  "id %d prots 0x%x ver %d.%d",
> -				  ver->FirmwareId, ver->SupportedProtocols,
> -				  ver->RomVersionMajor, ver->RomVersionMinor);
> +				  ver->xVersion.FirmwareId, ver->xVersion.SupportedProtocols,
> +				  ver->xVersion.RomVer.Major, ver->xVersion.RomVer.Minor);
>  
> -			coredev->mode = ver->FirmwareId == 255 ?
> -				DEVICE_MODE_NONE : ver->FirmwareId;
> -			coredev->modes_supported = ver->SupportedProtocols;
> +			coredev->mode = ver->xVersion.FirmwareId == 255 ?
> +				SMSHOSTLIB_DEVMD_NONE : ver->xVersion.FirmwareId;
> +			coredev->modes_supported = ver->xVersion.SupportedProtocols;
>  
>  			complete(&coredev->version_ex_done);
>  			break;
> @@ -1081,9 +1089,9 @@ void smscore_onresponse(struct smscore_device_t
> *coredev,
>  			sms_ir_event(coredev,
>  				(const char *)
>  				((char *)phdr
> -				+ sizeof(struct SmsMsgHdr_ST)),
> +				+ sizeof(struct SmsMsgHdr_S)),
>  				(int)phdr->msgLength
> -				- sizeof(struct SmsMsgHdr_ST));
> +				- sizeof(struct SmsMsgHdr_S));
>  			break;
>  #endif /*SMS_RC_SUPPORT_SUBSYS*/
>  		default:
> @@ -1268,7 +1276,7 @@ int smsclient_sendrequest(struct smscore_client_t
> *client,
>  			  void *buffer, size_t size)
>  {
>  	struct smscore_device_t *coredev;
> -	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) buffer;
> +	struct SmsMsgHdr_S *phdr = (struct SmsMsgHdr_S *) buffer;
>  	int rc;
>  
>  	if (client == NULL) {
> @@ -1294,77 +1302,6 @@ int smsclient_sendrequest(struct smscore_client_t
> *client,
>  EXPORT_SYMBOL_GPL(smsclient_sendrequest);
>  
>  
> -/* old GPIO managements implementation */
> -int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
> -			   struct smscore_config_gpio *pinconfig)
> -{
> -	struct {
> -		struct SmsMsgHdr_ST hdr;
> -		u32 data[6];
> -	} msg;
> -
> -	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
> -		msg.hdr.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
> -		msg.hdr.msgDstId = HIF_TASK;
> -		msg.hdr.msgFlags = 0;
> -		msg.hdr.msgType  = MSG_SMS_GPIO_CONFIG_EX_REQ;
> -		msg.hdr.msgLength = sizeof(msg);
> -
> -		msg.data[0] = pin;
> -		msg.data[1] = pinconfig->pullupdown;
> -
> -		/* Convert slew rate for Nova: Fast(0) = 3 / Slow(1) = 0; */
> -		msg.data[2] = pinconfig->outputslewrate == 0 ? 3 : 0;
> -
> -		switch (pinconfig->outputdriving) {
> -		case SMS_GPIO_OUTPUTDRIVING_16mA:
> -			msg.data[3] = 7; /* Nova - 16mA */
> -			break;
> -		case SMS_GPIO_OUTPUTDRIVING_12mA:
> -			msg.data[3] = 5; /* Nova - 11mA */
> -			break;
> -		case SMS_GPIO_OUTPUTDRIVING_8mA:
> -			msg.data[3] = 3; /* Nova - 7mA */
> -			break;
> -		case SMS_GPIO_OUTPUTDRIVING_4mA:
> -		default:
> -			msg.data[3] = 2; /* Nova - 4mA */
> -			break;
> -		}
> -
> -		msg.data[4] = pinconfig->direction;
> -		msg.data[5] = 0;
> -	} else /* TODO: SMS_DEVICE_FAMILY1 */
> -		return -EINVAL;
> -
> -	return coredev->sendrequest_handler(coredev->context,
> -					    &msg, sizeof(msg));
> -}
> -
> -int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int
> level)
> -{
> -	struct {
> -		struct SmsMsgHdr_ST hdr;
> -		u32 data[3];
> -	} msg;
> -
> -	if (pin > MAX_GPIO_PIN_NUMBER)
> -		return -EINVAL;
> -
> -	msg.hdr.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
> -	msg.hdr.msgDstId = HIF_TASK;
> -	msg.hdr.msgFlags = 0;
> -	msg.hdr.msgType  = MSG_SMS_GPIO_SET_LEVEL_REQ;
> -	msg.hdr.msgLength = sizeof(msg);
> -
> -	msg.data[0] = pin;
> -	msg.data[1] = level ? 1 : 0;
> -	msg.data[2] = 0;
> -
> -	return coredev->sendrequest_handler(coredev->context,
> -					    &msg, sizeof(msg));
> -}
> -

I suspect that removing it will break support for some boards from Hauppauge,
as a similar change were nacked before.

Michael,

Any comments?

>  /* new GPIO management implementation */
>  static int GetGpioPinParams(u32 PinNum, u32 *pTranslatedPinNum,
>  		u32 *pGroupNum, u32 *pGroupCfg) {
> @@ -1428,7 +1365,7 @@ int smscore_gpio_configure(struct smscore_device_t
> *coredev, u8 PinNum,
>  	int rc;
>  
>  	struct SetGpioMsg {
> -		struct SmsMsgHdr_ST xMsgHeader;
> +		struct SmsMsgHdr_S xMsgHeader;
>  		u32 msgData[6];
>  	} *pMsg;
>  
> @@ -1439,7 +1376,7 @@ int smscore_gpio_configure(struct smscore_device_t
> *coredev, u8 PinNum,
>  	if (pGpioConfig == NULL)
>  		return -EINVAL;
>  
> -	totalLen = sizeof(struct SmsMsgHdr_ST) + (sizeof(u32) * 6);
> +	totalLen = sizeof(struct SmsMsgHdr_S) + (sizeof(u32) * 6);
>  
>  	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
>  			GFP_KERNEL | GFP_DMA);
> @@ -1464,23 +1401,23 @@ int smscore_gpio_configure(struct
> smscore_device_t *coredev, u8 PinNum,
>  
>  		pMsg->msgData[1] = TranslatedPinNum;
>  		pMsg->msgData[2] = GroupNum;
> -		ElectricChar = (pGpioConfig->PullUpDown)
> -				| (pGpioConfig->InputCharacteristics << 2)
> -				| (pGpioConfig->OutputSlewRate << 3)
> -				| (pGpioConfig->OutputDriving << 4);
> +		ElectricChar = (pGpioConfig->pull_up_down)
> +				| (pGpioConfig->input_characteristics << 2)
> +				| (pGpioConfig->output_slew_rate << 3)
> +				| (pGpioConfig->output_driving << 4);
>  		pMsg->msgData[3] = ElectricChar;
> -		pMsg->msgData[4] = pGpioConfig->Direction;
> +		pMsg->msgData[4] = pGpioConfig->direction;
>  		pMsg->msgData[5] = groupCfg;
>  	} else {
>  		pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_CONFIG_EX_REQ;
> -		pMsg->msgData[1] = pGpioConfig->PullUpDown;
> -		pMsg->msgData[2] = pGpioConfig->OutputSlewRate;
> -		pMsg->msgData[3] = pGpioConfig->OutputDriving;
> -		pMsg->msgData[4] = pGpioConfig->Direction;
> +		pMsg->msgData[1] = pGpioConfig->pull_up_down;
> +		pMsg->msgData[2] = pGpioConfig->output_slew_rate;
> +		pMsg->msgData[3] = pGpioConfig->output_driving;
> +		pMsg->msgData[4] = pGpioConfig->direction;
>  		pMsg->msgData[5] = 0;
>  	}
>  
> -	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
> +	smsendian_handle_tx_message((struct SmsMsgHdr_S *)pMsg);
>  	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
>  			&coredev->gpio_configuration_done);
>  
> @@ -1504,14 +1441,14 @@ int smscore_gpio_set_level(struct
> smscore_device_t *coredev, u8 PinNum,
>  	void *buffer;
>  
>  	struct SetGpioMsg {
> -		struct SmsMsgHdr_ST xMsgHeader;
> +		struct SmsMsgHdr_S xMsgHeader;
>  		u32 msgData[3]; /* keep it 3 ! */
>  	} *pMsg;
>  
>  	if ((NewLevel > 1) || (PinNum > MAX_GPIO_PIN_NUMBER))
>  		return -EINVAL;
>  
> -	totalLen = sizeof(struct SmsMsgHdr_ST) +
> +	totalLen = sizeof(struct SmsMsgHdr_S) +
>  			(3 * sizeof(u32)); /* keep it 3 ! */
>  
>  	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
> @@ -1530,7 +1467,7 @@ int smscore_gpio_set_level(struct smscore_device_t
> *coredev, u8 PinNum,
>  	pMsg->msgData[1] = NewLevel;
>  
>  	/* Send message to SMS */
> -	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
> +	smsendian_handle_tx_message((struct SmsMsgHdr_S *)pMsg);
>  	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
>  			&coredev->gpio_set_level_done);
>  
> @@ -1553,7 +1490,7 @@ int smscore_gpio_get_level(struct smscore_device_t
> *coredev, u8 PinNum,
>  	void *buffer;
>  
>  	struct SetGpioMsg {
> -		struct SmsMsgHdr_ST xMsgHeader;
> +		struct SmsMsgHdr_S xMsgHeader;
>  		u32 msgData[2];
>  	} *pMsg;
>  
> @@ -1561,7 +1498,7 @@ int smscore_gpio_get_level(struct smscore_device_t
> *coredev, u8 PinNum,
>  	if (PinNum > MAX_GPIO_PIN_NUMBER)
>  		return -EINVAL;
>  
> -	totalLen = sizeof(struct SmsMsgHdr_ST) + (2 * sizeof(u32));
> +	totalLen = sizeof(struct SmsMsgHdr_S) + (2 * sizeof(u32));
>  
>  	buffer = kmalloc(totalLen + SMS_DMA_ALIGNMENT,
>  			GFP_KERNEL | GFP_DMA);
> @@ -1579,7 +1516,7 @@ int smscore_gpio_get_level(struct smscore_device_t
> *coredev, u8 PinNum,
>  	pMsg->msgData[1] = 0;
>  
>  	/* Send message to SMS */
> -	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
> +	smsendian_handle_tx_message((struct SmsMsgHdr_S *)pMsg);
>  	rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
>  			&coredev->gpio_get_level_done);
>  
> diff --git a/drivers/media/dvb/siano/smscoreapi.h
> b/drivers/media/dvb/siano/smscoreapi.h
> index f700fa2..4b620c9 100644
> --- a/drivers/media/dvb/siano/smscoreapi.h
> +++ b/drivers/media/dvb/siano/smscoreapi.h
> @@ -2,7 +2,7 @@
>  
>  Siano Mobile Silicon, Inc.
>  MDTV receiver kernel modules.
> -Copyright (C) 2006-2008, Uri Shkolnik, Anatoly Greenblat
> +Copyright (C) 2006-2011, Doron Cohen
>  
>  This program is free software: you can redistribute it and/or modify
>  it under the terms of the GNU General Public License as published by
> @@ -34,8 +34,9 @@ along with this program.  If not, see
> <http://www.gnu.org/licenses/>.
>  
>  #include <asm/page.h>
>  
> +#ifdef SMS_RC_SUPPORT_SUBSYS
>  #include "smsir.h"
> -
> +#endif

Again, please don't mix it here.

>  
>  #define MAJOR_VERSION 2
>  #define MINOR_VERSION 3
> @@ -47,6 +48,1394 @@ along with this program.  If not, see
> <http://www.gnu.org/licenses/>.
>  #define VERSION_STRING "Version: " STRINGIZE(MAJOR_VERSION) "."
> STRINGIZE(MINOR_VERSION) "." STRINGIZE(SUB_VERSION)
>  #define MODULE_AUTHOR_STRING "Siano Mobile Silicon, Inc.
> (doronc@siano-ms.com)"
>  
> +/************************************************************************/
> +/* Defines, types and structures taken fron Siano SmsHostLibTypes.h,	*/
> +/* specifying required API with FW					*/
> +/************************************************************************/
> +
> +typedef enum
> +{
> +	SMSHOSTLIB_DEVMD_DVBT,
> +	SMSHOSTLIB_DEVMD_DVBH,
> +	SMSHOSTLIB_DEVMD_DAB_TDMB,
> +	SMSHOSTLIB_DEVMD_DAB_TDMB_DABIP,
> +	SMSHOSTLIB_DEVMD_DVBT_BDA,
> +	SMSHOSTLIB_DEVMD_ISDBT,
> +	SMSHOSTLIB_DEVMD_ISDBT_BDA,
> +	SMSHOSTLIB_DEVMD_CMMB,
> +	SMSHOSTLIB_DEVMD_RAW_TUNER,
> +	SMSHOSTLIB_DEVMD_FM_RADIO,
> +	SMSHOSTLIB_DEVMD_FM_RADIO_BDA,
> +	SMSHOSTLIB_DEVMD_ATSC,
> +	SMSHOSTLIB_DEVMD_MAX,
> +	SMSHOSTLIB_DEVMD_NONE = 0xFFFFFFFF
> +} SMSHOSTLIB_DEVICE_MODES_E;
> +
> +typedef enum SMSHOSTLIB_FREQ_BANDWIDTH_E
> +{
> +	BW_8_MHZ		= 0,
> +	BW_7_MHZ		= 1,
> +	BW_6_MHZ		= 2,
> +	BW_5_MHZ		= 3,
> +	BW_ISDBT_1SEG	= 4,
> +	BW_ISDBT_3SEG	= 5,
> +	BW_2_MHZ		= 6,
> +	BW_FM_RADIO		= 7,
> +	BW_ISDBT_13SEG	= 8,
> +	BW_1_5_MHZ		= 15,
> +	BW_UNKNOWN		= 0xFFFF
> +
> +} SMSHOSTLIB_FREQ_BANDWIDTH_ET;
> +
> +#define HIF_TASK			11		// Firmware messages processor task IS
> +#define HIF_TASK_SLAVE			22
> +#define HIF_TASK_SLAVE2			33
> +#define HIF_TASK_SLAVE3			44
> +#define SMS_HOST_LIB			150
> +
> +#define MSG_HDR_FLAG_SPLIT_MSG		4
> +
> +typedef struct SmsMsgHdr_S
> +{
> +	u16 	msgType;
> +	u8	msgSrcId;
> +	u8	msgDstId;
> +	u16	msgLength;	// Length is of the entire message, including header
> +	u16	msgFlags;
> +} SmsMsgHdr_ST;
> +
> +typedef struct SmsMsgData_S
> +{
> +	SmsMsgHdr_ST	xMsgHeader;
> +	u32			msgData[1];
> +} SmsMsgData_ST;
> +
> +typedef struct SmsMsgData2Args_S
> +{
> +	SmsMsgHdr_ST	xMsgHeader;
> +	u32			msgData[2];
> +} SmsMsgData2Args_ST;
> +
> +
> +typedef struct SmsMsgData3Args_S
> +{
> +	SmsMsgHdr_ST	xMsgHeader;
> +	u32			msgData[3];
> +} SmsMsgData3Args_ST;
> +
> +typedef struct SmsMsgData4Args_S
> +{
> +	SmsMsgHdr_ST	xMsgHeader;
> +	u32			msgData[4];
> +} SmsMsgData4Args_ST;

As a general rule, typedefs are not allowed at the Linux Kernel, as it
makes the code more obscure.

> +
> +
> +// Definitions of the message types.
> +// For each type, the format used (excluding the header) is specified
> +// The message direction is also specified
> +
> +typedef enum MsgTypes_E
> +{

NACK. The driver should use the error codes defined at include/asm-generic/errno*.h,
according with the DVBv5 API definitions where applicable.

> +	MSG_TYPE_BASE_VAL = 500,
> +
> +	//MSG_SMS_RESERVED1 = 501,				//		
> +	//MSG_SMS_RESERVED1 = 502,				//
> +

Comments should use C99. E. g. use /* */ for comments. the scripts/checkpatch.pl should have
warned you about that.

> +	MSG_SMS_GET_VERSION_REQ = 503,			// Get version
> +											// Format: None
> +											// Direction: Host->SMS
> +
> +	MSG_SMS_GET_VERSION_RES = 504,			// The response to
> MSG_SMS_GET_VERSION_REQ
> +											// Format:	8-bit - Version string
> +											// Direction: SMS->Host
> +
> +	MSG_SMS_MULTI_BRIDGE_CFG	= 505,		// Multi bridge configuration message
> +											// Format: 
> +											//		32 Bit Config type
> +											//		Rest - depends on config type.
> +	MSG_SMS_GPIO_CONFIG_REQ		= 507,		// Configure pin for GPIO 
> +	MSG_SMS_GPIO_CONFIG_RES		= 508,
> +	//MSG_SMS_RESERVED1 = 506,				//
> +
> +	MSG_SMS_GPIO_SET_LEVEL_REQ = 509,		// Set GPIO level high / low
> +											// Format: Data[0] = u32 PinNum
> +											//		   Data[1] = u32 NewLevel
> +											// Direction: Host-->FW
> +
> +	MSG_SMS_GPIO_SET_LEVEL_RES = 510,		// The response to
> MSG_SMS_GPIO_SET_LEVEL_REQ
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_GPIO_GET_LEVEL_REQ = 511,		// Get GPIO level high / low
> +											// Format: Data[0] = u32 PinNum
> +											//		   Data[1] = 0
> +											// Direction: Host-->FW
> +											  
> +	MSG_SMS_GPIO_GET_LEVEL_RES = 512,		// The response to
> MSG_SMS_GPIO_GET_LEVEL_REQ
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_EEPROM_BURN_IND = 513,				//
> +
> +	MSG_SMS_LOG_ENABLE_CHANGE_REQ = 514,	// Change the state of
> (enable/disable) log messages flow from SMS to Host (MSG_SMS_LOG_ITEM)
> +											// Format: 32-bit address value for g_log_enable
> +											// Direction: Host->SMS
> +
> +	MSG_SMS_LOG_ENABLE_CHANGE_RES = 515,	// A reply to
> MSG_SMS_LOG_ENABLE_CHANGE_REQ
> +											// Format: 32-bit address value for g_log_enable
> +											// Direction: SMS->Host
> +
> +	MSG_SMS_SET_MAX_TX_MSG_LEN_REQ = 516,	// Set the maximum length of a
> receiver message
> +											// Format: 32-bit value of length in bytes, must be modulo
> of 4
> +	MSG_SMS_SET_MAX_TX_MSG_LEN_RES = 517,	// ACK/ERR for
> MSG_SMS_SET_MAX_TX_MSG_LEN_REQ
> +
> +	MSG_SMS_SPI_HALFDUPLEX_TOKEN_HOST_TO_DEVICE	= 518,	// SPI Half-Duplex
> protocol
> +	MSG_SMS_SPI_HALFDUPLEX_TOKEN_DEVICE_TO_HOST	= 519,  //
> +
> +	// DVB-T MRC background scan messages
> +	MSG_SMS_BACKGROUND_SCAN_FLAG_CHANGE_REQ	= 520, 
> +	MSG_SMS_BACKGROUND_SCAN_FLAG_CHANGE_RES = 521, 
> +	MSG_SMS_BACKGROUND_SCAN_SIGNAL_DETECTED_IND		= 522,  
> +	MSG_SMS_BACKGROUND_SCAN_NO_SIGNAL_IND			= 523,  
> +
> +	MSG_SMS_CONFIGURE_RF_SWITCH_REQ		= 524,
> +	MSG_SMS_CONFIGURE_RF_SWITCH_RES		= 525,
> +
> +	MSG_SMS_MRC_PATH_DISCONNECT_REQ		= 526,
> +	MSG_SMS_MRC_PATH_DISCONNECT_RES		= 527,
> +
> +
> +	MSG_SMS_RECEIVE_1SEG_THROUGH_FULLSEG_REQ = 528, // Application: ISDB-T
> on SMS2270
> +													// Description: In full segment application, 
> +													//				enable reception of 1seg service even if full
> segment service is not received
> +	MSG_SMS_RECEIVE_1SEG_THROUGH_FULLSEG_RES = 529, // Application: ISDB-T
> on SMS2270
> +													// Description: In full segment application, 
> +													// enable reception of 1seg service even if
> +// Firmware messages processor task IS
> +	MSG_SMS_RECEIVE_VHF_VIA_VHF_INPUT_REQ = 530,	// Application: All on
> SMS2270
> +													// Enable VHF signal (170-240MHz) via VHF input
> +	
> +	MSG_SMS_RECEIVE_VHF_VIA_VHF_INPUT_RES = 531,	// Application: All on
> SMS2270
> +							// Enable VHF signal (170-240MHz) via VHF input
> +	
> +	//MSG_SMS_RESERVED1 = 532,			// 
> +													
> +
> +	MSG_WR_REG_RFT_REQ   =533,			// Write value to a given RFT register
> +										// Format: 32-bit address of register, following header
> +										//		   32-bit of value, following address
> +										// Direction: Host->SMS
> +
> +	MSG_WR_REG_RFT_RES   =534,			// Response to MSG_WR_REG_RFT_REQ message
> +										// Format: Status of write operation, following header
> +										// Direction: SMS->Host
> +
> +	MSG_RD_REG_RFT_REQ   =535,			// Read the value of a given RFT register
> +										// Format: 32-bit address of the register, following header
> +										// Direction: Host->SMS
> +
> +	MSG_RD_REG_RFT_RES   =536,			// Response to MSG_RD_REG_RFT_RES message
> +										// Format: 32-bit value of register, following header
> +										// Direction: SMS->Host
> +
> +	MSG_RD_REG_ALL_RFT_REQ=537,			// Read all 16 RFT registers
> +										// Format: N/A (nothing after the header)
> +										// Direction: Host->SMS
> +
> +	MSG_RD_REG_ALL_RFT_RES=538,			// Response to MSG_RD_REG_ALL_RFT_REQ
> message
> +										// Format: For each register, 32-bit address followed by
> 32-bit value (following header)
> +										// Direction: SMS->Host
> +
> +	MSG_HELP_INT          =539,			// Internal (SmsMonitor) message
> +										// Format: N/A (nothing after header)
> +										// Direction: Host->Host
> +
> +	MSG_RUN_SCRIPT_INT    =540,			// Internal (SmsMonitor) message
> +										// Format: Name of script(file) to run, immediately following
> header
> +										// direction: N/A
> +
> +	MSG_SMS_EWS_INBAND_REQ = 541,		//	Format: 32-bit value. 1 = EWS
> messages are sent in-band with the data, over TS packets. 0 = EWS
> packets are not sent
> +	MSG_SMS_EWS_INBAND_RES = 542,		// 
> +	
> +	MSG_SMS_RFS_SELECT_REQ = 543,		// Application: ISDB-T on SMS2130
> +										// Description: select RFS resistor value (if the HW of two
> 60kohm paralel resistor exist)
> +										// Format: Data[0] = u32 GPIO number, Data[1] = u32 selected
> RFS value, 0: select 30kohm, 1: select 60kohm
> +										// Direction: Host-->FW
> +										 
> +	MSG_SMS_RFS_SELECT_RES = 544,		// Application: ISDB-T on SMS2130
> +										// Description: Response to MSG_SMS_RFS_SELECT_REQ
> +										// Direction: FW-->Host
> +	
> +	MSG_SMS_MB_GET_VER_REQ = 545,			// 
> +	MSG_SMS_MB_GET_VER_RES = 546,			//  
> +	MSG_SMS_MB_WRITE_CFGFILE_REQ = 547,		// 
> +	MSG_SMS_MB_WRITE_CFGFILE_RES = 548,		//
> +	MSG_SMS_MB_READ_CFGFILE_REQ = 549,		// 
> +	MSG_SMS_MB_READ_CFGFILE_RES = 550,		//
> +	//MSG_SMS_RESERVED1 = 551,			// 
> +
> +	MSG_SMS_RD_MEM_REQ    =552,			// A request to read address in memory
> +										// Format: 32-bit of address, followed by 32-bit of range
> (following header)
> +										// Direction: Host->SMS
> +
> +	MSG_SMS_RD_MEM_RES    =553,			// The response to MSG_SMS_RD_MEM_REQ
> +										// Format: 32-bit of data X range, following header
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_WR_MEM_REQ    =554,			// A request to write data to memory
> +										// Format:	32-bit of address
> +										//			32-bit of range (in bytes)
> +										//			32-bit of value
> +										// Direction: Host->SMS
> +
> +	MSG_SMS_WR_MEM_RES    =555,			// Response to MSG_SMS_WR_MEM_REQ
> +										// Format: 32-bit of result
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_UPDATE_MEM_REQ = 556,
> +	MSG_SMS_UPDATE_MEM_RES = 557,
> +	
> +	MSG_SMS_ISDBT_ENABLE_FULL_PARAMS_SET_REQ = 558, // Application: ISDB-T
> on SMS2270
> +													// Description: A request to enable the recpetion of mode
> 1, 2 
> +													// and guard 1/32 which are disabled by default
> +	MSG_SMS_ISDBT_ENABLE_FULL_PARAMS_SET_RES = 559, // Application: ISDB-T
> on SMS2270
> +													// Description: A response to
> MSG_SMS_ISDBT_ENABLE_FULL_PARAMS_SET_REQ
> +													
> +	//MSG_SMS_RESERVED1 = 560,			//
> +	
> +	MSG_SMS_RF_TUNE_REQ=561,			// Application: CMMB, DVBT/H 
> +										// A request to tune to a new frequency
> +										// Format:	32-bit - Frequency in Hz
> +										//			32-bit - Bandwidth (in CMMB always use BW_8_MHZ)
> +										//			32-bit - Crystal (Use 0 for default, always 0 in CMMB)
> +										// Direction: Host->SMS
> +
> +	MSG_SMS_RF_TUNE_RES=562,			// Application: CMMB, DVBT/H 
> +										// A response to MSG_SMS_RF_TUNE_REQ
> +										// In DVBT/H this only indicates that the tune request
> +										// was received.
> +										// In CMMB, the response returns after the demod has
> determined
> +										// if there is a valid CMMB transmission on the frequency
> +										//
> +										// Format:
> +										//	DVBT/H:
> +										//		32-bit Return status. Should be SMSHOSTLIB_ERR_OK.
> +										//	CMMB:
> +										//		32-bit CMMB signal status - SMSHOSTLIB_ERR_OK means that
> the 
> +										//					frequency has a valid CMMB signal
> +										// 
> +										// Direction: SMS->Host
> +	
> +	MSG_SMS_ISDBT_ENABLE_HIGH_MOBILITY_REQ = 563,	// Application: ISDB-T
> on SMS2270
> +														// Description: A request to enable high mobility
> performance
> +														//
> +	MSG_SMS_ISDBT_ENABLE_HIGH_MOBILITY_RES = 564,	// Application: ISDB-T
> on SMS2270
> +														// Description: A response to
> MSG_SMS_ISDBT_ENABLE_HIGH_MOBILITY_REQ
> +
> +	MSG_SMS_ISDBT_SB_RECEPTION_REQ = 565,	// Application: ISDB-T on
> SMS2270
> +											// Description: A request to receive independent 1seg
> transmission via tune to 13seg.
> +	//
> +	MSG_SMS_ISDBT_SB_RECEPTION_RES = 566,	// Application: ISDB-T on
> SMS2270
> +											// Description: A response to MSG_SMS_ISDBT_SB_RECEPTION_REQ
> +
> +	MSG_SMS_GENERIC_EPROM_WRITE_REQ = 567,		//Write to EPROM.
> +	MSG_SMS_GENERIC_EPROM_WRITE_RES = 568,					//
> +
> +	MSG_SMS_GENERIC_EPROM_READ_REQ = 569,			// A request to read from the
> EPROM
> +	MSG_SMS_GENERIC_EPROM_READ_RES = 570,			// 
> +
> +	MSG_SMS_EEPROM_WRITE_REQ=571,		// A request to program the EEPROM
> +										// Format:	32-bit - Section status indication
> (0-first,running index,0xFFFFFFFF -last)
> +										//			32-bit - (optional) Image CRC or checksum
> +										//			32-bit - Total image length, in bytes, immediately
> following this DWORD
> +										//			32-bit - Actual section length, in bytes, immediately
> following this DWORD
> +										// Direction: Host->SMS
> +
> +	MSG_SMS_EEPROM_WRITE_RES=572,		// The status response to
> MSG_SMS_EEPROM_WRITE_REQ
> +										// Format:	32-bit of the response
> +										// Direction: SMS->Host
> +
> +	//MSG_SMS_RESERVED1 =573, 			// 
> +	MSG_SMS_CUSTOM_READ_REQ =574,			// 
> +	MSG_SMS_CUSTOM_READ_RES =575,			// 
> +	MSG_SMS_CUSTOM_WRITE_REQ =576,			// 
> +	MSG_SMS_CUSTOM_WRITE_RES =577,			//
> +
> +	MSG_SMS_INIT_DEVICE_REQ=578,		// A request to init device
> +										// Format: 32-bit - device mode (DVBT,DVBH,TDMB,DAB)
> +										//		   32-bit - Crystal
> +										//		   32-bit - Clk Division
> +										//		   32-bit - Ref Division
> +										// Direction: Host->SMS
> +
> +	MSG_SMS_INIT_DEVICE_RES=579,		// The response to
> MSG_SMS_INIT_DEVICE_REQ
> +										// Format:	32-bit - status
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_ATSC_SET_ALL_IP_REQ =580,			
> +	MSG_SMS_ATSC_SET_ALL_IP_RES =581,			
> +
> +	MSG_SMS_ATSC_START_ENSEMBLE_REQ = 582,
> +	MSG_SMS_ATSC_START_ENSEMBLE_RES = 583,
> +
> +	MSG_SMS_SET_OUTPUT_MODE_REQ	= 584,
> +	MSG_SMS_SET_OUTPUT_MODE_RES	= 585,
> +
> +	MSG_SMS_ATSC_IP_FILTER_GET_LIST_REQ = 586,
> +	MSG_SMS_ATSC_IP_FILTER_GET_LIST_RES = 587,
> +
> +	//MSG_SMS_RESERVED1 =588,			//
> +
> +	MSG_SMS_SUB_CHANNEL_START_REQ =589,	// DAB
> +	MSG_SMS_SUB_CHANNEL_START_RES =590,	// DAB
> +
> +	MSG_SMS_SUB_CHANNEL_STOP_REQ =591,	// DAB
> +	MSG_SMS_SUB_CHANNEL_STOP_RES =592,	// DAB
> +
> +	MSG_SMS_ATSC_IP_FILTER_ADD_REQ = 593,
> +	MSG_SMS_ATSC_IP_FILTER_ADD_RES = 594,
> +	MSG_SMS_ATSC_IP_FILTER_REMOVE_REQ = 595,
> +	MSG_SMS_ATSC_IP_FILTER_REMOVE_RES = 596,
> +	MSG_SMS_ATSC_IP_FILTER_REMOVE_ALL_REQ = 597,
> +	MSG_SMS_ATSC_IP_FILTER_REMOVE_ALL_RES = 598,
> +
> +	MSG_SMS_WAIT_CMD =599,				// Internal (SmsMonitor) message
> +										// Format: Name of script(file) to run, immediately following
> header
> +										// direction: N/A
> +	//MSG_SMS_RESERVED1 = 600,			// 
> +
> +	MSG_SMS_ADD_PID_FILTER_REQ=601,		// Application: DVB-T/DVB-H
> +										// Add PID to filter list
> +										// Format: 32-bit PID
> +										// Direction: Host->SMS
> +
> +	MSG_SMS_ADD_PID_FILTER_RES=602,		// Application: DVB-T/DVB-H
> +										// The response to MSG_SMS_ADD_PID_FILTER_REQ
> +										// Format:	32-bit - Status
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_REMOVE_PID_FILTER_REQ=603,	// Application: DVB-T/DVB-H
> +										// Remove PID from filter list
> +										// Format: 32-bit PID
> +										// Direction: Host->SMS
> +
> +	MSG_SMS_REMOVE_PID_FILTER_RES=604,	// Application: DVB-T/DVB-H
> +										// The response to MSG_SMS_REMOVE_PID_FILTER_REQ
> +										// Format:	32-bit - Status
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_FAST_INFORMATION_CHANNEL_REQ=605,// Application: DAB
> +										     // A request for a of a Fast Information Channel (FIC)
> +											 // Direction: Host->SMS
> +
> +	MSG_SMS_FAST_INFORMATION_CHANNEL_RES=606,// Application: DAB, ATSC M/H
> +										     // Forwarding of a Fast Information Channel (FIC)
> +											 // Format:	Sequence counter and FIC bytes with Fast
> Information Blocks { FIBs  as described in "ETSI EN 300 401 V1.3.3
> (2001-05)":5.2.1 Fast Information Block (FIB))
> +											 // Direction: SMS->Host
> +
> +	MSG_SMS_DAB_CHANNEL=607,			// Application: All
> +										// Forwarding of a played channel
> +										// Format:	H.264
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_GET_PID_FILTER_LIST_REQ=608,// Application: DVB-T
> +										// Request to get current PID filter list
> +										// Format: None
> +										// Direction: Host->SMS
> +
> +	MSG_SMS_GET_PID_FILTER_LIST_RES=609,// Application: DVB-T
> +										// The response to MSG_SMS_GET_PID_FILTER_LIST_REQ
> +										// Format:	array of 32-bit of PIDs
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_POWER_DOWN_REQ = 610,		// Request from the host to the chip to
> enter minimal power mode (as close to zero as possible)
> +	MSG_SMS_POWER_DOWN_RES = 611,   	//
> +
> +	MSG_SMS_ATSC_SLT_EXIST_IND = 612, 		// Application: ATSC M/H
> +	MSG_SMS_ATSC_NO_SLT_IND  = 613,	// Indication of SLT existence in the
> parade
> +	//MSG_SMS_RESERVED1 = 614,			//
> +
> +	MSG_SMS_GET_STATISTICS_REQ=615,		// Application: DVB-T / DAB
> +										// Request statistics information 
> +										// In DVB-T uses only at the driver level (BDA)
> +										// Direction: Host->FW
> +
> +	MSG_SMS_GET_STATISTICS_RES=616,		// Application: DVB-T / DAB
> +										// The response to MSG_SMS_GET_STATISTICS_REQ
> +										// Format:	SmsMsgStatisticsInfo_ST
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_SEND_DUMP=617,				// uses for - Dump msgs
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_SCAN_START_REQ=618,			// Application: CMMB
> +										// Start Scan
> +										// Format:
> +										//			32-bit - Bandwidth
> +										//			32-bit - Scan Flags
> +										//			32-bit - Param Type
> +										// In CMMB Param type must be 0 - because of CMRI spec, 
> +										//	and only range is supported.
> +										//
> +										// In other standards:
> +										// If Param Type is SCAN_PARAM_TABLE:
> +										//			32-bit - Number of frequencies N
> +										//			N*32-bits - List of frequencies
> +										// If Param Type is SCAN_PARAM_RANGE:
> +										//			32-bit - Start Frequency
> +										//			32-bit - Gap between frequencies
> +										//			32-bit - End Frequency
> +										// Direction: Host->SMS
> +
> +	MSG_SMS_SCAN_START_RES=619,			// Application: CMMB
> +										// Scan Start Reply
> +										// Format:	32-bit - ACK/NACK
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_SCAN_STOP_REQ=620,			// Application: CMMB
> +										// Stop Scan
> +										// Direction: Host->SMS
> +
> +	MSG_SMS_SCAN_STOP_RES=621,			// Application: CMMB
> +										// Scan Stop Reply
> +										// Format:	32-bit - ACK/NACK
> +										// Direction: SMS->Host
> +
> +	MSG_SMS_SCAN_PROGRESS_IND=622,		// Application: CMMB
> +										// Scan progress indications
> +										// Format:
> +										//		32-bit RetCode: SMSHOSTLIB_ERR_OK means that the
> frequency is Locked
> +										//		32-bit Current frequency 
> +										//		32-bit Number of frequencies remaining for scan
> +										//		32-bit NetworkID of the current frequency - if locked. If
> not locked - 0.
> +										
> +	MSG_SMS_SCAN_COMPLETE_IND=623,		// Application: CMMB
> +										// Scan completed
> +										// Format: Same as SCAN_PROGRESS_IND
> +
> +	MSG_SMS_LOG_ITEM = 624,             // Application: All
> +										// Format:	SMSHOSTLIB_LOG_ITEM_ST.
> +										// Actual size depend on the number of parameters
> +										// Direction: Host->SMS
> +
> +	//MSG_SMS_RESERVED1  = 625,			//
> +	//MSG_SMS_RESERVED1  = 626,			//
> +	//MSG_SMS_RESERVED1 = 627,			//  
> +
> +	MSG_SMS_DAB_SUBCHANNEL_RECONFIG_REQ = 628,	// Application: DAB
> +	MSG_SMS_DAB_SUBCHANNEL_RECONFIG_RES = 629,	// Application: DAB
> +
> +	// Handover - start (630)
> +	MSG_SMS_HO_PER_SLICES_IND		= 630,		// Application: DVB-H 
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_HO_INBAND_POWER_IND		= 631,		// Application: DVB-H 
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_MANUAL_DEMOD_REQ		= 632,		// Application: DVB-H
> +												// Debug msg 
> +												// Direction: Host-->FW
> +
> +	//MSG_SMS_HO_RESERVED1_RES		= 633,		// Application: DVB-H  
> +	//MSG_SMS_HO_RESERVED2_RES		= 634,		// Application: DVB-H  
> +	//MSG_SMS_HO_RESERVED3_RES		= 635,		// Application: DVB-H 
> +
> +	MSG_SMS_HO_TUNE_ON_REQ			= 636,		// Application: DVB-H  
> +	MSG_SMS_HO_TUNE_ON_RES			= 637,		// Application: DVB-H  
> +	MSG_SMS_HO_TUNE_OFF_REQ			= 638,		// Application: DVB-H 	
> +	MSG_SMS_HO_TUNE_OFF_RES			= 639,		// Application: DVB-H  
> +	MSG_SMS_HO_PEEK_FREQ_REQ		= 640,		// Application: DVB-H 
> +	MSG_SMS_HO_PEEK_FREQ_RES		= 641,		// Application: DVB-H  
> +	MSG_SMS_HO_PEEK_FREQ_IND		= 642,		// Application: DVB-H 
> +	// Handover - end (642)
> +
> +	MSG_SMS_MB_ATTEN_SET_REQ		= 643,		// 
> +	MSG_SMS_MB_ATTEN_SET_RES		= 644,		//
> +
> +	//MSG_SMS_RESERVED1				= 645,		//
> +	//MSG_SMS_RESERVED1				= 646,		//						
> +	//MSG_SMS_RESERVED1				= 647,		//	
> +	//MSG_SMS_RESERVED1				= 648,		//
> +
> +	MSG_SMS_ENABLE_STAT_IN_I2C_REQ = 649,		// Application: DVB-T
> (backdoor)
> +												// Enable async statistics in I2C polling 
> +												// Direction: Host->FW
> +
> +	MSG_SMS_ENABLE_STAT_IN_I2C_RES = 650,		// Application: DVB-T
> +												// Response to MSG_SMS_ENABLE_STAT_IN_I2C_REQ
> +												// Format: N/A
> +												// Direction: FW->Host
> +
> +	MSG_SMS_GET_STATISTICS_EX_REQ   = 653,		// Application: ISDBT / FM
> +												// Request for statistics 
> +												// Direction: Host-->FW
> +
> +	MSG_SMS_GET_STATISTICS_EX_RES   = 654,		// Application: ISDBT / FM
> +												// Format:
> +												// 32 bit ErrCode
> +												// The rest: A mode-specific statistics struct starting
> +												// with a 32 bits type field.
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_SLEEP_RESUME_COMP_IND	= 655,		// Application: All
> +												// Indicates that a resume from sleep has been completed
> +												// Uses for Debug only
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_SWITCH_HOST_INTERFACE_REQ	= 656,		// Application: All
> +	MSG_SMS_SWITCH_HOST_INTERFACE_RES	= 657,		// Request the FW to switch
> off the current host I/F and activate a new one
> +													// Format: one u32 parameter in SMSHOSTLIB_COMM_TYPES_E
> format
> +
> +	MSG_SMS_DATA_DOWNLOAD_REQ		= 660,		// Application: All
> +												// Direction: Host-->FW
> +
> +	MSG_SMS_DATA_DOWNLOAD_RES		= 661,		// Application: All
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_DATA_VALIDITY_REQ		= 662,		// Application: All
> +												// Direction: Host-->FW
> +												
> +	MSG_SMS_DATA_VALIDITY_RES		= 663,		// Application: All
> +												// Direction: FW-->Host
> +												
> +	MSG_SMS_SWDOWNLOAD_TRIGGER_REQ	= 664,		// Application: All
> +												// Direction: Host-->FW
> +												
> +	MSG_SMS_SWDOWNLOAD_TRIGGER_RES	= 665,		// Application: All
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_SWDOWNLOAD_BACKDOOR_REQ	= 666,		// Application: All
> +												// Direction: Host-->FW
> +	
> +	MSG_SMS_SWDOWNLOAD_BACKDOOR_RES	= 667,		// Application: All
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_GET_VERSION_EX_REQ		= 668,		// Application: All Except CMMB
> +												// Direction: Host-->FW
> +
> +	MSG_SMS_GET_VERSION_EX_RES		= 669,		// Application: All Except CMMB
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_CLOCK_OUTPUT_CONFIG_REQ = 670,		// Application: All 
> +												// Request to clock signal output from SMS
> +												// Format: 32-bit - Enable/Disable clock signal
> +												//         32-bit - Requested clock frequency
> +												// Direction: Host-->FW
> +
> +	MSG_SMS_CLOCK_OUTPUT_CONFIG_RES = 671,		// Application: All
> +												// Response to clock signal output config request
> +												// Format: 32-bit - Status
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_I2C_SET_FREQ_REQ		= 685,		// Application: All 
> +												// Request to start I2C configure with new clock Frequency
> +												// Format: 32-bit - Requested clock frequency
> +												// Direction: Host-->FW
> +
> +	MSG_SMS_I2C_SET_FREQ_RES		= 686,		// Application: All 
> +												// Response to MSG_SMS_I2C_SET_FREQ_REQ
> +												// Format: 32-bit - Status
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_GENERIC_I2C_REQ			= 687,		// Application: All 
> +												// Request to write buffer through I2C
> +												// Format: 32-bit - device address
> +												//		   32-bit - write size
> +												//		   32-bit - requested read size
> +												//		   n * 8-bit - write buffer
> +
> +	MSG_SMS_GENERIC_I2C_RES			= 688,		// Application: All 
> +												// Response to MSG_SMS_GENERIC_I2C_REQ
> +												// Format: 32-bit - Status
> +												//		   32-bit - read size
> +												//         n * 8-bit - read data
> +
> +	//MSG_SMS_RESERVED1				= 689,		// 
> +	//MSG_SMS_RESERVED1				= 690,		// 
> +	//MSG_SMS_RESERVED1				= 691,		// 
> +	//MSG_SMS_RESERVED1				= 692,		// 
> +
> +	MSG_SMS_DVBT_BDA_DATA			= 693,		// Application: All (BDA)
> +												// Direction: FW-->Host
> +												
> +	//MSG_SMS_RESERVED1				= 694,		//
> +	//MSG_SMS_RESERVED1				= 695,		//
> +	//MSG_SMS_RESERVED1				= 696,		//
> +	MSG_SW_RELOAD_REQ			= 697,			//Reload request
> +	//MSG_SMS_RESERVED1				= 698,		//
> +
> +	MSG_SMS_DATA_MSG				= 699,		// Application: All
> +												// Direction: FW-->Host
> +
> +	///  NOTE: Opcodes targeted for Stellar cannot exceed 700
> +	MSG_TABLE_UPLOAD_REQ			= 700,		// Request for PSI/SI tables in DVB-H
> +												// Format: 
> +												// Direction Host->SMS
> +
> +	MSG_TABLE_UPLOAD_RES			= 701,		// Reply to MSG_TABLE_UPLOAD_REQ
> +												// Format: 
> +												// Direction SMS->Host
> +
> +	// reload without reseting the interface
> +	MSG_SW_RELOAD_START_REQ			= 702,		// Request to prepare to reload 
> +	MSG_SW_RELOAD_START_RES			= 703,		// Response to 
> +	MSG_SW_RELOAD_EXEC_REQ			= 704,		// Request to start reload
> +	MSG_SW_RELOAD_EXEC_RES			= 705,		// Response to MSG_SW_RELOAD_EXEC_REQ
> +
> +	//MSG_SMS_RESERVED1				= 706,		//
> +	//MSG_SMS_RESERVED1				= 707,		//
> +	//MSG_SMS_RESERVED1				= 708,		//
> +	//MSG_SMS_RESERVED1				= 709,		//
> +
> +	MSG_SMS_SPI_INT_LINE_SET_REQ	= 710,		//
> +	MSG_SMS_SPI_INT_LINE_SET_RES	= 711,		//
> +
> +	MSG_SMS_GPIO_CONFIG_EX_REQ		= 712,		//
> +	MSG_SMS_GPIO_CONFIG_EX_RES		= 713,		//
> +
> +	//MSG_SMS_RESERVED1				= 714,		//
> +	//MSG_SMS_RESERVED1  			= 715,		//
> +
> +	MSG_SMS_WATCHDOG_ACT_REQ		= 716,		//
> +	MSG_SMS_WATCHDOG_ACT_RES		= 717,		//
> +
> +	MSG_SMS_LOOPBACK_REQ			= 718,		//
> +	MSG_SMS_LOOPBACK_RES			= 719,		//  
> +
> +	MSG_SMS_RAW_CAPTURE_START_REQ	= 720,  	//
> +	MSG_SMS_RAW_CAPTURE_START_RES	= 721,  	//
> +
> +	MSG_SMS_RAW_CAPTURE_ABORT_REQ	= 722,  	//
> +	MSG_SMS_RAW_CAPTURE_ABORT_RES	= 723,  	//
> +
> +	//MSG_SMS_RESERVED1				=  724,  	//
> +	//MSG_SMS_RESERVED1				=  725,  	//
> +	//MSG_SMS_RESERVED1				=  726,  	// 
> +	//MSG_SMS_RESERVED1				=  727,  	//
> +
> +	MSG_SMS_RAW_CAPTURE_COMPLETE_IND = 728, 	//
> +
> +	MSG_SMS_DATA_PUMP_IND			= 729,  	// USB debug - _TEST_DATA_PUMP 
> +	MSG_SMS_DATA_PUMP_REQ			= 730,  	// USB debug - _TEST_DATA_PUMP 
> +	MSG_SMS_DATA_PUMP_RES			= 731,  	// USB debug - _TEST_DATA_PUMP 
> +
> +	MSG_SMS_FLASH_DL_REQ			= 732,		// A request to program the FLASH
> +												// Format:	32-bit - Section status indication
> (0-first,running index,0xFFFFFFFF -last)
> +												//			32-bit - (optional) Image CRC or checksum
> +												//			32-bit - Total image length, in bytes, immediately
> following this DWORD
> +												//			32-bit - Actual section length, in bytes, immediately
> following this DWORD
> +												// Direction: Host->SMS
> +
> +	MSG_SMS_FLASH_DL_RES			= 733,		// The status response to
> MSG_SMS_FLASH_DL_REQ
> +												// Format:	32-bit of the response
> +												// Direction: SMS->Host
> +
> +	MSG_SMS_EXEC_TEST_1_REQ			= 734,		// USB debug - _TEST_DATA_PUMP 
> +	MSG_SMS_EXEC_TEST_1_RES			= 735,  	// USB debug - _TEST_DATA_PUMP 
> +
> +	MSG_SMS_ENBALE_TS_INTERFACE_REQ	= 736,		// A request set TS interface
> as the DATA(!) output interface
> +												// Format:	32-bit - Requested Clock speed in Hz(0-disable)
> +												//			32-bit - transmission mode (Serial or Parallel)
> +												// Direction: Host->SMS
> +
> +	MSG_SMS_ENBALE_TS_INTERFACE_RES	= 737,  	//
> +
> +	MSG_SMS_SPI_SET_BUS_WIDTH_REQ	= 738,  	//
> +	MSG_SMS_SPI_SET_BUS_WIDTH_RES	= 739,  	//
> +
> +	MSG_SMS_SEND_EMM_REQ 			= 740,  	//  Request to process Emm from API
> +	MSG_SMS_SEND_EMM_RES			= 741,  	//	Response to MSG_SMS_SEND_EMM_REQ
> +
> +	MSG_SMS_DISABLE_TS_INTERFACE_REQ = 742, 	//
> +	MSG_SMS_DISABLE_TS_INTERFACE_RES = 743, 	//
> +
> +	MSG_SMS_IS_BUF_FREE_REQ			= 744,    	//Request to check is CaBuf is
> free for EMM from API
> +	MSG_SMS_IS_BUF_FREE_RES			= 745,    	//Response to
> MSG_SMS_IS_BUF_FREE_RES
> +
> +	MSG_SMS_EXT_ANTENNA_REQ			= 746,  	//Activate external antenna search
> algorithm 
> +	MSG_SMS_EXT_ANTENNA_RES			= 747,  	//confirmation 
> +
> +	MSG_SMS_CMMB_GET_NET_OF_FREQ_REQ_OBSOLETE= 748,		// Obsolete
> +	MSG_SMS_CMMB_GET_NET_OF_FREQ_RES_OBSOLETE= 749,	    // Obsolete
> +
> +	MSG_SMS_BATTERY_LEVEL_REQ		= 750,		//Request to get battery charge
> level
> +	MSG_SMS_BATTERY_LEVEL_RES		= 751,		//Response to
> MSG_SMS_BATTERY_LEVEL_REQ
> +
> +	MSG_SMS_CMMB_INJECT_TABLE_REQ_OBSOLETE	= 752,		// Obsolete
> +	MSG_SMS_CMMB_INJECT_TABLE_RES_OBSOLETE	= 753,		// Obsolete
> +	
> +	MSG_SMS_FM_RADIO_BLOCK_IND		= 754,		// Application: FM_RADIO
> +												// Description: RDS blocks
> +												// Format: Data[0] = 	
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_HOST_NOTIFICATION_IND 	= 755,		// Application: CMMB
> +												// Description: F/W notification to host
> +												// Data[0]:	SMSHOSTLIB_CMMB_HOST_NOTIFICATION_TYPE_ET
> +												// Direction: FW-->Host
> +
> +	MSG_SMS_CMMB_GET_CONTROL_TABLE_REQ_OBSOLETE	= 756,	// Obsolete
> +	MSG_SMS_CMMB_GET_CONTROL_TABLE_RES_OBSOLETE = 757,	// Obsolete
> +
> +
> +	//MSG_SMS_RESERVED1				= 758,	// 
> +	//MSG_SMS_RESERVED1				= 759,	// 
> +
> +	MSG_SMS_CMMB_GET_NETWORKS_REQ	= 760,	// Data[0]: Reserved - has to be
> 0
> +	MSG_SMS_CMMB_GET_NETWORKS_RES	= 761,	// Data[0]: RetCode
> +											// Data[1]: Number of networks (N)
> +											// Followed by N * SmsCmmbNetworkInfo_ST
> +
> +	MSG_SMS_CMMB_START_SERVICE_REQ	= 762,	// Data[0]: u32 Reserved
> 0xFFFFFFFF (was NetworkLevel)
> +											// Data[1]: u32 Reserved 0xFFFFFFFF (was NetworkNumber)
> +											// Data[2]: u32 ServiceId
> +
> +	MSG_SMS_CMMB_START_SERVICE_RES	= 763,	// Data[0]: u32 RetCode
> +											// Data[1]: u32 ServiceHandle
> +											// Data[2]: u32 Service sub frame index
> +											//		The index of the sub frame that contains the service
> +											//      inside the multiplex frame. Usually 0.
> +											// Data[1]: u32 Service ID
> +											//		The started service ID 
> +
> +	MSG_SMS_CMMB_STOP_SERVICE_REQ	= 764,	// Data[0]: u32 ServiceHandle
> +	MSG_SMS_CMMB_STOP_SERVICE_RES	= 765,	// Data[0]: u32 RetCode
> +
> +	MSG_SMS_CMMB_ADD_CHANNEL_FILTER_REQ		= 768,	// Data[0]: u32 Channel ID
> +	MSG_SMS_CMMB_ADD_CHANNEL_FILTER_RES		= 769,	// Data[0]: u32 RetCode
> +
> +	MSG_SMS_CMMB_REMOVE_CHANNEL_FILTER_REQ	= 770,	// Data[0]: u32 Channel
> ID
> +	MSG_SMS_CMMB_REMOVE_CHANNEL_FILTER_RES	= 771,	// Data[0]: u32 RetCode
> +
> +	MSG_SMS_CMMB_START_CONTROL_INFO_REQ		= 772,	// Format:	
> +													// Data[0]: u32 Reserved 0xFFFFFFFF (was NetworkLevel)
> +													// Data[1]: u32 Reserved 0xFFFFFFFF (was NetworkNumber)
> +
> +	MSG_SMS_CMMB_START_CONTROL_INFO_RES		= 773,	// Format:	Data[0]: u32
> RetCode
> +
> +	MSG_SMS_CMMB_STOP_CONTROL_INFO_REQ		= 774,	// Format: No Payload
> +	MSG_SMS_CMMB_STOP_CONTROL_INFO_RES		= 775,	// Format: Data[0]: u32
> RetCode
> +
> +	MSG_SMS_ISDBT_TUNE_REQ			= 776,	// Application Type: ISDB-T
> +											// Description: A request to tune to a new frequency
> +											// Format:	Data[0]:	u32 Frequency
> +											//			Data[1]:	u32 Bandwidth
> +											//			Data[2]:	u32 Crystal
> +											//			Data[3]:	u32 Segment number
> +											// Direction: Host->SMS
> +
> +	MSG_SMS_ISDBT_TUNE_RES			= 777,	// Application Type: ISDB-T
> +											// Data[0]:	u32 RetCode
> +											// Direction: SMS->Host
> +
> +	//MSG_SMS_RESERVED1		        = 778,	// 
> +	//MSG_SMS_RESERVED1             = 779,	// 
> +	//MSG_SMS_RESERVED1				= 780,	// 
> +	//MSG_SMS_RESERVED1         	= 781,	// 
> +
> +	MSG_SMS_TRANSMISSION_IND		= 782,  // Application Type: DVB-T/DVB-H 
> +											// Description: Send statistics info using the following
> structure:
> +											// TRANSMISSION_STATISTICS_ST
> +											//	 Data[0] = u32 Frequency																
> +											//   Data[1] = u32 Bandwidth				
> +											//   Data[2] = u32 TransmissionMode		
> +											//   Data[3] = u32 GuardInterval			
> +											//   Data[4] = u32 CodeRate				
> +											//   Data[5] = u32 LPCodeRate				
> +											//   Data[6] = u32 Hierarchy				
> +											//   Data[7] = u32 Constellation			
> +											//   Data[8] = u32 CellId					
> +											//   Data[9] = u32 DvbhSrvIndHP			
> +											//   Data[10]= u32 DvbhSrvIndLP			
> +											//   Data[11]= u32 IsDemodLocked			
> +											// Direction: FW-->Host
> +												
> +	MSG_SMS_PID_STATISTICS_IND		= 783,	// Application Type: DVB-H 
> +											// Description: Send PID statistics info using the following
> structure:
> +											// PID_DATA_ST
> +											//	 Data[0] = u32 pid
> +											//   Data[1] = u32 num rows 
> +											//   Data[2] = u32 size  
> +											//   Data[3] = u32 padding_cols
> +											//   Data[4] = u32 punct_cols
> +											//   Data[5] = u32 duration
> +											//   Data[6] = u32 cycle
> +											//   Data[7] = u32 calc_cycle
> +											//   Data[8] = u32 tot_tbl_cnt 
> +											//   Data[9] = u32 invalid_tbl_cnt 
> +											//   Data[10]= u32 tot_cor_tbl
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_POWER_DOWN_IND			= 784,	// Application Type: DVB-H 
> +											// Description: Indicates start of the power down to sleep
> mode procedure
> +											//  data[0] - requestId, 
> +											//  data[1] - message quarantine time
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_POWER_DOWN_CONF			= 785,	// Application Type: DVB-H 
> +											// Description: confirms the power down procedure, 
> +											// data[0] - requestId, 
> +											// data[1] - quarantine time
> +											// Direction: Host-->FW 
> +
> +	MSG_SMS_POWER_UP_IND			= 786,	// Application Type: DVB-H 
> +											// Description: Indicates end of sleep mode,       
> +											// data[0] - requestId
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_POWER_UP_CONF			= 787,	// Application Type: DVB-H 
> +											// Description: confirms the end of sleep mode,    
> +											// data[0] - requestId
> +											// Direction: Host-->FW 
> +
> +	//MSG_SMS_RESERVED1             = 788,	//
> +	//MSG_SMS_RESERVED1				= 789,	//
> +
> +	MSG_SMS_POWER_MODE_SET_REQ		= 790,	// Application: DVB-H 
> +											// Description: set the inter slice power down (sleep) mode
> (Enable/Disable)
> +											// Format: Data[0] = u32 sleep mode
> +											// Direction: Host-->FW 
> +
> +	MSG_SMS_POWER_MODE_SET_RES		= 791,	// Application: DVB-H
> +											// Description: response to the previous request
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_DEBUG_HOST_EVENT_REQ	= 792,	// Application: CMMB (Internal) 
> +											// Description: An opaque event host-> FW for debugging
> internal purposes (CMMB)
> +											// Format:	data[0] = Event type (enum)
> +											//			data[1] = Param
> +
> +	MSG_SMS_DEBUG_HOST_EVENT_RES	= 793,	// Application: CMMB (Internal)
> +											// Description: Response. 
> +											// Format:  data[0] = RetCode, 
> +											//			data[1] = RetParam
> +
> +
> +	MSG_SMS_NEW_CRYSTAL_REQ			= 794,	// Application: All 
> +											// report crystal input to FW
> +											// Format:  data[0] = u32 crystal 
> +											// Direction: Host-->FW 
> +
> +	MSG_SMS_NEW_CRYSTAL_RES			= 795,  // Application Type: All 
> +											// Response to MSG_SMS_NEW_CRYSTAL_REQ
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_CONFIG_SPI_REQ			= 796,	// Application: All 
> +											// Configure SPI interface (also activates I2C slave
> interface)
> +											// Format:	data[0] = SPI Controller (u32)
> +											//			data[1] = SPI Mode - Master/Slave (u32)
> +											//			data[2] = SPI Type - Mot/TI (u32)
> +											//			data[3] = SPI Width - 8bit/32bit (u32)
> +											//			data[4] = SPI Clock - in Hz (u32)
> +											// Direction: Host-->FW
> +
> +	MSG_SMS_CONFIG_SPI_RES			= 797,	// Application: All 
> +											// Response to MSG_SMS_CONFIG_SPI_RES
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_I2C_SHORT_STAT_IND		= 798,	// Application Type: DVB-T/ISDB-T 
> +											// Format: ShortStatMsg_ST
> +											//		Data[0] = u16 msgType
> +											//		Data[1] = u8	msgSrcId
> +											//		Data[2] = u8	msgDstId
> +											//		Data[3] = u16	msgLength	
> +											//		Data[4] = u16	msgFlags
> +											//  The following parameters relevant in DVB-T only - in
> isdb-t should be Zero
> +											//		Data[5] = u32 IsDemodLocked;
> +											//		Data[6] = u32 InBandPwr;
> +											//		Data[7] = u32 BER;
> +											//		Data[8] = u32 SNR;
> +											//		Data[9] = u32 TotalTsPackets;
> +											//		Data[10]= u32 ErrorTSPackets;
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_START_IR_REQ			= 800,  // Application: All
> +											// Description: request to start sampling IR controller
> +											// Format: Data[0] = irController;
> +											//		   Data[1] = irTimeout;
> +											// Direction: Host-->FW
> +
> +	MSG_SMS_START_IR_RES			= 801,  // Application: All
> +											// Response to MSG_SMS_START_IR_REQ
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_IR_SAMPLES_IND			= 802,  // Application: All
> +											// Send IR samples to Host
> +											// Format: Data[] = 128 * u32 
> +											// Direction: FW-->Host
> +	
> +	MSG_SMS_CMMB_CA_SERVICE_IND		= 803,	// Format:	u32 data[0] u32
> Indication type, according to
> +											//					SmsCaServiceIndicationTypes_EN enum
> +											//			u32 data[1] u32 Service ID
> +
> +	MSG_SMS_SLAVE_DEVICE_DETECTED	= 804,  // Application: DVB-T MRC
> +											// Description: FW indicate that Slave exist in MRC - DVB-T
> application
> +											// Direction: FW->Host
> +
> +	MSG_SMS_INTERFACE_LOCK_IND		= 805,	// Application: All
> +											// Description: firmware requests that the host does not
> transmit anything on the interface
> +											// Direction: FW->Host
> +
> +	MSG_SMS_INTERFACE_UNLOCK_IND	= 806,	// Application: All
> +											// Description: firmware signals that the host may resume
> transmission
> +											// Direction: FW->Host
> +
> +	//MSG_SMS_RESERVED1				= 807,	// 
> +	//MSG_SMS_RESERVED1				= 808,	// 
> +	//MSG_SMS_RESERVED1				= 809,	//
> +
> +	MSG_SMS_SEND_ROSUM_BUFF_REQ		= 810,  // Application: Rosum
> +											// Description: Host send buffer to Rosum internal module in
> FW 
> +											// Format: msg structure is proprietary to rosum, size can
> be up to 240
> +											// Direction: Host-->FW
> +
> +	MSG_SMS_SEND_ROSUM_BUFF_RES		= 811,  // Application: Rosum
> +											// Response to MSG_SMS_SEND_ROSUM_BUFF_RES
> +											// Direction: FW->Host
> +
> +	MSG_SMS_ROSUM_BUFF				= 812,  // Application: Rosum
> +											// Description: Rosum internal module in FW  send buffer to
> Host
> +											// Format: msg structure is proprietary to rosum, size can
> be up to 240
> +											// Direction: FW->Host
> +
> +	//MSG_SMS_RESERVED1				= 813,	// 
> +	//MSG_SMS_RESERVED1				= 814,	// 
> +
> +	MSG_SMS_SET_AES128_KEY_REQ		= 815,  // Application: ISDB-T
> +											// Description: Host send key for AES128
> +											// Format: String
> +											// Direction: Host-->FW
> +
> +	MSG_SMS_SET_AES128_KEY_RES		= 816,  // Application: ISDB-T
> +											// Description: response to MSG_SMS_SET_AES128_KEY_REQ
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_MBBMS_WRITE_REQ			= 817,	// MBBMS-FW communication message -
> downstream
> +	MSG_SMS_MBBMS_WRITE_RES			= 818,	// MBBMS-FW communication message -
> downstream response
> +	MSG_SMS_MBBMS_READ_IND			= 819,	// MBBMS-FW communication message -
> upstream
> +
> +	MSG_SMS_IQ_STREAM_START_REQ		= 820,  // Application: Streamer
> +	MSG_SMS_IQ_STREAM_START_RES		= 821,  // Application: Streamer
> +	MSG_SMS_IQ_STREAM_STOP_REQ		= 822,  // Application: Streamer
> +	MSG_SMS_IQ_STREAM_STOP_RES		= 823,  // Application: Streamer
> +	MSG_SMS_IQ_STREAM_DATA_BLOCK	= 824,  // Application: Streamer
> +
> +	MSG_SMS_GET_EEPROM_VERSION_REQ  = 825,	// Request to get EEPROM
> version string
> +
> +	MSG_SMS_GET_EEPROM_VERSION_RES  = 826,	// Response to get EEPROM
> version string request
> +											// Format: 32-bit - Status
> +											//         32-bit - Length of string
> +											//         N*bytes - EEPROM version string
> +
> +	MSG_SMS_SIGNAL_DETECTED_IND		= 827,  // Application: DVB-T/ISDB-T/TDMB
> +											// Description: Indication on good signal - after Tune 
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_NO_SIGNAL_IND			= 828,  // Application: DVB-T/ISDB-T/TDMB
> +											// Description: Indication on bad signal - after Tune 
> +											// Direction: FW-->Host
> +
> +	//MSG_SMS_RESERVED1				= 829,	//	
> +
> +	MSG_SMS_MRC_SHUTDOWN_SLAVE_REQ	= 830,	// Application: DVB-T MRC
> +											// Description: Power down MRC slave to save power
> +											// Direction: Host-->FW
> +
> +	MSG_SMS_MRC_SHUTDOWN_SLAVE_RES	= 831,	// Application: DVB-T MRC
> +											// Description: response to MSG_SMS_MRC_SHUTDOWN_SLAVE_REQ 
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_MRC_BRINGUP_SLAVE_REQ	= 832,	// Application: DVB-T MRC
> +											// Description: Return back the MRC slave to operation
> +											// Direction: Host-->FW
> +
> +	MSG_SMS_MRC_BRINGUP_SLAVE_RES	= 833,  // Application: DVB-T MRC
> +											// Description: response to MSG_SMS_MRC_BRINGUP_SLAVE_REQ 
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_EXTERNAL_LNA_CTRL_REQ   = 834,  // APPLICATION: DVB-T 
> +											// Description: request from driver to control external LNA
> +											// Direction: Host-->FW
> +
> +	MSG_SMS_EXTERNAL_LNA_CTRL_RES   = 835,  // APPLICATION: DVB-T 
> +											// Description: response to MSG_SMS_EXTERNAL_LNA_CTRL_REQ
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_SET_PERIODIC_STATISTICS_REQ		= 836,	// Application: CMMB
> +													// Description: Enable/Disable periodic statistics.
> +													// Format:	32 bit enable flag. 0 - Disable, 1- Enable 
> +													// Direction: Host-->FW
> +
> +	MSG_SMS_SET_PERIODIC_STATISTICS_RES		= 837,  // Application: CMMB
> +													// Description: response to
> MSG_SMS_SET_PERIODIC_STATISTICS_REQ 
> +													// Direction: FW-->Host
> +
> +	MSG_SMS_CMMB_SET_AUTO_OUTPUT_TS0_REQ	= 838,	// Application: CMMB
> +													// Description: Enable/Disable auto output of TS0
> +													// Format: 32 bit enable flag. 0 - Disable, 1- Enable 
> +													// Direction: Host-->FW
> +
> +	MSG_SMS_CMMB_SET_AUTO_OUTPUT_TS0_RES	= 839,  // Application: CMMB
> +													// Description: response to
> MSG_SMS_CMMB_SET_AUTO_OUTPUT_TS0_REQ 
> +													// Direction: FW-->Host
> +
> +	LOCAL_TUNE						= 850,	// Application: DVB-T (Internal)
> +											// Description: Internal message sent by the demod after
> tune/resync
> +											// Direction: FW-->FW	
> +
> +	LOCAL_IFFT_H_ICI				= 851,  // Application: DVB-T (Internal)
> +											// Direction: FW-->FW
> +
> +	MSG_RESYNC_REQ					= 852,	// Application: DVB-T (Internal)
> +											// Description: Internal resync request used by the MRC
> master
> +											// Direction: FW-->FW
> +
> +	MSG_SMS_CMMB_GET_MRC_STATISTICS_REQ		= 853,	// Application: CMMB
> (Internal)
> +													// Description: MRC statistics request (internal debug,
> not exposed to users)
> +                                                    // Format 
> +                                                    // 32-bit
> IsDemodLocked;			//!< 0 - not locked, 1 - locked
> +                                                    // 32-bit   SNR dB
> +                                                    // 32-bit   RSSI
> dBm
> +                                                    // 32-bit
> InBandPwr In band power in dBM
> +                                                    // 32-bit
> CarrierOffset Carrier Offset in Hz
> +													// Direction: Host-->FW
> +	MSG_SMS_CMMB_GET_MRC_STATISTICS_RES		= 854,	// Description: MRC
> statistics response (internal debug, not exposed to users)
> +													// Direction: FW-->Host
> +
> +	MSG_SMS_LOG_EX_ITEM				= 855,  // Application: All
> +											// Format:	32-bit - number of log messages
> +											//			followed by N  SMSHOSTLIB_LOG_ITEM_ST  
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_DEVICE_DATA_LOSS_IND	= 856,  // Application: LBS
> +											// Description: Indication on data loss on the device level
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_MRC_WATCHDOG_TRIGGERED_IND	= 857,  // 
> +
> +	MSG_SMS_USER_MSG_REQ			= 858,  // Application: All
> +											// Description: Data message for Data Cards internal 
> +											// Direction: Host-->Data card 
> +
> +	MSG_SMS_USER_MSG_RES			= 859,  // Application: All 
> +											// Data message response from Data card to host.
> +											// Direction: Data card-->Host
> +
> +	MSG_SMS_SMART_CARD_INIT_REQ		= 860, 	// ISO-7816 SmartCard access
> routines
> +	MSG_SMS_SMART_CARD_INIT_RES		= 861,  //
> +	MSG_SMS_SMART_CARD_WRITE_REQ	= 862,  //
> +	MSG_SMS_SMART_CARD_WRITE_RES	= 863,  //
> +	MSG_SMS_SMART_CARD_READ_IND		= 864,  //
> +
> +	MSG_SMS_TSE_ENABLE_REQ			= 866,	// Application: DVB-T/ISDB-T 
> +											// Description: Send this command in case the Host wants to
> handle TS with Error Bit enable
> +											// Direction: Host-->FW
> +
> +	MSG_SMS_TSE_ENABLE_RES			= 867,	// Application: DVB-T/ISDB-T 
> +											// Description: Response to MSG_SMS_TSE_ENABLE_REQ 
> +											// Direction: FW-->Host
> +
> +	MSG_SMS_CMMB_GET_SHORT_STATISTICS_REQ	= 868,  // Application: CMMB
> +													// Description: Short statistics for CMRI standard.
> +													// Direction: Host-->FW
> +													// supported only in Venice
> +
> +	MSG_SMS_CMMB_GET_SHORT_STATISTICS_RES	= 869,  // Description: Short
> statistics response
> +													// Format: SMSHOSTLIB_CMMB_SHORT_STATISTICS_ST
> +													// (No return code).
> +
> +	MSG_SMS_LED_CONFIG_REQ			= 870,	// Application: DVB-T/ISDB-T
> +											// Description: uses for LED reception indication
> +											// Format: Data[0] = u32 GPIO number
> +											// Direction: Host-->FW
> +
> +	MSG_SMS_LED_CONFIG_RES			= 871,	// Application: DVB-T/ISDB-T
> +											// Description: Response to MSG_SMS_LED_CONFIG_REQ
> +											// Direction: FW-->Host
> +
> +	// Chen Temp for PCTV PWM FOR ANTENNA
> +	MSG_PWM_ANTENNA_REQ				= 872,  // antenna array reception request
> +	MSG_PWM_ANTENNA_RES				= 873,  // antenna array reception response
> +	
> +	MSG_SMS_CMMB_SMD_SN_REQ			= 874,  // Application: CMMB
> +											// Description: Get SMD serial number
> +											// Direction: Host-->FW
> +											// supported only by SMD firmware 
> +
> +								
> +	MSG_SMS_CMMB_SMD_SN_RES			= 875,  // Application: CMMB
> +											// Description: Get SMD serial number response
> +											// Format: 
> +											// u32 RetCode
> +											// u8 SmdSerialNumber[SMS_CMMB_SMD_SN_LEN==8]
> +
> +	MSG_SMS_CMMB_SET_CA_CW_REQ		= 876,  // Application: CMMB
> +											// Description: Set current and next CA control words 
> +											//	for firmware descrambler
> +											// Format: SMSHOSTLIB_CA_CW_PAIR_ST
> +
> +	MSG_SMS_CMMB_SET_CA_CW_RES		= 877,  // Application: CMMB
> +											// Description: Set control words response
> +											// Format: u32 RetCode
> +
> +	MSG_SMS_CMMB_SET_CA_SALT_REQ	= 878,  // Application: CMMB
> +											// Description: Set Set CA salt key for 
> +											// firmware descrambler
> +											// Format: SMSHOSTLIB_CA_SALT_ST
> +	MSG_SMS_CMMB_SET_CA_SALT_RES	= 879,	// Application: CMMB
> +											// Description: Set salt keys response
> +											// Format: u32 RetCode
> +	
> +	MSG_SMS_NSCD_INIT_REQ			= 880, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_NSCD_INIT_RES			= 881, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_NSCD_PROCESS_SECTION_REQ= 882, //NSCD injector(Internal debug
> fw versions only)
> +	MSG_SMS_NSCD_PROCESS_SECTION_RES= 883, //NSCD injector(Internal debug
> fw versions only)
> +	MSG_SMS_DBD_CREATE_OBJECT_REQ	= 884, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_DBD_CREATE_OBJECT_RES	= 885, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_DBD_CONFIGURE_REQ		= 886, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_DBD_CONFIGURE_RES		= 887, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_DBD_SET_KEYS_REQ		= 888, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_DBD_SET_KEYS_RES		= 889, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_DBD_PROCESS_HEADER_REQ	= 890, //NSCD injector(Internal debug
> fw versions only)
> +	MSG_SMS_DBD_PROCESS_HEADER_RES	= 891, //NSCD injector(Internal debug
> fw versions only)
> +	MSG_SMS_DBD_PROCESS_DATA_REQ	= 892, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_DBD_PROCESS_DATA_RES	= 893, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_DBD_PROCESS_GET_DATA_REQ= 894, //NSCD injector(Internal debug
> fw versions only)
> +	MSG_SMS_DBD_PROCESS_GET_DATA_RES= 895, //NSCD injector(Internal debug
> fw versions only) 
> +
> +
> +	MSG_SMS_NSCD_OPEN_SESSION_REQ	= 896, //NSCD injector(Internal debug fw
> versions only)
> +	MSG_SMS_NSCD_OPEN_SESSION_RES	= 897, //NSCD injector(Internal debug fw
> versions only)
> +
> +    MSG_SMS_SEND_HOST_DATA_TO_DEMUX_REQ		= 898, // CMMB Data to Demux
> injector (Internal debug fw versions only)
> +    MSG_SMS_SEND_HOST_DATA_TO_DEMUX_RES		= 899, // CMMB Data to Demux
> injector (Internal debug fw versions only)
> +
> +	MSG_LAST_MSG_TYPE				= 900  // Note: Stellar ROM limits this number to
> 700, other chip sets to 900
> +
> +
> +}MsgTypes_ET;
> +
> +typedef struct SMSHOSTLIB_VERSIONING_S
> +{
> +	u8			Major;
> +	u8			Minor;
> +	u8			Patch;
> +	u8			FieldPatch;
> +} SMSHOSTLIB_VERSIONING_ST;
> +
> +typedef struct SMSHOSTLIB_VERSION_S
> +{
> +	u16				ChipModel;		//!< e.g. 0x1102 for SMS-1102 "Nova"
> +	u8				Step;			//!< 0 - Step A
> +	u8				MetalFix;		//!< 0 - Metal 0
> +	u8				FirmwareId;		//!< 0xFF - ROM or see #SMSHOSTLIB_DEVICE_MODES_E
> +	u8				SupportedProtocols;	/*!< Bitwise OR combination of supported
> protocols, see #SMSHOSTLIB_DEVICE_MODES_E */
> +	SMSHOSTLIB_VERSIONING_ST	FwVer;			//!< Firmware version
> +	SMSHOSTLIB_VERSIONING_ST	RomVer;			//!< ROM version
> +	u8				TextLabel[34];		//!< Text label
> +	SMSHOSTLIB_VERSIONING_ST	RFVer;			//!< RF tuner version
> +	u32				PkgVer;                 //!< SMS11xx Package Version
> +	u32				Reserved[9];            //!< Reserved for future use
> +}SMSHOSTLIB_VERSION_ST;

You should take a look at the Kernel developer's readme files found at Documentation.

In particular, structure fields should follow this syntax:
	Documentation/kernel-doc-nano-HOWTO.txt

> +
> +typedef struct SmsVersionRes_S
> +{
> +	SmsMsgHdr_ST				xMsgHeader;
> +	SMSHOSTLIB_VERSION_ST			xVersion;
> +} SmsVersionRes_ST;
> +
> +
> +//! DVBT Statistics
> +
> +#define	SRVM_MAX_PID_FILTERS							8
> +
> +typedef struct RECEPTION_STATISTICS_S
> +{
> +	u32 IsRfLocked;				//!< 0 - not locked, 1 - locked
> +	u32 IsDemodLocked;			//!< 0 - not locked, 1 - locked
> +	u32 IsExternalLNAOn;			//!< 0 - external LNA off, 1 - external LNA on
> +
> +	u32 ModemState;				//!< from SMSHOSTLIB_DVB_MODEM_STATE_ET
> +	s32  SNR;						//!< dB
> +	u32 BER;						//!< Post Viterbi BER [1E-5]
> +	u32 BERErrorCount;			//!< Number of erroneous SYNC bits.
> +	u32 BERBitCount;				//!< Total number of SYNC bits.
> +	u32 TS_PER;					//!< Transport stream PER, 0xFFFFFFFF indicate N/A
> +	u32 MFER;					//!< DVB-H frame error rate in percentage, 0xFFFFFFFF
> indicate N/A, valid only for DVB-H
> +	s32  RSSI;					//!< dBm
> +	s32  InBandPwr;				//!< In band power in dBM
> +	s32  CarrierOffset;			//!< Carrier Offset in bin/1024
> +	u32 ErrorTSPackets;			//!< Number of erroneous transport-stream
> packets
> +	u32 TotalTSPackets;			//!< Total number of transport-stream packets
> +
> +	s32  RefDevPPM;
> +	s32  FreqDevHz;
> +
> +	s32  MRC_SNR;					//!< dB
> +	s32  MRC_RSSI;				//!< dBm
> +	s32  MRC_InBandPwr;			//!< In band power in dBM
> +
> +}RECEPTION_STATISTICS_ST;
> +
> +typedef struct TRANSMISSION_STATISTICS_S
> +{
> +	u32 Frequency;				//!< Frequency in Hz
> +	u32 Bandwidth;				//!< Bandwidth in MHz
> +	u32 TransmissionMode;		//!< FFT mode carriers in Kilos
> +	u32 GuardInterval;			//!< Guard Interval from
> SMSHOSTLIB_GUARD_INTERVALS_ET
> +	u32 CodeRate;				//!< Code Rate from SMSHOSTLIB_CODE_RATE_ET
> +	u32 LPCodeRate;				//!< Low Priority Code Rate from
> SMSHOSTLIB_CODE_RATE_ET
> +	u32 Hierarchy;				//!< Hierarchy from SMSHOSTLIB_HIERARCHY_ET
> +	u32 Constellation;			//!< Constellation from
> SMSHOSTLIB_CONSTELLATION_ET
> +
> +	// DVB-H TPS parameters
> +	u32 CellId;					//!< TPS Cell ID in bits 15..0, bits 31..16 zero; if
> set to 0xFFFFFFFF cell_id not yet recovered
> +	u32 DvbhSrvIndHP;			//!< DVB-H service indication info, bit 1 - Time
> Slicing indicator, bit 0 - MPE-FEC indicator
> +	u32 DvbhSrvIndLP;			//!< DVB-H service indication info, bit 1 - Time
> Slicing indicator, bit 0 - MPE-FEC indicator
> +	u32 IsDemodLocked;			//!< 0 - not locked, 1 - locked
> +
> +}TRANSMISSION_STATISTICS_ST;
> +
> +
> +typedef struct PID_STATISTICS_DATA_S
> +{
> +	struct PID_BURST_S
> +	{
> +		u32	size;
> +		u32	padding_cols;
> +		u32	punct_cols;
> +		u32	duration;
> +		u32	cycle;
> +		u32	calc_cycle;
> +	} burst;
> +
> +	u32	tot_tbl_cnt;
> +	u32	invalid_tbl_cnt;
> +	u32  tot_cor_tbl;
> +
> +} PID_STATISTICS_DATA_ST;
> +
> +
> +typedef struct PID_DATA_S
> +{
> +	u32 pid;
> +	u32 num_rows;
> +	PID_STATISTICS_DATA_ST pid_statistics;
> +
> +}PID_DATA_ST;
> +
> +
> +// Statistics information returned as response for
> SmsHostApiGetStatisticsEx_Req for DVB applications, SMS1100 and up
> +typedef struct SMSHOSTLIB_STATISTICS_DVB_S
> +{
> +	// Reception
> +	RECEPTION_STATISTICS_ST ReceptionData;
> +
> +	// Transmission parameters
> +	TRANSMISSION_STATISTICS_ST TransmissionData;
> +
> +	// Burst parameters, valid only for DVB-H
> +	PID_DATA_ST PidData[SRVM_MAX_PID_FILTERS];
> +
> +} SMSHOSTLIB_STATISTICS_DVB_ST;
> +
> +
> +// Helper struct for ISDB-T statistics
> +typedef struct SMSHOSTLIB_ISDBT_LAYER_STAT_S
> +{
> +	// Per-layer information
> +	u32 CodeRate;			//!< Code Rate from SMSHOSTLIB_CODE_RATE_ET, 255 means
> layer does not exist
> +	u32 Constellation;		//!< Constellation from
> SMSHOSTLIB_CONSTELLATION_ET, 255 means layer does not exist
> +	u32 BER;					//!< Post Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A
> +	u32 BERErrorCount;		//!< Post Viterbi Error Bits Count
> +	u32 BERBitCount;			//!< Post Viterbi Total Bits Count
> +	u32 PreBER; 				//!< Pre Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A
> +	u32 TS_PER;				//!< Transport stream PER [%], 0xFFFFFFFF indicate N/A
> +	u32 ErrorTSPackets;		//!< Number of erroneous transport-stream packets
> +	u32 TotalTSPackets;		//!< Total number of transport-stream packets
> +	u32 TILdepthI;			//!< Time interleaver depth I parameter, 255 means
> layer does not exist
> +	u32 NumberOfSegments;	//!< Number of segments in layer A, 255 means
> layer does not exist
> +	u32 TMCCErrors;			//!< TMCC errors
> +} SMSHOSTLIB_ISDBT_LAYER_STAT_ST;
> +
> +// Statistics information returned as response for
> SmsHostApiGetStatisticsEx_Req for ISDB-T applications, SMS1100 and up
> +typedef struct SMSHOSTLIB_STATISTICS_ISDBT_S
> +{
> +	u32 StatisticsType;			//!< Enumerator identifying the type of the
> structure.  Values are the same as SMSHOSTLIB_DEVICE_MODES_E
> +	//!< This field MUST always first in any statistics structure
> +
> +	u32 FullSize;				//!< Total size of the structure returned by the
> modem.  If the size requested by
> +	//!< the host is smaller than FullSize, the struct will be truncated
> +
> +	// Common parameters
> +	u32 IsRfLocked;				//!< 0 - not locked, 1 - locked
> +	u32 IsDemodLocked;			//!< 0 - not locked, 1 - locked
> +	u32 IsExternalLNAOn;			//!< 0 - external LNA off, 1 - external LNA on
> +
> +	// Reception quality
> +	s32  SNR;						//!< dB
> +	s32  RSSI;					//!< dBm
> +	s32  InBandPwr;				//!< In band power in dBM
> +	s32  CarrierOffset;			//!< Carrier Offset in Hz
> +
> +	// Transmission parameters
> +	u32 Frequency;				//!< Frequency in Hz
> +	u32 Bandwidth;				//!< Bandwidth in MHz
> +	u32 TransmissionMode;		//!< ISDB-T transmission mode
> +	u32 ModemState;				//!< 0 - Acquisition, 1 - Locked
> +	u32 GuardInterval;			//!< Guard Interval, 1 divided by value
> +	u32 SystemType;				//!< ISDB-T system type (ISDB-T / ISDB-Tsb)
> +	u32 PartialReception;		//!< TRUE - partial reception, FALSE otherwise
> +	u32 NumOfLayers;				//!< Number of ISDB-T layers in the network
> +	u32 SegmentNumber;			//!< Segment number for ISDB-Tsb
> +	u32 TuneBW;					//!< Tuned bandwidth - BW_ISDBT_1SEG / BW_ISDBT_3SEG
> +
> +	// Per-layer information
> +	// Layers A, B and C
> +	SMSHOSTLIB_ISDBT_LAYER_STAT_ST	LayerInfo[3];	//!< Per-layer
> statistics, see SMSHOSTLIB_ISDBT_LAYER_STAT_ST
> +
> +	// Interface information
> +	u32 Reserved1;				// Was SmsToHostTxErrors - obsolete .
> +
> +	// Proprietary information	
> +	u32 ExtAntenna;				// Obsolete field.
> +
> +	u32 ReceptionQuality;
> +
> +	// EWS
> +	u32 EwsAlertActive;			//!< Signals if EWS alert is currently on
> +
> +	// LNA on/off					//!< Internal LNA state: 0: OFF, 1: ON
> +	u32 LNAOnOff;
> +	
> +	// RF AGC Level					// !< RF AGC level [linear units], full gain =
> 65535 (20dB)
> +	u32 RfAgcLevel;
> +
> +	// BB AGC Level
> +	u32 BbAgcLevel;				// !< Baseband AGC level [linear units], full gain
> = 65535 (71.5dB)
> +
> +	u32 FwErrorsCounter;			// !< FW Application errors - should be always
> zero
> +	u8 FwErrorsHistoryArr[8];	// !< Last FW errors IDs - first is most
> recent, last is oldest
> +									// !< This field was ExtAntenna, and was not used
> +	s32  MRC_SNR;					// !< dB
> +	u32 SNRFullRes;				// !< dB x 65536
> +	u32 Reserved4[4];			
> +
> +} SMSHOSTLIB_STATISTICS_ISDBT_ST;
> +
> +
> +/************************************************************************/
> +/* Defines, types and structures for siano core device driver		*/
> +/************************************************************************/
> +
> +#define SMS_MAX_PAYLOAD_SIZE		240
> +
> +typedef struct SmsDataDownload_S
> +{
> +	SmsMsgHdr_ST		xMsgHeader;
> +	u32			MemAddr;
> +	u32			Payload[SMS_MAX_PAYLOAD_SIZE/4];
> +} SmsDataDownload_ST;
> +
> +
>  #define kmutex_init(_p_) mutex_init(_p_)
>  #define kmutex_lock(_p_) mutex_lock(_p_)
>  #define kmutex_trylock(_p_) mutex_trylock(_p_)
> @@ -62,25 +1451,104 @@ along with this program.  If not, see
> <http://www.gnu.org/licenses/>.
>  #define SMS_ALIGN_ADDRESS(addr) \
>  	((((uintptr_t)(addr)) + (SMS_DMA_ALIGNMENT-1)) &
> ~(SMS_DMA_ALIGNMENT-1))
>  
> +#define SMS_DEVICE_FAMILY1				0
>  #define SMS_DEVICE_FAMILY2				1
>  #define SMS_ROM_NO_RESPONSE				2
>  #define SMS_DEVICE_NOT_READY				0x8000000
>  
> +#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) &&
> defined(MODULE))
> +#define REQUEST_FIRMWARE_SUPPORTED
> +#else
> +#define DEFAULT_FW_FILE_PATH "/lib/firmware"
> +#endif

NACK. Firmware load should always use request_firmware().

> +
> +#define DVBT_BDA_CONTROL_MSG_ID				201
> +
> +struct smscore_gpio_config {
> +#define SMS_GPIO_DIRECTION_INPUT  0
> +#define SMS_GPIO_DIRECTION_OUTPUT 1
> +	u8 direction;
> +
> +#define SMS_GPIO_PULLUPDOWN_NONE     0
> +#define SMS_GPIO_PULLUPDOWN_PULLDOWN 1
> +#define SMS_GPIO_PULLUPDOWN_PULLUP   2
> +#define SMS_GPIO_PULLUPDOWN_KEEPER   3
> +	u8 pull_up_down;
> +
> +#define SMS_GPIO_INPUTCHARACTERISTICS_NORMAL  0
> +#define SMS_GPIO_INPUTCHARACTERISTICS_SCHMITT 1
> +	u8 input_characteristics;
> +
> +#define SMS_GPIO_OUTPUTSLEWRATE_SLOW		0 /* 10xx */
> +#define SMS_GPIO_OUTPUTSLEWRATE_FAST		1 /* 10xx */
> +
> +#define SMS_GPIO_OUTPUTSLEWRATE_0_45_V_NS	0 /* 11xx */
> +#define SMS_GPIO_OUTPUTSLEWRATE_0_9_V_NS	1 /* 11xx */
> +#define SMS_GPIO_OUTPUTSLEWRATE_1_7_V_NS	2 /* 11xx */
> +#define SMS_GPIO_OUTPUTSLEWRATE_3_3_V_NS	3 /* 11xx */
> +	u8 output_slew_rate;
> +
> +#define SMS_GPIO_OUTPUTDRIVING_S_4mA		0 /* 10xx */
> +#define SMS_GPIO_OUTPUTDRIVING_S_8mA		1 /* 10xx */
> +#define SMS_GPIO_OUTPUTDRIVING_S_12mA		2 /* 10xx */
> +#define SMS_GPIO_OUTPUTDRIVING_S_16mA		3 /* 10xx */
> +
> +#define SMS_GPIO_OUTPUTDRIVING_1_5mA		0 /* 11xx */
> +#define SMS_GPIO_OUTPUTDRIVING_2_8mA		1 /* 11xx */
> +#define SMS_GPIO_OUTPUTDRIVING_4mA			2 /* 11xx */
> +#define SMS_GPIO_OUTPUTDRIVING_7mA			3 /* 11xx */
> +#define SMS_GPIO_OUTPUTDRIVING_10mA			4 /* 11xx */
> +#define SMS_GPIO_OUTPUTDRIVING_11mA			5 /* 11xx */
> +#define SMS_GPIO_OUTPUTDRIVING_14mA			6 /* 11xx */
> +#define SMS_GPIO_OUTPUTDRIVING_16mA			7 /* 11xx */
> +	u8 output_driving;
> +};
> +
> +#define SMS_INIT_MSG_EX(ptr, type, src, dst, len)  \
> +	(ptr)->msgType = type; (ptr)->msgSrcId = src; (ptr)->msgDstId = dst; \
> +	(ptr)->msgLength = len; (ptr)->msgFlags = 0; 
> +
> +#define SMS_INIT_MSG(ptr, type, len) \
> +	SMS_INIT_MSG_EX(ptr, type, 0, HIF_TASK, len)
> +
> +
> +struct SmsFirmware_ST {
> +	u32 CheckSum;
> +	u32 Length;
> +	u32 StartAddress;
> +	u8 Payload[1];
> +};
> +
> +
>  enum sms_device_type_st {
> +	SMS_UNKNOWN_TYPE = -1,
>  	SMS_STELLAR = 0,
>  	SMS_NOVA_A0,
>  	SMS_NOVA_B0,
>  	SMS_VEGA,
> +	SMS_VENICE,
> +	SMS_MING,
> +	SMS_PELE,
> +	SMS_RIO,
> +	SMS_DENVER_1530,
> +	SMS_DENVER_2160,
>  	SMS_NUM_OF_DEVICE_TYPES
>  };
>  
> +enum sms_power_mode_st {
> +	SMS_POWER_MODE_ACTIVE,
> +	SMS_POWER_MODE_SUSPENDED
> +};
> +
>  struct smscore_device_t;
>  struct smscore_client_t;
>  struct smscore_buffer_t;
>  
> -typedef int (*hotplug_t)(struct smscore_device_t *coredev,
> +typedef int (*hotplug_t)(void *coredev,
>  			 struct device *device, int arrival);
>  
> +typedef int (*powermode_t)(enum sms_power_mode_st mode);
> +
>  typedef int (*setmode_t)(void *context, int mode);
>  typedef void (*detectmode_t)(void *context, int *mode);
>  typedef int (*sendrequest_t)(void *context, void *buffer, size_t size);
> @@ -91,6 +1559,12 @@ typedef int (*postload_t)(void *context);
>  typedef int (*onresponse_t)(void *context, struct smscore_buffer_t
> *cb);
>  typedef void (*onremove_t)(void *context);
>  
> +struct smsmdtv_version_t {
> +	int major;
> +	int minor;
> +	int revision;
> +};
> +
>  struct smscore_buffer_t {
>  	/* public members, once passed to clients can be changed freely */
>  	struct list_head entry;
> @@ -104,30 +1578,30 @@ struct smscore_buffer_t {
>  };
>  
>  struct smsdevice_params_t {
> -	struct device	*device;
> +	struct device *device;
>  
> -	int				buffer_size;
> -	int				num_buffers;
> +	int buffer_size;
> +	int num_buffers;
>  
> -	char			devpath[32];
> -	unsigned long	flags;
> +	char devpath[32];
> +	unsigned long flags;
>  
> -	setmode_t		setmode_handler;
> -	detectmode_t	detectmode_handler;
> -	sendrequest_t	sendrequest_handler;
> -	preload_t		preload_handler;
> -	postload_t		postload_handler;
> +	setmode_t setmode_handler;
> +	detectmode_t detectmode_handler;
> +	sendrequest_t sendrequest_handler;
> +	preload_t preload_handler;
> +	postload_t postload_handler;
>  
> -	void			*context;
> +	void *context;
>  	enum sms_device_type_st device_type;
>  };
>  
>  struct smsclient_params_t {
> -	int				initial_id;
> -	int				data_type;
> -	onresponse_t	onresponse_handler;
> -	onremove_t		onremove_handler;
> -	void			*context;
> +	int initial_id;
> +	int data_type;
> +	onresponse_t onresponse_handler;
> +	onremove_t onremove_handler;
> +	void *context;
>  };
>  
>  struct smscore_device_t {
> @@ -160,8 +1634,8 @@ struct smscore_device_t {
>  	int mode, modes_supported;
>  
>  	/* host <--> device messages */
> -	struct completion version_ex_done, data_download_done, trigger_done;
> -	struct completion init_device_done, reload_start_done, resume_done;
> +	struct completion version_ex_done, data_download_done,
> data_validity_done, trigger_done;
> +	struct completion init_device_done, reload_start_done, resume_done,
> device_ready_done;
>  	struct completion gpio_configuration_done, gpio_set_level_done;
>  	struct completion gpio_get_level_done, ir_init_done;
>  
> @@ -177,531 +1651,16 @@ struct smscore_device_t {
>  	/* Firmware */
>  	u8 *fw_buf;
>  	u32 fw_buf_size;
> +	u32 start_address;
> +	u32 current_address;
>  
>  	/* Infrared (IR) */
> +#ifdef SMS_RC_SUPPORT_SUBSYS
>  	struct ir_t ir;
> -
> +#endif
>  	int led_state;
>  };
>  
> -/* GPIO definitions for antenna frequency domain control (SMS8021) */
> -#define SMS_ANTENNA_GPIO_0					1
> -#define SMS_ANTENNA_GPIO_1					0
> -
> -#define BW_8_MHZ							0
> -#define BW_7_MHZ							1
> -#define BW_6_MHZ							2
> -#define BW_5_MHZ							3
> -#define BW_ISDBT_1SEG						4
> -#define BW_ISDBT_3SEG						5
> -
> -#define MSG_HDR_FLAG_SPLIT_MSG				4
> -
> -#define MAX_GPIO_PIN_NUMBER					31
> -
> -#define HIF_TASK							11
> -#define SMS_HOST_LIB						150
> -#define DVBT_BDA_CONTROL_MSG_ID				201
> -
> -#define SMS_MAX_PAYLOAD_SIZE				240
> -#define SMS_TUNE_TIMEOUT					500
> -
> -#define MSG_SMS_GPIO_CONFIG_REQ				507
> -#define MSG_SMS_GPIO_CONFIG_RES				508
> -#define MSG_SMS_GPIO_SET_LEVEL_REQ			509
> -#define MSG_SMS_GPIO_SET_LEVEL_RES			510
> -#define MSG_SMS_GPIO_GET_LEVEL_REQ			511
> -#define MSG_SMS_GPIO_GET_LEVEL_RES			512
> -#define MSG_SMS_RF_TUNE_REQ					561
> -#define MSG_SMS_RF_TUNE_RES					562
> -#define MSG_SMS_INIT_DEVICE_REQ				578
> -#define MSG_SMS_INIT_DEVICE_RES				579
> -#define MSG_SMS_ADD_PID_FILTER_REQ			601
> -#define MSG_SMS_ADD_PID_FILTER_RES			602
> -#define MSG_SMS_REMOVE_PID_FILTER_REQ			603
> -#define MSG_SMS_REMOVE_PID_FILTER_RES			604
> -#define MSG_SMS_DAB_CHANNEL				607
> -#define MSG_SMS_GET_PID_FILTER_LIST_REQ			608
> -#define MSG_SMS_GET_PID_FILTER_LIST_RES			609
> -#define MSG_SMS_GET_STATISTICS_RES			616
> -#define MSG_SMS_GET_STATISTICS_REQ			615
> -#define MSG_SMS_HO_PER_SLICES_IND			630
> -#define MSG_SMS_SET_ANTENNA_CONFIG_REQ			651
> -#define MSG_SMS_SET_ANTENNA_CONFIG_RES			652
> -#define MSG_SMS_SLEEP_RESUME_COMP_IND			655
> -#define MSG_SMS_DATA_DOWNLOAD_REQ			660
> -#define MSG_SMS_DATA_DOWNLOAD_RES			661
> -#define MSG_SMS_SWDOWNLOAD_TRIGGER_REQ		664
> -#define MSG_SMS_SWDOWNLOAD_TRIGGER_RES		665
> -#define MSG_SMS_SWDOWNLOAD_BACKDOOR_REQ		666
> -#define MSG_SMS_SWDOWNLOAD_BACKDOOR_RES		667
> -#define MSG_SMS_GET_VERSION_EX_REQ			668
> -#define MSG_SMS_GET_VERSION_EX_RES			669
> -#define MSG_SMS_SET_CLOCK_OUTPUT_REQ		670
> -#define MSG_SMS_I2C_SET_FREQ_REQ			685
> -#define MSG_SMS_GENERIC_I2C_REQ				687
> -#define MSG_SMS_GENERIC_I2C_RES				688
> -#define MSG_SMS_DVBT_BDA_DATA				693
> -#define MSG_SW_RELOAD_REQ					697
> -#define MSG_SMS_DATA_MSG					699
> -#define MSG_SW_RELOAD_START_REQ				702
> -#define MSG_SW_RELOAD_START_RES				703
> -#define MSG_SW_RELOAD_EXEC_REQ				704
> -#define MSG_SW_RELOAD_EXEC_RES				705
> -#define MSG_SMS_SPI_INT_LINE_SET_REQ		710
> -#define MSG_SMS_GPIO_CONFIG_EX_REQ			712
> -#define MSG_SMS_GPIO_CONFIG_EX_RES			713
> -#define MSG_SMS_ISDBT_TUNE_REQ				776
> -#define MSG_SMS_ISDBT_TUNE_RES				777
> -#define MSG_SMS_TRANSMISSION_IND			782
> -#define MSG_SMS_START_IR_REQ				800
> -#define MSG_SMS_START_IR_RES				801
> -#define MSG_SMS_IR_SAMPLES_IND				802
> -#define MSG_SMS_SIGNAL_DETECTED_IND			827
> -#define MSG_SMS_NO_SIGNAL_IND				828
> -
> -#define SMS_INIT_MSG_EX(ptr, type, src, dst, len) do { \
> -	(ptr)->msgType = type; (ptr)->msgSrcId = src; (ptr)->msgDstId = dst; \
> -	(ptr)->msgLength = len; (ptr)->msgFlags = 0; \
> -} while (0)
> -
> -#define SMS_INIT_MSG(ptr, type, len) \
> -	SMS_INIT_MSG_EX(ptr, type, 0, HIF_TASK, len)
> -
> -enum SMS_DVB3_EVENTS {
> -	DVB3_EVENT_INIT = 0,
> -	DVB3_EVENT_SLEEP,
> -	DVB3_EVENT_HOTPLUG,
> -	DVB3_EVENT_FE_LOCK,
> -	DVB3_EVENT_FE_UNLOCK,
> -	DVB3_EVENT_UNC_OK,
> -	DVB3_EVENT_UNC_ERR
> -};
> -
> -enum SMS_DEVICE_MODE {
> -	DEVICE_MODE_NONE = -1,
> -	DEVICE_MODE_DVBT = 0,
> -	DEVICE_MODE_DVBH,
> -	DEVICE_MODE_DAB_TDMB,
> -	DEVICE_MODE_DAB_TDMB_DABIP,
> -	DEVICE_MODE_DVBT_BDA,
> -	DEVICE_MODE_ISDBT,
> -	DEVICE_MODE_ISDBT_BDA,
> -	DEVICE_MODE_CMMB,
> -	DEVICE_MODE_RAW_TUNER,
> -	DEVICE_MODE_MAX,
> -};
> -
> -struct SmsMsgHdr_ST {
> -	u16	msgType;
> -	u8	msgSrcId;
> -	u8	msgDstId;
> -	u16	msgLength; /* Length of entire message, including header */
> -	u16	msgFlags;
> -};
> -
> -struct SmsMsgData_ST {
> -	struct SmsMsgHdr_ST xMsgHeader;
> -	u32 msgData[1];
> -};
> -
> -struct SmsMsgData_ST2 {
> -	struct SmsMsgHdr_ST xMsgHeader;
> -	u32 msgData[2];
> -};
> -
> -struct SmsDataDownload_ST {
> -	struct SmsMsgHdr_ST	xMsgHeader;
> -	u32			MemAddr;
> -	u8			Payload[SMS_MAX_PAYLOAD_SIZE];
> -};
> -
> -struct SmsVersionRes_ST {
> -	struct SmsMsgHdr_ST	xMsgHeader;
> -
> -	u16		ChipModel; /* e.g. 0x1102 for SMS-1102 "Nova" */
> -	u8		Step; /* 0 - Step A */
> -	u8		MetalFix; /* 0 - Metal 0 */
> -
> -	/* FirmwareId 0xFF if ROM, otherwise the
> -	 * value indicated by SMSHOSTLIB_DEVICE_MODES_E */
> -	u8 FirmwareId;
> -	/* SupportedProtocols Bitwise OR combination of
> -					     * supported protocols */
> -	u8 SupportedProtocols;
> -
> -	u8		VersionMajor;
> -	u8		VersionMinor;
> -	u8		VersionPatch;
> -	u8		VersionFieldPatch;
> -
> -	u8		RomVersionMajor;
> -	u8		RomVersionMinor;
> -	u8		RomVersionPatch;
> -	u8		RomVersionFieldPatch;
> -
> -	u8		TextLabel[34];
> -};
> -
> -struct SmsFirmware_ST {
> -	u32			CheckSum;
> -	u32			Length;
> -	u32			StartAddress;
> -	u8			Payload[1];
> -};
> -
> -/* Statistics information returned as response for
> - * SmsHostApiGetStatistics_Req */
> -struct SMSHOSTLIB_STATISTICS_ST {
> -	u32 Reserved;		/* Reserved */
> -
> -	/* Common parameters */
> -	u32 IsRfLocked;		/* 0 - not locked, 1 - locked */
> -	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
> -	u32 IsExternalLNAOn;	/* 0 - external LNA off, 1 - external LNA on */
> -
> -	/* Reception quality */
> -	s32 SNR;		/* dB */
> -	u32 BER;		/* Post Viterbi BER [1E-5] */
> -	u32 FIB_CRC;		/* CRC errors percentage, valid only for DAB */
> -	u32 TS_PER;		/* Transport stream PER,
> -	0xFFFFFFFF indicate N/A, valid only for DVB-T/H */
> -	u32 MFER;		/* DVB-H frame error rate in percentage,
> -	0xFFFFFFFF indicate N/A, valid only for DVB-H */
> -	s32 RSSI;		/* dBm */
> -	s32 InBandPwr;		/* In band power in dBM */
> -	s32 CarrierOffset;	/* Carrier Offset in bin/1024 */
> -
> -	/* Transmission parameters */
> -	u32 Frequency;		/* Frequency in Hz */
> -	u32 Bandwidth;		/* Bandwidth in MHz, valid only for DVB-T/H */
> -	u32 TransmissionMode;	/* Transmission Mode, for DAB modes 1-4,
> -	for DVB-T/H FFT mode carriers in Kilos */
> -	u32 ModemState;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET,
> -	valid only for DVB-T/H */
> -	u32 GuardInterval;	/* Guard Interval from
> -	SMSHOSTLIB_GUARD_INTERVALS_ET, 	valid only for DVB-T/H */
> -	u32 CodeRate;		/* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
> -	valid only for DVB-T/H */
> -	u32 LPCodeRate;		/* Low Priority Code Rate from
> -	SMSHOSTLIB_CODE_RATE_ET, valid only for DVB-T/H */
> -	u32 Hierarchy;		/* Hierarchy from SMSHOSTLIB_HIERARCHY_ET,
> -	valid only for DVB-T/H */
> -	u32 Constellation;	/* Constellation from
> -	SMSHOSTLIB_CONSTELLATION_ET, valid only for DVB-T/H */
> -
> -	/* Burst parameters, valid only for DVB-H */
> -	u32 BurstSize;		/* Current burst size in bytes,
> -	valid only for DVB-H */
> -	u32 BurstDuration;	/* Current burst duration in mSec,
> -	valid only for DVB-H */
> -	u32 BurstCycleTime;	/* Current burst cycle time in mSec,
> -	valid only for DVB-H */
> -	u32 CalculatedBurstCycleTime;/* Current burst cycle time in mSec,
> -	as calculated by demodulator, valid only for DVB-H */
> -	u32 NumOfRows;		/* Number of rows in MPE table,
> -	valid only for DVB-H */
> -	u32 NumOfPaddCols;	/* Number of padding columns in MPE table,
> -	valid only for DVB-H */
> -	u32 NumOfPunctCols;	/* Number of puncturing columns in MPE table,
> -	valid only for DVB-H */
> -	u32 ErrorTSPackets;	/* Number of erroneous
> -	transport-stream packets */
> -	u32 TotalTSPackets;	/* Total number of transport-stream packets */
> -	u32 NumOfValidMpeTlbs;	/* Number of MPE tables which do not include
> -	errors after MPE RS decoding */
> -	u32 NumOfInvalidMpeTlbs;/* Number of MPE tables which include errors
> -	after MPE RS decoding */
> -	u32 NumOfCorrectedMpeTlbs;/* Number of MPE tables which were
> -	corrected by MPE RS decoding */
> -	/* Common params */
> -	u32 BERErrorCount;	/* Number of errornous SYNC bits. */
> -	u32 BERBitCount;	/* Total number of SYNC bits. */
> -
> -	/* Interface information */
> -	u32 SmsToHostTxErrors;	/* Total number of transmission errors. */
> -
> -	/* DAB/T-DMB */
> -	u32 PreBER; 		/* DAB/T-DMB only: Pre Viterbi BER [1E-5] */
> -
> -	/* DVB-H TPS parameters */
> -	u32 CellId;		/* TPS Cell ID in bits 15..0, bits 31..16 zero;
> -	 if set to 0xFFFFFFFF cell_id not yet recovered */
> -	u32 DvbhSrvIndHP;	/* DVB-H service indication info, bit 1 -
> -	Time Slicing indicator, bit 0 - MPE-FEC indicator */
> -	u32 DvbhSrvIndLP;	/* DVB-H service indication info, bit 1 -
> -	Time Slicing indicator, bit 0 - MPE-FEC indicator */
> -
> -	u32 NumMPEReceived;	/* DVB-H, Num MPE section received */
> -
> -	u32 ReservedFields[10];	/* Reserved */
> -};
> -
> -struct SmsMsgStatisticsInfo_ST {
> -	u32 RequestResult;
> -
> -	struct SMSHOSTLIB_STATISTICS_ST Stat;
> -
> -	/* Split the calc of the SNR in DAB */
> -	u32 Signal; /* dB */
> -	u32 Noise; /* dB */
> -
> -};
> -
> -struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST {
> -	/* Per-layer information */
> -	u32 CodeRate; /* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
> -		       * 255 means layer does not exist */
> -	u32 Constellation; /* Constellation from SMSHOSTLIB_CONSTELLATION_ET,
> -			    * 255 means layer does not exist */
> -	u32 BER; /* Post Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
> -	u32 BERErrorCount; /* Post Viterbi Error Bits Count */
> -	u32 BERBitCount; /* Post Viterbi Total Bits Count */
> -	u32 PreBER; /* Pre Viterbi BER [1E-5], 0xFFFFFFFF indicate N/A */
> -	u32 TS_PER; /* Transport stream PER [%], 0xFFFFFFFF indicate N/A */
> -	u32 ErrorTSPackets; /* Number of erroneous transport-stream packets */
> -	u32 TotalTSPackets; /* Total number of transport-stream packets */
> -	u32 TILdepthI; /* Time interleaver depth I parameter,
> -			* 255 means layer does not exist */
> -	u32 NumberOfSegments; /* Number of segments in layer A,
> -			       * 255 means layer does not exist */
> -	u32 TMCCErrors; /* TMCC errors */
> -};
> -
> -struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
> -	u32 StatisticsType; /* Enumerator identifying the type of the
> -				* structure.  Values are the same as
> -				* SMSHOSTLIB_DEVICE_MODES_E
> -				*
> -				* This field MUST always be first in any
> -				* statistics structure */
> -
> -	u32 FullSize; /* Total size of the structure returned by the modem.
> -		       * If the size requested by the host is smaller than
> -		       * FullSize, the struct will be truncated */
> -
> -	/* Common parameters */
> -	u32 IsRfLocked; /* 0 - not locked, 1 - locked */
> -	u32 IsDemodLocked; /* 0 - not locked, 1 - locked */
> -	u32 IsExternalLNAOn; /* 0 - external LNA off, 1 - external LNA on */
> -
> -	/* Reception quality */
> -	s32  SNR; /* dB */
> -	s32  RSSI; /* dBm */
> -	s32  InBandPwr; /* In band power in dBM */
> -	s32  CarrierOffset; /* Carrier Offset in Hz */
> -
> -	/* Transmission parameters */
> -	u32 Frequency; /* Frequency in Hz */
> -	u32 Bandwidth; /* Bandwidth in MHz */
> -	u32 TransmissionMode; /* ISDB-T transmission mode */
> -	u32 ModemState; /* 0 - Acquisition, 1 - Locked */
> -	u32 GuardInterval; /* Guard Interval, 1 divided by value */
> -	u32 SystemType; /* ISDB-T system type (ISDB-T / ISDB-Tsb) */
> -	u32 PartialReception; /* TRUE - partial reception, FALSE otherwise */
> -	u32 NumOfLayers; /* Number of ISDB-T layers in the network */
> -
> -	/* Per-layer information */
> -	/* Layers A, B and C */
> -	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST	LayerInfo[3];
> -	/* Per-layer statistics, see SMSHOSTLIB_ISDBT_LAYER_STAT_ST */
> -
> -	/* Interface information */
> -	u32 SmsToHostTxErrors; /* Total number of transmission errors. */
> -};
> -
> -struct PID_STATISTICS_DATA_S {
> -	struct PID_BURST_S {
> -		u32 size;
> -		u32 padding_cols;
> -		u32 punct_cols;
> -		u32 duration;
> -		u32 cycle;
> -		u32 calc_cycle;
> -	} burst;
> -
> -	u32 tot_tbl_cnt;
> -	u32 invalid_tbl_cnt;
> -	u32 tot_cor_tbl;
> -};
> -
> -struct PID_DATA_S {
> -	u32 pid;
> -	u32 num_rows;
> -	struct PID_STATISTICS_DATA_S pid_statistics;
> -};
> -
> -#define CORRECT_STAT_RSSI(_stat) ((_stat).RSSI *= -1)
> -#define CORRECT_STAT_BANDWIDTH(_stat) (_stat.Bandwidth = 8 -
> _stat.Bandwidth)
> -#define CORRECT_STAT_TRANSMISSON_MODE(_stat) \
> -	if (_stat.TransmissionMode == 0) \
> -		_stat.TransmissionMode = 2; \
> -	else if (_stat.TransmissionMode == 1) \
> -		_stat.TransmissionMode = 8; \
> -		else \
> -			_stat.TransmissionMode = 4;
> -
> -struct TRANSMISSION_STATISTICS_S {
> -	u32 Frequency;		/* Frequency in Hz */
> -	u32 Bandwidth;		/* Bandwidth in MHz */
> -	u32 TransmissionMode;	/* FFT mode carriers in Kilos */
> -	u32 GuardInterval;	/* Guard Interval from
> -	SMSHOSTLIB_GUARD_INTERVALS_ET */
> -	u32 CodeRate;		/* Code Rate from SMSHOSTLIB_CODE_RATE_ET */
> -	u32 LPCodeRate;		/* Low Priority Code Rate from
> -	SMSHOSTLIB_CODE_RATE_ET */
> -	u32 Hierarchy;		/* Hierarchy from SMSHOSTLIB_HIERARCHY_ET */
> -	u32 Constellation;	/* Constellation from
> -	SMSHOSTLIB_CONSTELLATION_ET */
> -
> -	/* DVB-H TPS parameters */
> -	u32 CellId;		/* TPS Cell ID in bits 15..0, bits 31..16 zero;
> -	 if set to 0xFFFFFFFF cell_id not yet recovered */
> -	u32 DvbhSrvIndHP;	/* DVB-H service indication info, bit 1 -
> -	 Time Slicing indicator, bit 0 - MPE-FEC indicator */
> -	u32 DvbhSrvIndLP;	/* DVB-H service indication info, bit 1 -
> -	 Time Slicing indicator, bit 0 - MPE-FEC indicator */
> -	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
> -};
> -
> -struct RECEPTION_STATISTICS_S {
> -	u32 IsRfLocked;		/* 0 - not locked, 1 - locked */
> -	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
> -	u32 IsExternalLNAOn;	/* 0 - external LNA off, 1 - external LNA on */
> -
> -	u32 ModemState;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
> -	s32 SNR;		/* dB */
> -	u32 BER;		/* Post Viterbi BER [1E-5] */
> -	u32 BERErrorCount;	/* Number of erronous SYNC bits. */
> -	u32 BERBitCount;	/* Total number of SYNC bits. */
> -	u32 TS_PER;		/* Transport stream PER,
> -	0xFFFFFFFF indicate N/A */
> -	u32 MFER;		/* DVB-H frame error rate in percentage,
> -	0xFFFFFFFF indicate N/A, valid only for DVB-H */
> -	s32 RSSI;		/* dBm */
> -	s32 InBandPwr;		/* In band power in dBM */
> -	s32 CarrierOffset;	/* Carrier Offset in bin/1024 */
> -	u32 ErrorTSPackets;	/* Number of erroneous
> -	transport-stream packets */
> -	u32 TotalTSPackets;	/* Total number of transport-stream packets */
> -
> -	s32 MRC_SNR;		/* dB */
> -	s32 MRC_RSSI;		/* dBm */
> -	s32 MRC_InBandPwr;	/* In band power in dBM */
> -};
> -
> -
> -/* Statistics information returned as response for
> - * SmsHostApiGetStatisticsEx_Req for DVB applications, SMS1100 and up
> */
> -struct SMSHOSTLIB_STATISTICS_DVB_S {
> -	/* Reception */
> -	struct RECEPTION_STATISTICS_S ReceptionData;
> -
> -	/* Transmission parameters */
> -	struct TRANSMISSION_STATISTICS_S TransmissionData;
> -
> -	/* Burst parameters, valid only for DVB-H */
> -#define	SRVM_MAX_PID_FILTERS 8
> -	struct PID_DATA_S PidData[SRVM_MAX_PID_FILTERS];
> -};
> -
> -struct SRVM_SIGNAL_STATUS_S {
> -	u32 result;
> -	u32 snr;
> -	u32 tsPackets;
> -	u32 etsPackets;
> -	u32 constellation;
> -	u32 hpCode;
> -	u32 tpsSrvIndLP;
> -	u32 tpsSrvIndHP;
> -	u32 cellId;
> -	u32 reason;
> -
> -	s32 inBandPower;
> -	u32 requestId;
> -};
> -
> -struct SMSHOSTLIB_I2C_REQ_ST {
> -	u32	DeviceAddress; /* I2c device address */
> -	u32	WriteCount; /* number of bytes to write */
> -	u32	ReadCount; /* number of bytes to read */
> -	u8	Data[1];
> -};
> -
> -struct SMSHOSTLIB_I2C_RES_ST {
> -	u32	Status; /* non-zero value in case of failure */
> -	u32	ReadCount; /* number of bytes read */
> -	u8	Data[1];
> -};
> -
> -
> -struct smscore_config_gpio {
> -#define SMS_GPIO_DIRECTION_INPUT  0
> -#define SMS_GPIO_DIRECTION_OUTPUT 1
> -	u8 direction;
> -
> -#define SMS_GPIO_PULLUPDOWN_NONE     0
> -#define SMS_GPIO_PULLUPDOWN_PULLDOWN 1
> -#define SMS_GPIO_PULLUPDOWN_PULLUP   2
> -#define SMS_GPIO_PULLUPDOWN_KEEPER   3
> -	u8 pullupdown;
> -
> -#define SMS_GPIO_INPUTCHARACTERISTICS_NORMAL  0
> -#define SMS_GPIO_INPUTCHARACTERISTICS_SCHMITT 1
> -	u8 inputcharacteristics;
> -
> -#define SMS_GPIO_OUTPUTSLEWRATE_FAST 0
> -#define SMS_GPIO_OUTPUTSLEWRATE_SLOW 1
> -	u8 outputslewrate;
> -
> -#define SMS_GPIO_OUTPUTDRIVING_4mA  0
> -#define SMS_GPIO_OUTPUTDRIVING_8mA  1
> -#define SMS_GPIO_OUTPUTDRIVING_12mA 2
> -#define SMS_GPIO_OUTPUTDRIVING_16mA 3
> -	u8 outputdriving;
> -};
> -
> -struct smscore_gpio_config {
> -#define SMS_GPIO_DIRECTION_INPUT  0
> -#define SMS_GPIO_DIRECTION_OUTPUT 1
> -	u8 Direction;
> -
> -#define SMS_GPIO_PULL_UP_DOWN_NONE     0
> -#define SMS_GPIO_PULL_UP_DOWN_PULLDOWN 1
> -#define SMS_GPIO_PULL_UP_DOWN_PULLUP   2
> -#define SMS_GPIO_PULL_UP_DOWN_KEEPER   3
> -	u8 PullUpDown;
> -
> -#define SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL  0
> -#define SMS_GPIO_INPUT_CHARACTERISTICS_SCHMITT 1
> -	u8 InputCharacteristics;
> -
> -#define SMS_GPIO_OUTPUT_SLEW_RATE_SLOW		1 /* 10xx */
> -#define SMS_GPIO_OUTPUT_SLEW_RATE_FAST		0 /* 10xx */
> -
> -
> -#define SMS_GPIO_OUTPUT_SLEW_RATE_0_45_V_NS	0 /* 11xx */
> -#define SMS_GPIO_OUTPUT_SLEW_RATE_0_9_V_NS	1 /* 11xx */
> -#define SMS_GPIO_OUTPUT_SLEW_RATE_1_7_V_NS	2 /* 11xx */
> -#define SMS_GPIO_OUTPUT_SLEW_RATE_3_3_V_NS	3 /* 11xx */
> -	u8 OutputSlewRate;
> -
> -#define SMS_GPIO_OUTPUT_DRIVING_S_4mA		0 /* 10xx */
> -#define SMS_GPIO_OUTPUT_DRIVING_S_8mA		1 /* 10xx */
> -#define SMS_GPIO_OUTPUT_DRIVING_S_12mA		2 /* 10xx */
> -#define SMS_GPIO_OUTPUT_DRIVING_S_16mA		3 /* 10xx */
> -
> -#define SMS_GPIO_OUTPUT_DRIVING_1_5mA		0 /* 11xx */
> -#define SMS_GPIO_OUTPUT_DRIVING_2_8mA		1 /* 11xx */
> -#define SMS_GPIO_OUTPUT_DRIVING_4mA		2 /* 11xx */
> -#define SMS_GPIO_OUTPUT_DRIVING_7mA		3 /* 11xx */
> -#define SMS_GPIO_OUTPUT_DRIVING_10mA		4 /* 11xx */
> -#define SMS_GPIO_OUTPUT_DRIVING_11mA		5 /* 11xx */
> -#define SMS_GPIO_OUTPUT_DRIVING_14mA		6 /* 11xx */
> -#define SMS_GPIO_OUTPUT_DRIVING_16mA		7 /* 11xx */
> -	u8 OutputDriving;
> -};
> -
>  extern void smscore_registry_setmode(char *devpath, int mode);
>  extern int smscore_registry_getmode(char *devpath);
>  
> @@ -709,61 +1668,123 @@ extern int smscore_register_hotplug(hotplug_t
> hotplug);
>  extern void smscore_unregister_hotplug(hotplug_t hotplug);
>  
>  extern int smscore_register_device(struct smsdevice_params_t *params,
> -				   struct smscore_device_t **coredev);
> +		struct smscore_device_t **coredev);
>  extern void smscore_unregister_device(struct smscore_device_t
> *coredev);
>  
>  extern int smscore_start_device(struct smscore_device_t *coredev);
>  extern int smscore_load_firmware(struct smscore_device_t *coredev,
> -				 char *filename,
> -				 loadfirmware_t loadfirmware_handler);
> +		char *filename, loadfirmware_t loadfirmware_handler);
>  
>  extern int smscore_set_device_mode(struct smscore_device_t *coredev,
> int mode);
>  extern int smscore_get_device_mode(struct smscore_device_t *coredev);
>  
> +extern int smscore_configure_board(struct smscore_device_t *coredev);
> +
> +extern int smscore_register_client(struct smscore_device_t *coredev,
> +		struct smsclient_params_t *params,
> +		struct smscore_client_t **client);
> +extern void smscore_unregister_client(struct smscore_client_t *client);
> +
> +extern int smsclient_sendrequest(struct smscore_client_t *client, void
> *buffer,
> +		size_t size);
> +extern void smscore_onresponse(struct smscore_device_t *coredev,
> +		struct smscore_buffer_t *cb);
> +
> +
> +extern int smscore_get_common_buffer_size(struct smscore_device_t
> *coredev);
> +extern int smscore_map_common_buffer(struct smscore_device_t *coredev,
> +		struct vm_area_struct *vma);
> +extern char *smscore_get_fw_filename(struct smscore_device_t *coredev,
> int mode, int lookup);
> +
> +extern int smscore_send_fw_file(struct smscore_device_t *coredev, u8
> *ufwbuf,
> +		int size);
> +
> +extern int smscore_send_fw_chunk(struct smscore_device_t *coredev,
> +		void *buffer, size_t size);
> +extern int smscore_send_last_fw_chunk(struct smscore_device_t *coredev,
> +		void *buffer, size_t size);
> +		
>  extern int smscore_register_client(struct smscore_device_t *coredev,
> -				    struct smsclient_params_t *params,
> -				    struct smscore_client_t **client);
> +		struct smsclient_params_t *params,
> +		struct smscore_client_t **client);
>  extern void smscore_unregister_client(struct smscore_client_t *client);
>  
> -extern int smsclient_sendrequest(struct smscore_client_t *client,
> -				 void *buffer, size_t size);
> +extern int smsclient_sendrequest(struct smscore_client_t *client, void
> *buffer,
> +		size_t size);
> +
> +extern int smscore_register_device(struct smsdevice_params_t *params,
> +		struct smscore_device_t **coredev);
> +
>  extern void smscore_onresponse(struct smscore_device_t *coredev,
>  			       struct smscore_buffer_t *cb);
>  
>  extern int smscore_get_common_buffer_size(struct smscore_device_t
> *coredev);
>  extern int smscore_map_common_buffer(struct smscore_device_t *coredev,
>  				      struct vm_area_struct *vma);
> -extern int smscore_get_fw_filename(struct smscore_device_t *coredev,
> -				   int mode, char *filename);
>  extern int smscore_send_fw_file(struct smscore_device_t *coredev,
>  				u8 *ufwbuf, int size);
>  
> -extern
> -struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t
> *coredev);
> +extern struct smscore_buffer_t *smscore_getbuffer(
> +		struct smscore_device_t *coredev);
>  extern void smscore_putbuffer(struct smscore_device_t *coredev,
> -			      struct smscore_buffer_t *cb);
> -
> -/* old GPIO management */
> -int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
> -			   struct smscore_config_gpio *pinconfig);
> -int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int
> level);
> +		struct smscore_buffer_t *cb);
>  
> -/* new GPIO management */
> -extern int smscore_gpio_configure(struct smscore_device_t *coredev, u8
> PinNum,
> +int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
>  		struct smscore_gpio_config *pGpioConfig);
> -extern int smscore_gpio_set_level(struct smscore_device_t *coredev, u8
> PinNum,
> +int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
>  		u8 NewLevel);
> -extern int smscore_gpio_get_level(struct smscore_device_t *coredev, u8
> PinNum,
> +int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 PinNum,
>  		u8 *level);
>  
>  void smscore_set_board_id(struct smscore_device_t *core, int id);
>  int smscore_get_board_id(struct smscore_device_t *core);
> -
>  int smscore_led_state(struct smscore_device_t *core, int led);
>  
> +int smscore_set_power_mode(enum sms_power_mode_st mode);
> +
> +int smscore_register_power_mode_handler(powermode_t powermode_handler);
> +
> +int smscore_un_register_power_mode_handler(void);
> +
> +#ifdef SMS_HOSTLIB_SUBSYS
> +extern int smschar_register(void);
> +extern void smschar_unregister(void);
> +#endif
> +
> +#ifdef SMS_NET_SUBSYS
> +extern int smsnet_register(void);
> +extern void smsnet_unregister(void);
> +#endif
> +
> +#ifdef SMS_DVB3_SUBSYS
> +extern int smsdvb_register(void);
> +extern void smsdvb_unregister(void);
> +#endif
> +
> +#ifdef SMS_USB_DRV
> +extern int smsusb_register(void);
> +extern void smsusb_unregister(void);
> +#endif
> +
> +#ifdef SMS_SDIO_DRV
> +extern int smssdio_register(void);
> +extern void smssdio_unregister(void);
> +#endif
> +
> +#ifdef SMS_SPI_DRV
> +extern int smsspi_register(void);
> +extern void smsspi_unregister(void);
> +#endif
> +
> +#ifdef SMS_I2C_DRV
> +extern int smsi2c_register(void);
> +extern void smsi2c_unregister(void);
> +#endif
>  
>  /*
> ------------------------------------------------------------------------
> */
>  
> +extern int sms_debug;
> +
>  #define DBG_INFO 1
>  #define DBG_ADV  2
>  
> @@ -771,7 +1792,7 @@ int smscore_led_state(struct smscore_device_t
> *core, int led);
>  	printk(kern "%s: " fmt "\n", __func__, ##arg)
>  
>  #define dprintk(kern, lvl, fmt, arg...) do {\
> -	if (sms_dbg & lvl) \
> +	if (sms_debug & lvl) \
>  		sms_printk(kern, fmt, ##arg); } while (0)
>  
>  #define sms_log(fmt, arg...) sms_printk(KERN_INFO, fmt, ##arg)
> diff --git a/drivers/media/dvb/siano/smsdvb.c
> b/drivers/media/dvb/siano/smsdvb.c
> index 37c594f..62dd37c 100644
> --- a/drivers/media/dvb/siano/smsdvb.c
> +++ b/drivers/media/dvb/siano/smsdvb.c
> @@ -52,11 +52,24 @@ struct smsdvb_client_t {
>  	/* todo: save freq/band instead whole struct */
>  	struct dvb_frontend_parameters fe_params;
>  
> -	struct SMSHOSTLIB_STATISTICS_DVB_S sms_stat_dvb;
> +	struct RECEPTION_STATISTICS_S reception_data;
>  	int event_fe_state;
>  	int event_unc_state;
>  };
>  
> +enum SMS_DVB3_EVENTS {
> +	DVB3_EVENT_INIT = 0,
> +	DVB3_EVENT_SLEEP,
> +	DVB3_EVENT_HOTPLUG,
> +	DVB3_EVENT_FE_LOCK,
> +	DVB3_EVENT_FE_UNLOCK,
> +	DVB3_EVENT_UNC_OK,
> +	DVB3_EVENT_UNC_ERR
> +};
> +
> +#define CORRECT_STAT_RSSI(_stat) (_stat).RSSI *= -1
> +
> +
>  static struct list_head g_smsdvb_clients;
>  static struct mutex g_smsdvb_clientslock;
>  
> @@ -119,131 +132,133 @@ static void sms_board_dvb3_event(struct
> smsdvb_client_t *client,
>  
>  
>  static void smsdvb_update_dvb_stats(struct RECEPTION_STATISTICS_S
> *pReceptionData,
> -				   struct SMSHOSTLIB_STATISTICS_ST *p)
> +				   struct SMSHOSTLIB_STATISTICS_DVB_S *p)
>  {
> -	if (sms_dbg & 2) {
> -		printk(KERN_DEBUG "Reserved = %d", p->Reserved);
> -		printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
> -		printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
> -		printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
> -		printk(KERN_DEBUG "SNR = %d", p->SNR);
> -		printk(KERN_DEBUG "BER = %d", p->BER);
> -		printk(KERN_DEBUG "FIB_CRC = %d", p->FIB_CRC);
> -		printk(KERN_DEBUG "TS_PER = %d", p->TS_PER);
> -		printk(KERN_DEBUG "MFER = %d", p->MFER);
> -		printk(KERN_DEBUG "RSSI = %d", p->RSSI);
> -		printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
> -		printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
> -		printk(KERN_DEBUG "Frequency = %d", p->Frequency);
> -		printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
> -		printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
> -		printk(KERN_DEBUG "ModemState = %d", p->ModemState);
> -		printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
> -		printk(KERN_DEBUG "CodeRate = %d", p->CodeRate);
> -		printk(KERN_DEBUG "LPCodeRate = %d", p->LPCodeRate);
> -		printk(KERN_DEBUG "Hierarchy = %d", p->Hierarchy);
> -		printk(KERN_DEBUG "Constellation = %d", p->Constellation);
> -		printk(KERN_DEBUG "BurstSize = %d", p->BurstSize);
> -		printk(KERN_DEBUG "BurstDuration = %d", p->BurstDuration);
> -		printk(KERN_DEBUG "BurstCycleTime = %d", p->BurstCycleTime);
> -		printk(KERN_DEBUG "CalculatedBurstCycleTime = %d",
> p->CalculatedBurstCycleTime);
> -		printk(KERN_DEBUG "NumOfRows = %d", p->NumOfRows);
> -		printk(KERN_DEBUG "NumOfPaddCols = %d", p->NumOfPaddCols);
> -		printk(KERN_DEBUG "NumOfPunctCols = %d", p->NumOfPunctCols);
> -		printk(KERN_DEBUG "ErrorTSPackets = %d", p->ErrorTSPackets);
> -		printk(KERN_DEBUG "TotalTSPackets = %d", p->TotalTSPackets);
> -		printk(KERN_DEBUG "NumOfValidMpeTlbs = %d", p->NumOfValidMpeTlbs);
> -		printk(KERN_DEBUG "NumOfInvalidMpeTlbs = %d",
> p->NumOfInvalidMpeTlbs);
> -		printk(KERN_DEBUG "NumOfCorrectedMpeTlbs = %d",
> p->NumOfCorrectedMpeTlbs);
> -		printk(KERN_DEBUG "BERErrorCount = %d", p->BERErrorCount);
> -		printk(KERN_DEBUG "BERBitCount = %d", p->BERBitCount);
> -		printk(KERN_DEBUG "SmsToHostTxErrors = %d", p->SmsToHostTxErrors);
> -		printk(KERN_DEBUG "PreBER = %d", p->PreBER);
> -		printk(KERN_DEBUG "CellId = %d", p->CellId);
> -		printk(KERN_DEBUG "DvbhSrvIndHP = %d", p->DvbhSrvIndHP);
> -		printk(KERN_DEBUG "DvbhSrvIndLP = %d", p->DvbhSrvIndLP);
> -		printk(KERN_DEBUG "NumMPEReceived = %d", p->NumMPEReceived);
> -	}
> +	sms_debug("IsRfLocked = %d", p->ReceptionData.IsRfLocked);
> +	sms_debug("IsDemodLocked = %d", p->ReceptionData.IsDemodLocked);
> +	sms_debug("IsExternalLNAOn = %d", p->ReceptionData.IsExternalLNAOn);
> +	sms_debug("SNR = %d", p->ReceptionData.SNR);
> +	sms_debug("BER = %d", p->ReceptionData.BER);
> +	sms_debug("TS_PER = %d", p->ReceptionData.TS_PER);
> +	sms_debug("MFER = %d", p->ReceptionData.MFER);
> +	sms_debug("RSSI = %d", p->ReceptionData.RSSI);
> +	sms_debug("InBandPwr = %d", p->ReceptionData.InBandPwr);
> +	sms_debug("CarrierOffset = %d", p->ReceptionData.CarrierOffset);
> +	sms_debug("ModemState = %d", p->ReceptionData.ModemState);
> +	sms_debug("Frequency = %d", p->TransmissionData.Frequency);
> +	sms_debug("Bandwidth = %d", p->TransmissionData.Bandwidth);
> +	sms_debug("TransmissionMode = %d",
> p->TransmissionData.TransmissionMode);
> +	sms_debug("GuardInterval = %d", p->TransmissionData.GuardInterval);
> +	sms_debug("CodeRate = %d", p->TransmissionData.CodeRate);
> +	sms_debug("LPCodeRate = %d", p->TransmissionData.LPCodeRate);
> +	sms_debug("Hierarchy = %d", p->TransmissionData.Hierarchy);
> +	sms_debug("Constellation = %d", p->TransmissionData.Constellation);
> +
> +	/* update reception data */
> +	pReceptionData->IsRfLocked = p->ReceptionData.IsRfLocked;
> +	pReceptionData->IsDemodLocked = p->ReceptionData.IsDemodLocked;
> +	pReceptionData->IsExternalLNAOn = p->ReceptionData.IsExternalLNAOn;
> +	pReceptionData->ModemState = p->ReceptionData.ModemState;
> +	pReceptionData->SNR = p->ReceptionData.SNR;
> +	pReceptionData->BER = p->ReceptionData.BER;
> +	pReceptionData->BERErrorCount = p->ReceptionData.BERErrorCount;
> +	pReceptionData->BERBitCount = p->ReceptionData.BERBitCount;
> +	pReceptionData->RSSI = p->ReceptionData.RSSI;
> +	CORRECT_STAT_RSSI(*pReceptionData);
> +	pReceptionData->InBandPwr = p->ReceptionData.InBandPwr;
> +	pReceptionData->CarrierOffset = p->ReceptionData.CarrierOffset;
> +	pReceptionData->ErrorTSPackets = p->ReceptionData.ErrorTSPackets;
> +	pReceptionData->TotalTSPackets = p->ReceptionData.TotalTSPackets;
>  
> -	pReceptionData->IsDemodLocked = p->IsDemodLocked;
> -
> -	pReceptionData->SNR = p->SNR;
> -	pReceptionData->BER = p->BER;
> -	pReceptionData->BERErrorCount = p->BERErrorCount;
> -	pReceptionData->InBandPwr = p->InBandPwr;
> -	pReceptionData->ErrorTSPackets = p->ErrorTSPackets;
>  };
>  
>  
>  static void smsdvb_update_isdbt_stats(struct RECEPTION_STATISTICS_S
> *pReceptionData,
> -				    struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p)
> +				    struct SMSHOSTLIB_STATISTICS_ISDBT_S *p)
>  {
>  	int i;
> -
> -	if (sms_dbg & 2) {
> -		printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
> -		printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
> -		printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
> -		printk(KERN_DEBUG "SNR = %d", p->SNR);
> -		printk(KERN_DEBUG "RSSI = %d", p->RSSI);
> -		printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
> -		printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
> -		printk(KERN_DEBUG "Frequency = %d", p->Frequency);
> -		printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
> -		printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
> -		printk(KERN_DEBUG "ModemState = %d", p->ModemState);
> -		printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
> -		printk(KERN_DEBUG "SystemType = %d", p->SystemType);
> -		printk(KERN_DEBUG "PartialReception = %d", p->PartialReception);
> -		printk(KERN_DEBUG "NumOfLayers = %d", p->NumOfLayers);
> -		printk(KERN_DEBUG "SmsToHostTxErrors = %d", p->SmsToHostTxErrors);
> -
> -		for (i = 0; i < 3; i++) {
> -			printk(KERN_DEBUG "%d: CodeRate = %d", i, p->LayerInfo[i].CodeRate);
> -			printk(KERN_DEBUG "%d: Constellation = %d", i,
> p->LayerInfo[i].Constellation);
> -			printk(KERN_DEBUG "%d: BER = %d", i, p->LayerInfo[i].BER);
> -			printk(KERN_DEBUG "%d: BERErrorCount = %d", i,
> p->LayerInfo[i].BERErrorCount);
> -			printk(KERN_DEBUG "%d: BERBitCount = %d", i,
> p->LayerInfo[i].BERBitCount);
> -			printk(KERN_DEBUG "%d: PreBER = %d", i, p->LayerInfo[i].PreBER);
> -			printk(KERN_DEBUG "%d: TS_PER = %d", i, p->LayerInfo[i].TS_PER);
> -			printk(KERN_DEBUG "%d: ErrorTSPackets = %d", i,
> p->LayerInfo[i].ErrorTSPackets);
> -			printk(KERN_DEBUG "%d: TotalTSPackets = %d", i,
> p->LayerInfo[i].TotalTSPackets);
> -			printk(KERN_DEBUG "%d: TILdepthI = %d", i,
> p->LayerInfo[i].TILdepthI);
> -			printk(KERN_DEBUG "%d: NumberOfSegments = %d", i,
> p->LayerInfo[i].NumberOfSegments);
> -			printk(KERN_DEBUG "%d: TMCCErrors = %d", i,
> p->LayerInfo[i].TMCCErrors);
> -		}
> +	sms_debug("IsRfLocked = %d", p->IsRfLocked);
> +	sms_debug("IsDemodLocked = %d", p->IsDemodLocked);
> +	sms_debug("IsExternalLNAOn = %d", p->IsExternalLNAOn);
> +	sms_debug("SNR = %d", p->SNR);
> +	sms_debug("RSSI = %d", p->RSSI);
> +	sms_debug("InBandPwr = %d", p->InBandPwr);
> +	sms_debug("CarrierOffset = %d", p->CarrierOffset);
> +	sms_debug("Frequency = %d", p->Frequency);
> +	sms_debug("Bandwidth = %d", p->Bandwidth);
> +	sms_debug("TransmissionMode = %d", p->TransmissionMode);
> +	sms_debug("ModemState = %d", p->ModemState);
> +	sms_debug("GuardInterval = %d", p->GuardInterval);
> +	sms_debug("SystemType = %d", p->SystemType);
> +	sms_debug("PartialReception = %d", p->PartialReception);
> +	sms_debug("NumOfLayers = %d", p->NumOfLayers);
> +	sms_debug("SegmentNumber = %d", p->SegmentNumber);
> +	sms_debug("TuneBW = %d", p->TuneBW);
> +
> +	for (i = 0; i < p->NumOfLayers ; i++)
> +	{
> +		sms_debug("");
> +		sms_debug("Layer[%d].CodeRate = %d", i, p->LayerInfo[i].CodeRate);
> +		sms_debug("Layer[%d].Constellation = %d", i,
> p->LayerInfo[i].Constellation);
> +		sms_debug("Layer[%d].BER = %d", i, p->LayerInfo[i].BER);
> +		sms_debug("Layer[%d].BERErrorCount = %d", i,
> p->LayerInfo[i].BERErrorCount);
> +		sms_debug("Layer[%d].BERBitCount = %d", i,
> p->LayerInfo[i].BERBitCount);
> +		sms_debug("Layer[%d].PreBER = %d", i, p->LayerInfo[i].PreBER);
> +		sms_debug("Layer[%d].TS_PER = %d", i, p->LayerInfo[i].TS_PER);
> +		sms_debug("Layer[%d].ErrorTSPackets = %d", i,
> p->LayerInfo[i].ErrorTSPackets);
> +		sms_debug("Layer[%d].TotalTSPackets = %d", i,
> p->LayerInfo[i].TotalTSPackets);
> +		sms_debug("Layer[%d].TILdepthI = %d", i, p->LayerInfo[i].TILdepthI);
> +		sms_debug("Layer[%d].NumberOfSegments = %d", i,
> p->LayerInfo[i].NumberOfSegments);
> +		sms_debug("Layer[%d].TMCCErrors = %d", i,
> p->LayerInfo[i].TMCCErrors);
>  	}
>  
> -	pReceptionData->IsDemodLocked = p->IsDemodLocked;
>  
> +	/* update reception data */
> +	pReceptionData->IsRfLocked = p->IsRfLocked;
> +	pReceptionData->IsDemodLocked = p->IsDemodLocked;
> +	pReceptionData->IsExternalLNAOn = p->IsExternalLNAOn;
> +	pReceptionData->ModemState = p->ModemState;
>  	pReceptionData->SNR = p->SNR;
> +	pReceptionData->BER = p->LayerInfo[0].BER;
> +	pReceptionData->BERErrorCount = p->LayerInfo[0].BERErrorCount;
> +	pReceptionData->BERBitCount = p->LayerInfo[0].BERBitCount;
> +	pReceptionData->RSSI = p->RSSI;
> +	CORRECT_STAT_RSSI(*pReceptionData);
>  	pReceptionData->InBandPwr = p->InBandPwr;
> -
> -	pReceptionData->ErrorTSPackets = 0;
> -	pReceptionData->BER = 0;
> -	pReceptionData->BERErrorCount = 0;
> -	for (i = 0; i < 3; i++) {
> -		pReceptionData->BER += p->LayerInfo[i].BER;
> -		pReceptionData->BERErrorCount += p->LayerInfo[i].BERErrorCount;
> -		pReceptionData->ErrorTSPackets += p->LayerInfo[i].ErrorTSPackets;
> +	pReceptionData->CarrierOffset = p->CarrierOffset;
> +	pReceptionData->ErrorTSPackets = p->LayerInfo[0].ErrorTSPackets;
> +	pReceptionData->TotalTSPackets = p->LayerInfo[0].TotalTSPackets;
> +	pReceptionData->MFER = 0;
> +
> +
> +	/* TS PER */
> +	if ((p->LayerInfo[0].TotalTSPackets + 
> +		 p->LayerInfo[0].ErrorTSPackets) > 0) 
> +	{
> +		pReceptionData->TS_PER = (p->LayerInfo[0].ErrorTSPackets
> +				* 100) / (p->LayerInfo[0].TotalTSPackets
> +				+ p->LayerInfo[0].ErrorTSPackets);
> +	} else {
> +		pReceptionData->TS_PER = 0;
>  	}
> +
>  }
>  
>  static int smsdvb_onresponse(void *context, struct smscore_buffer_t
> *cb)
>  {
>  	struct smsdvb_client_t *client = (struct smsdvb_client_t *) context;
> -	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) (((u8 *) cb->p)
> +	struct SmsMsgHdr_S *phdr = (struct SmsMsgHdr_S *) (((u8 *) cb->p)
>  			+ cb->offset);
>  	u32 *pMsgData = (u32 *) phdr + 1;
> -	/*u32 MsgDataLen = phdr->msgLength - sizeof(struct SmsMsgHdr_ST);*/
> +	/*u32 MsgDataLen = phdr->msgLength - sizeof(struct SmsMsgHdr_S);*/
>  	bool is_status_update = false;
>  
> -	smsendian_handle_rx_message((struct SmsMsgData_ST *) phdr);
> +	smsendian_handle_rx_message((struct SmsMsgData_S *) phdr);
>  
>  	switch (phdr->msgType) {
>  	case MSG_SMS_DVBT_BDA_DATA:
>  		dvb_dmx_swfilter(&client->demux, (u8 *)(phdr + 1),
> -				 cb->size - sizeof(struct SmsMsgHdr_ST));
> +				 cb->size - sizeof(struct SmsMsgHdr_S));
>  		break;
>  
>  	case MSG_SMS_RF_TUNE_RES:
> @@ -253,58 +268,41 @@ static int smsdvb_onresponse(void *context, struct
> smscore_buffer_t *cb)
>  
>  	case MSG_SMS_SIGNAL_DETECTED_IND:
>  		sms_info("MSG_SMS_SIGNAL_DETECTED_IND");
> -		client->sms_stat_dvb.TransmissionData.IsDemodLocked = true;
> +		client->reception_data.IsDemodLocked = true;
>  		is_status_update = true;
>  		break;
>  
>  	case MSG_SMS_NO_SIGNAL_IND:
>  		sms_info("MSG_SMS_NO_SIGNAL_IND");
> -		client->sms_stat_dvb.TransmissionData.IsDemodLocked = false;
> +		client->reception_data.IsDemodLocked = false;
>  		is_status_update = true;
>  		break;
>  
>  	case MSG_SMS_TRANSMISSION_IND: {
> +		struct RECEPTION_STATISTICS_S *pReceptionData =
> +				&client->reception_data;
> +		struct TRANSMISSION_STATISTICS_S *pTrnsInd = 
> +				(struct TRANSMISSION_STATISTICS_S*)pMsgData;
>  		sms_info("MSG_SMS_TRANSMISSION_IND");
>  
> -		pMsgData++;
> -		memcpy(&client->sms_stat_dvb.TransmissionData, pMsgData,
> -				sizeof(struct TRANSMISSION_STATISTICS_S));
> -
> -		/* Mo need to correct guard interval
> -		 * (as opposed to old statistics message).
> -		 */
> -		CORRECT_STAT_BANDWIDTH(client->sms_stat_dvb.TransmissionData);
> -		CORRECT_STAT_TRANSMISSON_MODE(
> -				client->sms_stat_dvb.TransmissionData);
> +		/* update reception data */
> +		pReceptionData->IsDemodLocked = pTrnsInd->IsDemodLocked;
>  		is_status_update = true;
>  		break;
>  	}
>  	case MSG_SMS_HO_PER_SLICES_IND: {
>  		struct RECEPTION_STATISTICS_S *pReceptionData =
> -				&client->sms_stat_dvb.ReceptionData;
> -		struct SRVM_SIGNAL_STATUS_S SignalStatusData;
> +				&client->reception_data;
> +		sms_info("MSG_SMS_HO_PER_SLICES_IND");
>  
>  		/*sms_info("MSG_SMS_HO_PER_SLICES_IND");*/
> -		pMsgData++;
> -		SignalStatusData.result = pMsgData[0];
> -		SignalStatusData.snr = pMsgData[1];
> -		SignalStatusData.inBandPower = (s32) pMsgData[2];
> -		SignalStatusData.tsPackets = pMsgData[3];
> -		SignalStatusData.etsPackets = pMsgData[4];
> -		SignalStatusData.constellation = pMsgData[5];
> -		SignalStatusData.hpCode = pMsgData[6];
> -		SignalStatusData.tpsSrvIndLP = pMsgData[7] & 0x03;
> -		SignalStatusData.tpsSrvIndHP = pMsgData[8] & 0x03;
> -		SignalStatusData.cellId = pMsgData[9] & 0xFFFF;
> -		SignalStatusData.reason = pMsgData[10];
> -		SignalStatusData.requestId = pMsgData[11];
>  		pReceptionData->IsRfLocked = pMsgData[16];
>  		pReceptionData->IsDemodLocked = pMsgData[17];
>  		pReceptionData->ModemState = pMsgData[12];
>  		pReceptionData->SNR = pMsgData[1];
>  		pReceptionData->BER = pMsgData[13];
>  		pReceptionData->RSSI = pMsgData[14];
> -		CORRECT_STAT_RSSI(client->sms_stat_dvb.ReceptionData);
> +		CORRECT_STAT_RSSI(client->reception_data);
>  
>  		pReceptionData->InBandPwr = (s32) pMsgData[2];
>  		pReceptionData->CarrierOffset = (s32) pMsgData[15];
> @@ -312,11 +310,8 @@ static int smsdvb_onresponse(void *context, struct
> smscore_buffer_t *cb)
>  		pReceptionData->ErrorTSPackets = pMsgData[4];
>  
>  		/* TS PER */
> -		if ((SignalStatusData.tsPackets + SignalStatusData.etsPackets)
> -				> 0) {
> -			pReceptionData->TS_PER = (SignalStatusData.etsPackets
> -					* 100) / (SignalStatusData.tsPackets
> -					+ SignalStatusData.etsPackets);
> +		if ((pMsgData[3] + pMsgData[4])	> 0) {
> +			pReceptionData->TS_PER = (pMsgData[4] * 100) / (pMsgData[3] +
> pMsgData[4]);
>  		} else {
>  			pReceptionData->TS_PER = 0;
>  		}
> @@ -333,23 +328,23 @@ static int smsdvb_onresponse(void *context, struct
> smscore_buffer_t *cb)
>  	}
>  	case MSG_SMS_GET_STATISTICS_RES: {
>  		union {
> -			struct SMSHOSTLIB_STATISTICS_ISDBT_ST  isdbt;
> -			struct SmsMsgStatisticsInfo_ST         dvb;
> +			struct SMSHOSTLIB_STATISTICS_ISDBT_S  isdbt;
> +			struct SMSHOSTLIB_STATISTICS_DVB_S    dvb;
>  		} *p = (void *) (phdr + 1);
>  		struct RECEPTION_STATISTICS_S *pReceptionData =
> -				&client->sms_stat_dvb.ReceptionData;
> +				&client->reception_data;
>  
>  		sms_info("MSG_SMS_GET_STATISTICS_RES");
>  
>  		is_status_update = true;
>  
>  		switch (smscore_get_device_mode(client->coredev)) {
> -		case DEVICE_MODE_ISDBT:
> -		case DEVICE_MODE_ISDBT_BDA:
> +		case SMSHOSTLIB_DEVMD_ISDBT:
> +		case SMSHOSTLIB_DEVMD_ISDBT_BDA:
>  			smsdvb_update_isdbt_stats(pReceptionData, &p->isdbt);
>  			break;
>  		default:
> -			smsdvb_update_dvb_stats(pReceptionData, &p->dvb.Stat);
> +			smsdvb_update_dvb_stats(pReceptionData, &p->dvb);
>  		}
>  		if (!pReceptionData->IsDemodLocked) {
>  			pReceptionData->SNR = 0;
> @@ -369,11 +364,11 @@ static int smsdvb_onresponse(void *context, struct
> smscore_buffer_t *cb)
>  	smscore_putbuffer(client->coredev, cb);
>  
>  	if (is_status_update) {
> -		if (client->sms_stat_dvb.ReceptionData.IsDemodLocked) {
> +		if (client->reception_data.IsDemodLocked) {
>  			client->fe_status = FE_HAS_SIGNAL | FE_HAS_CARRIER
>  				| FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
>  			sms_board_dvb3_event(client, DVB3_EVENT_FE_LOCK);
> -			if (client->sms_stat_dvb.ReceptionData.ErrorTSPackets
> +			if (client->reception_data.ErrorTSPackets
>  					== 0)
>  				sms_board_dvb3_event(client, DVB3_EVENT_UNC_OK);
>  			else
> @@ -381,7 +376,7 @@ static int smsdvb_onresponse(void *context, struct
> smscore_buffer_t *cb)
>  						DVB3_EVENT_UNC_ERR);
>  
>  		} else {
> -			if (client->sms_stat_dvb.ReceptionData.IsRfLocked)
> +			if (client->reception_data.IsRfLocked)
>  				client->fe_status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
>  			else
>  				client->fe_status = 0;
> @@ -419,7 +414,7 @@ static int smsdvb_start_feed(struct dvb_demux_feed
> *feed)
>  {
>  	struct smsdvb_client_t *client =
>  		container_of(feed->demux, struct smsdvb_client_t, demux);
> -	struct SmsMsgData_ST PidMsg;
> +	struct SmsMsgData_S PidMsg;
>  
>  	sms_debug("add pid %d(%x)",
>  		  feed->pid, feed->pid);
> @@ -431,7 +426,7 @@ static int smsdvb_start_feed(struct dvb_demux_feed
> *feed)
>  	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
>  	PidMsg.msgData[0] = feed->pid;
>  
> -	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
> +	smsendian_handle_tx_message((struct SmsMsgHdr_S *)&PidMsg);
>  	return smsclient_sendrequest(client->smsclient,
>  				     &PidMsg, sizeof(PidMsg));
>  }
> @@ -440,7 +435,7 @@ static int smsdvb_stop_feed(struct dvb_demux_feed
> *feed)
>  {
>  	struct smsdvb_client_t *client =
>  		container_of(feed->demux, struct smsdvb_client_t, demux);
> -	struct SmsMsgData_ST PidMsg;
> +	struct SmsMsgData_S PidMsg;
>  
>  	sms_debug("remove pid %d(%x)",
>  		  feed->pid, feed->pid);
> @@ -452,7 +447,7 @@ static int smsdvb_stop_feed(struct dvb_demux_feed
> *feed)
>  	PidMsg.xMsgHeader.msgLength = sizeof(PidMsg);
>  	PidMsg.msgData[0] = feed->pid;
>  
> -	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&PidMsg);
> +	smsendian_handle_tx_message((struct SmsMsgHdr_S *)&PidMsg);
>  	return smsclient_sendrequest(client->smsclient,
>  				     &PidMsg, sizeof(PidMsg));
>  }
> @@ -463,7 +458,7 @@ static int smsdvb_sendrequest_and_wait(struct
> smsdvb_client_t *client,
>  {
>  	int rc;
>  
> -	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)buffer);
> +	smsendian_handle_tx_message((struct SmsMsgHdr_S *)buffer);
>  	rc = smsclient_sendrequest(client->smsclient, buffer, size);
>  	if (rc < 0)
>  		return rc;
> @@ -476,10 +471,10 @@ static int smsdvb_sendrequest_and_wait(struct
> smsdvb_client_t *client,
>  static int smsdvb_send_statistics_request(struct smsdvb_client_t
> *client)
>  {
>  	int rc;
> -	struct SmsMsgHdr_ST Msg = { MSG_SMS_GET_STATISTICS_REQ,
> +	struct SmsMsgHdr_S Msg = { MSG_SMS_GET_STATISTICS_REQ,
>  				    DVBT_BDA_CONTROL_MSG_ID,
>  				    HIF_TASK,
> -				    sizeof(struct SmsMsgHdr_ST), 0 };
> +				    sizeof(struct SmsMsgHdr_S), 0 };
>  
>  	rc = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
>  					  &client->tune_done);
> @@ -491,7 +486,7 @@ static inline int led_feedback(struct
> smsdvb_client_t *client)
>  {
>  	if (client->fe_status & FE_HAS_LOCK)
>  		return sms_board_led_feedback(client->coredev,
> -			(client->sms_stat_dvb.ReceptionData.BER
> +			(client->reception_data.BER
>  			== 0) ? SMS_LED_HI : SMS_LED_LO);
>  	else
>  		return sms_board_led_feedback(client->coredev, SMS_LED_OFF);
> @@ -520,7 +515,7 @@ static int smsdvb_read_ber(struct dvb_frontend *fe,
> u32 *ber)
>  
>  	rc = smsdvb_send_statistics_request(client);
>  
> -	*ber = client->sms_stat_dvb.ReceptionData.BER;
> +	*ber = client->reception_data.BER;
>  
>  	led_feedback(client);
>  
> @@ -536,13 +531,13 @@ static int smsdvb_read_signal_strength(struct
> dvb_frontend *fe, u16 *strength)
>  
>  	rc = smsdvb_send_statistics_request(client);
>  
> -	if (client->sms_stat_dvb.ReceptionData.InBandPwr < -95)
> +	if (client->reception_data.InBandPwr < -95)
>  		*strength = 0;
> -		else if (client->sms_stat_dvb.ReceptionData.InBandPwr > -29)
> +		else if (client->reception_data.InBandPwr > -29)
>  			*strength = 100;
>  		else
>  			*strength =
> -				(client->sms_stat_dvb.ReceptionData.InBandPwr
> +				(client->reception_data.InBandPwr
>  				+ 95) * 3 / 2;
>  
>  	led_feedback(client);
> @@ -558,7 +553,7 @@ static int smsdvb_read_snr(struct dvb_frontend *fe,
> u16 *snr)
>  
>  	rc = smsdvb_send_statistics_request(client);
>  
> -	*snr = client->sms_stat_dvb.ReceptionData.SNR;
> +	*snr = client->reception_data.SNR;
>  
>  	led_feedback(client);
>  
> @@ -573,7 +568,7 @@ static int smsdvb_read_ucblocks(struct dvb_frontend
> *fe, u32 *ucblocks)
>  
>  	rc = smsdvb_send_statistics_request(client);
>  
> -	*ucblocks = client->sms_stat_dvb.ReceptionData.ErrorTSPackets;
> +	*ucblocks = client->reception_data.ErrorTSPackets;
>  
>  	led_feedback(client);
>  
> @@ -598,10 +593,7 @@ static int smsdvb_dvbt_set_frontend(struct
> dvb_frontend *fe,
>  	struct smsdvb_client_t *client =
>  		container_of(fe, struct smsdvb_client_t, frontend);
>  
> -	struct {
> -		struct SmsMsgHdr_ST	Msg;
> -		u32		Data[3];
> -	} Msg;
> +	struct 	SmsMsgData3Args_S Msg;
>  
>  	int ret;
>  
> @@ -610,26 +602,26 @@ static int smsdvb_dvbt_set_frontend(struct
> dvb_frontend *fe,
>  	client->event_unc_state = -1;
>  	fe->dtv_property_cache.delivery_system = SYS_DVBT;
>  
> -	Msg.Msg.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
> -	Msg.Msg.msgDstId = HIF_TASK;
> -	Msg.Msg.msgFlags = 0;
> -	Msg.Msg.msgType = MSG_SMS_RF_TUNE_REQ;
> -	Msg.Msg.msgLength = sizeof(Msg);
> -	Msg.Data[0] = c->frequency;
> -	Msg.Data[2] = 12000000;
> +	Msg.xMsgHeader.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
> +	Msg.xMsgHeader.msgDstId = HIF_TASK;
> +	Msg.xMsgHeader.msgFlags = 0;
> +	Msg.xMsgHeader.msgType = MSG_SMS_RF_TUNE_REQ;
> +	Msg.xMsgHeader.msgLength = sizeof(Msg);
> +	Msg.msgData[0] = c->frequency;
> +	Msg.msgData[2] = 12000000;
>  
>  	sms_info("%s: freq %d band %d", __func__, c->frequency,
>  		 c->bandwidth_hz);
>  
>  	switch (c->bandwidth_hz / 1000000) {
>  	case 8:
> -		Msg.Data[1] = BW_8_MHZ;
> +		Msg.msgData[1] = BW_8_MHZ;
>  		break;
>  	case 7:
> -		Msg.Data[1] = BW_7_MHZ;
> +		Msg.msgData[1] = BW_7_MHZ;
>  		break;
>  	case 6:
> -		Msg.Data[1] = BW_6_MHZ;
> +		Msg.msgData[1] = BW_6_MHZ;
>  		break;
>  	case 0:
>  		return -EOPNOTSUPP;
> @@ -666,7 +658,7 @@ static int smsdvb_isdbt_set_frontend(struct
> dvb_frontend *fe,
>  		container_of(fe, struct smsdvb_client_t, frontend);
>  
>  	struct {
> -		struct SmsMsgHdr_ST	Msg;
> +		struct SmsMsgHdr_S	Msg;
>  		u32		Data[4];
>  	} Msg;
>  
> @@ -731,11 +723,11 @@ static int smsdvb_set_frontend(struct dvb_frontend
> *fe,
>  	struct smscore_device_t *coredev = client->coredev;
>  
>  	switch (smscore_get_device_mode(coredev)) {
> -	case DEVICE_MODE_DVBT:
> -	case DEVICE_MODE_DVBT_BDA:
> +	case SMSHOSTLIB_DEVMD_DVBT:
> +	case SMSHOSTLIB_DEVMD_DVBT_BDA:
>  		return smsdvb_dvbt_set_frontend(fe, fep);
> -	case DEVICE_MODE_ISDBT:
> -	case DEVICE_MODE_ISDBT_BDA:
> +	case SMSHOSTLIB_DEVMD_ISDBT:
> +	case SMSHOSTLIB_DEVMD_ISDBT_BDA:
>  		return smsdvb_isdbt_set_frontend(fe, fep);
>  	default:
>  		return -EINVAL;
> @@ -819,7 +811,7 @@ static struct dvb_frontend_ops smsdvb_fe_ops = {
>  	.sleep = smsdvb_sleep,
>  };
>  
> -static int smsdvb_hotplug(struct smscore_device_t *coredev,
> +static int smsdvb_hotplug(void *coredev,
>  			  struct device *device, int arrival)
>  {
>  	struct smsclient_params_t params;
> diff --git a/drivers/media/dvb/siano/smssdio.c
> b/drivers/media/dvb/siano/smssdio.c
> index e5705c3..9474eb5 100644
> --- a/drivers/media/dvb/siano/smssdio.c
> +++ b/drivers/media/dvb/siano/smssdio.c
> @@ -126,7 +126,7 @@ static void smssdio_interrupt(struct sdio_func
> *func)
>  
>  	struct smssdio_device *smsdev;
>  	struct smscore_buffer_t *cb;
> -	struct SmsMsgHdr_ST *hdr;
> +	struct SmsMsgHdr_S *hdr;
>  	size_t size;
>  
>  	smsdev = sdio_get_drvdata(func);
> @@ -172,7 +172,7 @@ static void smssdio_interrupt(struct sdio_func
> *func)
>  		cb = smsdev->split_cb;
>  		hdr = cb->p;
>  
> -		size = hdr->msgLength - sizeof(struct SmsMsgHdr_ST);
> +		size = hdr->msgLength - sizeof(struct SmsMsgHdr_S);
>  
>  		smsdev->split_cb = NULL;
>  	}
> diff --git a/drivers/media/dvb/siano/smsspidrv.c
> b/drivers/media/dvb/siano/smsspidrv.c
> index 3271e7c..964c5a4 100644
> --- a/drivers/media/dvb/siano/smsspidrv.c
> +++ b/drivers/media/dvb/siano/smsspidrv.c
> @@ -72,11 +72,6 @@ struct _smsspi_txmsg {
>  	void (*postwrite) (void *);
>  };
>  
> -struct _Msg {
> -	struct SmsMsgHdr_ST hdr;
> -	u32 data[3];
> -};
> -
>  struct _spi_device_st *spi_dev;
>  
>  int sms_dbg;
> @@ -217,10 +212,10 @@ static int smsspi_preload(void *context)
>  {
>  	struct _smsspi_txmsg msg;
>  	struct _spi_device_st *spi_device = (struct _spi_device_st *) context;
> -	struct _Msg Msg = {
> +	struct SmsMsgData3Args_S Msg = {
>  		{
>  		MSG_SMS_SPI_INT_LINE_SET_REQ, 0, HIF_TASK,
> -			sizeof(struct _Msg), 0}, {
> +			sizeof(struct SmsMsgData3Args_S), 0}, {
>  		0, sms_intr_pin, 0}
>  	};
>  	int rc;
> @@ -261,8 +256,8 @@ static int smsspi_postload(void *context)
>  {
>  	struct _spi_device_st *spi_device = (struct _spi_device_st *) context;
>  	int mode = smscore_registry_getmode(spi_device->coredev->devpath);
> -	if ( (mode != DEVICE_MODE_ISDBT) &&
> -	     (mode != DEVICE_MODE_ISDBT_BDA) ) {
> +	if ( (mode != SMSHOSTLIB_DEVMD_ISDBT) &&
> +	     (mode != SMSHOSTLIB_DEVMD_ISDBT_BDA) ) {
>  		fwDnlComplete(spi_device->phy_dev, 0);
>  		
>  	}
> diff --git a/drivers/media/dvb/siano/smsspiphy.c
> b/drivers/media/dvb/siano/smsspiphy.c
> index c8f1c28..1ffa260 100644
> --- a/drivers/media/dvb/siano/smsspiphy.c
> +++ b/drivers/media/dvb/siano/smsspiphy.c
> @@ -16,7 +16,6 @@
>  #define SPI_PACKET_SIZE 		256	
>  
>  int host_intr_pin = 135;
> -extern int sms_dbg;
>  
>  int spi_max_speed = MAX_SPEED_DURING_WORK;
>  
> @@ -162,7 +161,7 @@ void *smsspiphy_init(void *context, void
> (*smsspi_interruptHandler) (void *),
>  		.mode		= SPI_MODE_0,
>  	};
>  
> -	sms_err("sms_debug = %d\n", sms_dbg);
> +	sms_err("sms_debug = %d\n", sms_debug);
>  
>  	sms_device = spi_new_device(master, &sms_chip);	
>  	if (!sms_device)
> diff --git a/drivers/media/dvb/siano/smsusb.c
> b/drivers/media/dvb/siano/smsusb.c
> index 0b6857f..b1c38a2 100644
> --- a/drivers/media/dvb/siano/smsusb.c
> +++ b/drivers/media/dvb/siano/smsusb.c
> @@ -73,7 +73,7 @@ static void smsusb_onresponse(struct urb *urb)
>  	}
>  
>  	if ((urb->actual_length > 0) && (urb->status == 0)) {
> -		struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *)surb->cb->p;
> +		struct SmsMsgHdr_S *phdr = (struct SmsMsgHdr_S *)surb->cb->p;
>  
>  		smsendian_handle_message_header(phdr);
>  		if (urb->actual_length >= phdr->msgLength) {
> @@ -101,7 +101,7 @@ static void smsusb_onresponse(struct urb *urb)
>  				/* move buffer pointer and
>  				 * copy header to its new location */
>  				memcpy((char *) phdr + surb->cb->offset,
> -				       phdr, sizeof(struct SmsMsgHdr_ST));
> +				       phdr, sizeof(struct SmsMsgHdr_S));
>  			} else
>  				surb->cb->offset = 0;
>  
> @@ -182,7 +182,7 @@ static int smsusb_sendrequest(void *context, void
> *buffer, size_t size)
>  	struct smsusb_device_t *dev = (struct smsusb_device_t *) context;
>  	int dummy;
>  
> -	smsendian_handle_message_header((struct SmsMsgHdr_ST *)buffer);
> +	smsendian_handle_message_header((struct SmsMsgHdr_S *)buffer);
>  	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
>  			    buffer, size, &dummy, 1000);
>  }
> @@ -208,7 +208,7 @@ static int smsusb1_load_firmware(struct usb_device
> *udev, int id, int board_id)
>  	int rc, dummy;
>  	char *fw_filename;
>  
> -	if (id < DEVICE_MODE_DVBT || id > DEVICE_MODE_DVBT_BDA) {
> +	if (id < SMSHOSTLIB_DEVMD_DVBT || id > SMSHOSTLIB_DEVMD_DVBT_BDA) {
>  		sms_err("invalid firmware id specified %d", id);
>  		return -EINVAL;
>  	}
> @@ -256,7 +256,7 @@ static void smsusb1_detectmode(void *context, int
> *mode)
>  	char *product_string =
>  		((struct smsusb_device_t *) context)->udev->product;
>  
> -	*mode = DEVICE_MODE_NONE;
> +	*mode = SMSHOSTLIB_DEVMD_NONE;
>  
>  	if (!product_string) {
>  		product_string = "none";
> @@ -275,10 +275,10 @@ static void smsusb1_detectmode(void *context, int
> *mode)
>  
>  static int smsusb1_setmode(void *context, int mode)
>  {
> -	struct SmsMsgHdr_ST Msg = { MSG_SW_RELOAD_REQ, 0, HIF_TASK,
> -			     sizeof(struct SmsMsgHdr_ST), 0 };
> +	struct SmsMsgHdr_S Msg = { MSG_SW_RELOAD_REQ, 0, HIF_TASK,
> +			     sizeof(struct SmsMsgHdr_S), 0 };
>  
> -	if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_DVBT_BDA) {
> +	if (mode < SMSHOSTLIB_DEVMD_DVBT || mode > SMSHOSTLIB_DEVMD_DVBT_BDA)
> {
>  		sms_err("invalid firmware id specified %d", mode);
>  		return -EINVAL;
>  	}
> @@ -340,7 +340,7 @@ static int smsusb_init_device(struct usb_interface
> *intf, int board_id)
>  		dev->buffer_size = USB2_BUFFER_SIZE;
>  		dev->response_alignment =
>  		    le16_to_cpu(dev->udev->ep_in[1]->desc.wMaxPacketSize) -
> -		    sizeof(struct SmsMsgHdr_ST);
> +		    sizeof(struct SmsMsgHdr_S);
>  
>  		params.flags |= SMS_DEVICE_FAMILY2;
>  		break;

