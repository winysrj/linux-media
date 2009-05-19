Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:47170 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZESRG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 13:06:26 -0400
Received: by ewy24 with SMTP id 24so5027417ewy.37
        for <linux-media@vger.kernel.org>; Tue, 19 May 2009 10:06:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <737364.40564.qm@web110803.mail.gq1.yahoo.com>
References: <737364.40564.qm@web110803.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 13:06:25 -0400
Message-ID: <37219a840905191006q630a83fbocfa7deb32e12acb8@mail.gmail.com>
Subject: Re: [PATCH] [09051_58] Siano: remove obsolete code
From: Michael Krufky <mkrufky@linuxtv.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 19, 2009 at 12:54 PM, Uri Shkolnik <urishk@yahoo.com> wrote:
>
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1242752280 -10800
> # Node ID 0c33837206742f128aa033b2c9fb80c725e48dd7
> # Parent  fd16bcd8b9f1fffe0b605ca5b3b2138fc920e927
> [09051_58] Siano: remove obsolete code
>
> From: Uri Shkolnik <uris@siano-ms.com>
>
> Remove obsolete code - old gpio managment (totaly bogus),
> and its dependent code from cards.
>
> Priority: normal
>
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
>
> diff -r fd16bcd8b9f1 -r 0c3383720674 linux/drivers/media/dvb/siano/sms-cards.c
> --- a/linux/drivers/media/dvb/siano/sms-cards.c Tue May 19 19:50:24 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/sms-cards.c Tue May 19 19:58:00 2009 +0300
> @@ -66,24 +66,17 @@ static struct sms_board sms_boards[] = {
>                .board_cfg.leds_power = 26,
>                .board_cfg.led0 = 27,
>                .board_cfg.led1 = 28,
> -               .led_power = 26,
> -               .led_lo    = 27,
> -               .led_hi    = 28,
>        },
>        [SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD] = {
>                .name   = "Hauppauge WinTV MiniCard",
>                .type   = SMS_NOVA_B0,
>                .fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
> -               .lna_ctrl  = 29,
>                .board_cfg.foreign_lna0_ctrl = 29,
> -               .rf_switch = 17,
> -               .board_cfg.rf_switch_uhf = 17,
>        },
>        [SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2] = {
>                .name   = "Hauppauge WinTV MiniCard",
>                .type   = SMS_NOVA_B0,
>                .fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
> -               .lna_ctrl  = -1,
>        },
>        [SMS1XXX_BOARD_SIANO_NICE] = {
>        /* 11 */
> diff -r fd16bcd8b9f1 -r 0c3383720674 linux/drivers/media/dvb/siano/sms-cards.h
> --- a/linux/drivers/media/dvb/siano/sms-cards.h Tue May 19 19:50:24 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/sms-cards.h Tue May 19 19:58:00 2009 +0300
> @@ -76,9 +76,6 @@ struct sms_board {
>        char *name, *fw[DEVICE_MODE_MAX];
>        struct sms_board_gpio_cfg board_cfg;
>        enum ir_kb_type ir_kb_type;
> -
> -       /* gpios */
> -       int led_power, led_hi, led_lo, lna_ctrl, rf_switch;
>  };
>
>  struct sms_board *sms_get_board(int id);
> diff -r fd16bcd8b9f1 -r 0c3383720674 linux/drivers/media/dvb/siano/smscoreapi.c
> --- a/linux/drivers/media/dvb/siano/smscoreapi.c        Tue May 19 19:50:24 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/smscoreapi.c        Tue May 19 19:58:00 2009 +0300
> @@ -74,14 +74,6 @@ void smscore_set_board_id(struct smscore
>  {
>        core->board_id = id;
>  }
> -
> -int smscore_led_state(struct smscore_device_t *core, int led)
> -{
> -       if (led >= 0)
> -               core->led_state = led;
> -       return core->led_state;
> -}
> -EXPORT_SYMBOL_GPL(smscore_set_board_id);
>
>  int smscore_get_board_id(struct smscore_device_t *core)
>  {
> @@ -1451,78 +1443,6 @@ static int smscore_map_common_buffer(str
>  }
>  #endif /* SMS_HOSTLIB_SUBSYS */
>
> -/* old GPIO managments implementation */
> -int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
> -                          struct smscore_config_gpio *pinconfig)
> -{
> -       struct {
> -               struct SmsMsgHdr_ST hdr;
> -               u32 data[6];
> -       } msg;
> -
> -       if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
> -               msg.hdr.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
> -               msg.hdr.msgDstId = HIF_TASK;
> -               msg.hdr.msgFlags = 0;
> -               msg.hdr.msgType  = MSG_SMS_GPIO_CONFIG_EX_REQ;
> -               msg.hdr.msgLength = sizeof(msg);
> -
> -               msg.data[0] = pin;
> -               msg.data[1] = pinconfig->pullupdown;
> -
> -               /* Convert slew rate for Nova: Fast(0) = 3 / Slow(1) = 0; */
> -               msg.data[2] = pinconfig->outputslewrate == 0 ? 3 : 0;
> -
> -               switch (pinconfig->outputdriving) {
> -               case SMS_GPIO_OUTPUTDRIVING_16mA:
> -                       msg.data[3] = 7; /* Nova - 16mA */
> -                       break;
> -               case SMS_GPIO_OUTPUTDRIVING_12mA:
> -                       msg.data[3] = 5; /* Nova - 11mA */
> -                       break;
> -               case SMS_GPIO_OUTPUTDRIVING_8mA:
> -                       msg.data[3] = 3; /* Nova - 7mA */
> -                       break;
> -               case SMS_GPIO_OUTPUTDRIVING_4mA:
> -               default:
> -                       msg.data[3] = 2; /* Nova - 4mA */
> -                       break;
> -               }
> -
> -               msg.data[4] = pinconfig->direction;
> -               msg.data[5] = 0;
> -       } else /* TODO: SMS_DEVICE_FAMILY1 */
> -               return -EINVAL;
> -
> -       return coredev->sendrequest_handler(coredev->context,
> -                                           &msg, sizeof(msg));
> -}
> -
> -int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level)
> -{
> -       struct {
> -               struct SmsMsgHdr_ST hdr;
> -               u32 data[3];
> -       } msg;
> -
> -       if (pin > MAX_GPIO_PIN_NUMBER)
> -               return -EINVAL;
> -
> -       msg.hdr.msgSrcId = DVBT_BDA_CONTROL_MSG_ID;
> -       msg.hdr.msgDstId = HIF_TASK;
> -       msg.hdr.msgFlags = 0;
> -       msg.hdr.msgType  = MSG_SMS_GPIO_SET_LEVEL_REQ;
> -       msg.hdr.msgLength = sizeof(msg);
> -
> -       msg.data[0] = pin;
> -       msg.data[1] = level ? 1 : 0;
> -       msg.data[2] = 0;
> -
> -       return coredev->sendrequest_handler(coredev->context,
> -                                           &msg, sizeof(msg));
> -}
> -
> -/* new GPIO managment implementation */
>  static int GetGpioPinParams(u32 PinNum, u32 *pTranslatedPinNum,
>                u32 *pGroupNum, u32 *pGroupCfg) {
>
> diff -r fd16bcd8b9f1 -r 0c3383720674 linux/drivers/media/dvb/siano/smscoreapi.h
> --- a/linux/drivers/media/dvb/siano/smscoreapi.h        Tue May 19 19:50:24 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/smscoreapi.h        Tue May 19 19:58:00 2009 +0300
> @@ -170,8 +170,6 @@ struct smscore_device_t {
>
>        /* Infrared (IR) */
>        struct ir_t ir;
> -
> -       int led_state;
>  };
>
>  /* GPIO definitions for antenna frequency domain control (SMS8021) */
> @@ -536,46 +534,6 @@ struct SRVM_SIGNAL_STATUS_S {
>        u32 requestId;
>  };
>
> -struct SMSHOSTLIB_I2C_REQ_ST {
> -       u32     DeviceAddress; /* I2c device address */
> -       u32     WriteCount; /* number of bytes to write */
> -       u32     ReadCount; /* number of bytes to read */
> -       u8      Data[1];
> -};
> -
> -struct SMSHOSTLIB_I2C_RES_ST {
> -       u32     Status; /* non-zero value in case of failure */
> -       u32     ReadCount; /* number of bytes read */
> -       u8      Data[1];
> -};
> -
> -
> -struct smscore_config_gpio {
> -#define SMS_GPIO_DIRECTION_INPUT  0
> -#define SMS_GPIO_DIRECTION_OUTPUT 1
> -       u8 direction;
> -
> -#define SMS_GPIO_PULLUPDOWN_NONE     0
> -#define SMS_GPIO_PULLUPDOWN_PULLDOWN 1
> -#define SMS_GPIO_PULLUPDOWN_PULLUP   2
> -#define SMS_GPIO_PULLUPDOWN_KEEPER   3
> -       u8 pullupdown;
> -
> -#define SMS_GPIO_INPUTCHARACTERISTICS_NORMAL  0
> -#define SMS_GPIO_INPUTCHARACTERISTICS_SCHMITT 1
> -       u8 inputcharacteristics;
> -
> -#define SMS_GPIO_OUTPUTSLEWRATE_FAST 0
> -#define SMS_GPIO_OUTPUTSLEWRATE_SLOW 1
> -       u8 outputslewrate;
> -
> -#define SMS_GPIO_OUTPUTDRIVING_4mA  0
> -#define SMS_GPIO_OUTPUTDRIVING_8mA  1
> -#define SMS_GPIO_OUTPUTDRIVING_12mA 2
> -#define SMS_GPIO_OUTPUTDRIVING_16mA 3
> -       u8 outputdriving;
> -};
> -
>  struct smscore_gpio_config {
>  #define SMS_GPIO_DIRECTION_INPUT  0
>  #define SMS_GPIO_DIRECTION_OUTPUT 1
> @@ -658,12 +616,6 @@ extern void smscore_putbuffer(struct sms
>  extern void smscore_putbuffer(struct smscore_device_t *coredev,
>                              struct smscore_buffer_t *cb);
>
> -/* old GPIO managment */
> -int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
> -                          struct smscore_config_gpio *pinconfig);
> -int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level);
> -
> -/* new GPIO managment */
>  extern int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
>                struct smscore_gpio_config *pGpioConfig);
>  extern int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
> @@ -674,7 +626,6 @@ void smscore_set_board_id(struct smscore
>  void smscore_set_board_id(struct smscore_device_t *core, int id);
>  int smscore_get_board_id(struct smscore_device_t *core);
>
> -int smscore_led_state(struct smscore_device_t *core, int led);
>
>
>  /* ------------------------------------------------------------------------ */
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>




please see my previous NACK about not changing Hauppauge device
specific behavior until after all the core changesets are merged.
Then, we can test the device specific behavior before and after these
risky changesets.

Regards,

Mike
