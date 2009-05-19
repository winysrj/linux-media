Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:65125 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZESREP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 13:04:15 -0400
Received: by ewy24 with SMTP id 24so5025796ewy.37
        for <linux-media@vger.kernel.org>; Tue, 19 May 2009 10:04:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <281711.70090.qm@web110802.mail.gq1.yahoo.com>
References: <281711.70090.qm@web110802.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 13:04:14 -0400
Message-ID: <37219a840905191004h65e2b183m90089117034edbe4@mail.gmail.com>
Subject: Re: [PATCH] [09051_57] Siano: smscards - remove redundant code
From: Michael Krufky <mkrufky@linuxtv.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 19, 2009 at 12:46 PM, Uri Shkolnik <urishk@yahoo.com> wrote:
>
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1242751824 -10800
> # Node ID fd16bcd8b9f1fffe0b605ca5b3b2138fc920e927
> # Parent  f78cbc153c82ebe58a1bbe82271b91f5a4a90642
> [09051_57] Siano: smscards - remove redundant code
>
> From: Uri Shkolnik <uris@siano-ms.com>
>
> Remove code that has been duplicate with the new boards events manager
>
> Priority: normal
>
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
>
> diff -r f78cbc153c82 -r fd16bcd8b9f1 linux/drivers/media/dvb/siano/sms-cards.c
> --- a/linux/drivers/media/dvb/siano/sms-cards.c Tue May 19 19:45:05 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/sms-cards.c Tue May 19 19:50:24 2009 +0300
> @@ -281,98 +281,3 @@ int sms_board_event(struct smscore_devic
>        return 0;
>  }
>  EXPORT_SYMBOL_GPL(sms_board_event);
> -
> -static int sms_set_gpio(struct smscore_device_t *coredev, int pin, int enable)
> -{
> -       int lvl, ret;
> -       u32 gpio;
> -       struct smscore_config_gpio gpioconfig = {
> -               .direction            = SMS_GPIO_DIRECTION_OUTPUT,
> -               .pullupdown           = SMS_GPIO_PULLUPDOWN_NONE,
> -               .inputcharacteristics = SMS_GPIO_INPUTCHARACTERISTICS_NORMAL,
> -               .outputslewrate       = SMS_GPIO_OUTPUTSLEWRATE_FAST,
> -               .outputdriving        = SMS_GPIO_OUTPUTDRIVING_4mA,
> -       };
> -
> -       if (pin == 0)
> -               return -EINVAL;
> -
> -       if (pin < 0) {
> -               /* inverted gpio */
> -               gpio = pin * -1;
> -               lvl = enable ? 0 : 1;
> -       } else {
> -               gpio = pin;
> -               lvl = enable ? 1 : 0;
> -       }
> -
> -       ret = smscore_configure_gpio(coredev, gpio, &gpioconfig);
> -       if (ret < 0)
> -               return ret;
> -
> -       return smscore_set_gpio(coredev, gpio, lvl);
> -}
> -
> -int sms_board_power(struct smscore_device_t *coredev, int onoff)
> -{
> -       int board_id = smscore_get_board_id(coredev);
> -       struct sms_board *board = sms_get_board(board_id);
> -
> -       switch (board_id) {
> -       case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> -               /* power LED */
> -               sms_set_gpio(coredev,
> -                            board->led_power, onoff ? 1 : 0);
> -               break;
> -       case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> -       case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> -               /* LNA */
> -               if (!onoff)
> -                       sms_set_gpio(coredev, board->lna_ctrl, 0);
> -               break;
> -       }
> -       return 0;
> -}
> -EXPORT_SYMBOL_GPL(sms_board_power);
> -
> -int sms_board_led_feedback(struct smscore_device_t *coredev, int led)
> -{
> -       int board_id = smscore_get_board_id(coredev);
> -       struct sms_board *board = sms_get_board(board_id);
> -
> -       /* dont touch GPIO if LEDs are already set */
> -       if (smscore_led_state(coredev, -1) == led)
> -               return 0;
> -
> -       switch (board_id) {
> -       case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> -               sms_set_gpio(coredev,
> -                            board->led_lo, (led & SMS_LED_LO) ? 1 : 0);
> -               sms_set_gpio(coredev,
> -                            board->led_hi, (led & SMS_LED_HI) ? 1 : 0);
> -
> -               smscore_led_state(coredev, led);
> -               break;
> -       }
> -       return 0;
> -}
> -EXPORT_SYMBOL_GPL(sms_board_led_feedback);
> -
> -int sms_board_lna_control(struct smscore_device_t *coredev, int onoff)
> -{
> -       int board_id = smscore_get_board_id(coredev);
> -       struct sms_board *board = sms_get_board(board_id);
> -
> -       sms_debug("%s: LNA %s", __func__, onoff ? "enabled" : "disabled");
> -
> -       switch (board_id) {
> -       case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> -       case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> -               sms_set_gpio(coredev,
> -                            board->rf_switch, onoff ? 1 : 0);
> -               return sms_set_gpio(coredev,
> -                                   board->lna_ctrl, onoff ? 1 : 0);
> -       }
> -       return -EINVAL;
> -}
> -EXPORT_SYMBOL_GPL(sms_board_lna_control);
> diff -r f78cbc153c82 -r fd16bcd8b9f1 linux/drivers/media/dvb/siano/sms-cards.h
> --- a/linux/drivers/media/dvb/siano/sms-cards.h Tue May 19 19:45:05 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/sms-cards.h Tue May 19 19:50:24 2009 +0300
> @@ -110,11 +110,4 @@ int sms_board_event(struct smscore_devic
>  int sms_board_event(struct smscore_device_t *coredev,
>                enum SMS_BOARD_EVENTS gevent);
>
> -#define SMS_LED_OFF 0
> -#define SMS_LED_LO  1
> -#define SMS_LED_HI  2
> -int sms_board_led_feedback(struct smscore_device_t *coredev, int led);
> -int sms_board_power(struct smscore_device_t *coredev, int onoff);
> -int sms_board_lna_control(struct smscore_device_t *coredev, int onoff);
> -
>  #endif /* __SMS_CARDS_H__ */
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

NACK.


Again, this breaks the Hauppauge devices...  As I have said, lets deal
with that separately after the core changesets are merged.

Regards,

Mike
