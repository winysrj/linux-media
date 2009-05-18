Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46330 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbZERHTB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 03:19:01 -0400
Date: Mon, 18 May 2009 04:18:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Uri Shkolnik <urishk@yahoo.com>,
	LinuxML <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH] [0905_23] Siano: gpio - use new implementation
Message-ID: <20090518041857.485516e9@pedra.chehab.org>
In-Reply-To: <20090518041551.451e70c8@pedra.chehab.org>
References: <38175.94614.qm@web110804.mail.gq1.yahoo.com>
	<20090518041551.451e70c8@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 18 May 2009 04:15:51 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Sun, 17 May 2009 01:57:45 -0700 (PDT)
> Uri Shkolnik <urishk@yahoo.com> escreveu:
> 
> > 
> > # HG changeset patch
> > # User Uri Shkolnik <uris@siano-ms.com>
> > # Date 1242331325 -10800
> > # Node ID 415ca02f74b960c02ddfa7ee719cf87726d97490
> > # Parent  8b645aa2ab13f22b8d4dcd8e6353fce2c976cd34
> > [0905_23] Siano: gpio - use new implementation
> > 
> > From: Uri Shkolnik <uris@siano-ms.com>
> > 
> > Start using the corrected gpio implementation
> 
> Hmm...
> 
> WARNING: "smscore_configure_gpio" [/home/v4l/master/v4l/sms1xxx.ko] undefined!
> WARNING: "smscore_set_gpio" [/home/v4l/master/v4l/sms1xxx.ko] undefined!

In time: The errors above were caused by the previous patch:
	[0905_22] Siano: smscore - fix bug in gpio implementation

> 
> Those functions weren't defined on any module. It seems that you forgot to
> submit a previous patch.
> 
> Also, since Hauppauge complained about the gpio changes, I'd like to have
> Michael's ack, especially if the patch affects the behavior of the existing
> Hauppauge supported boards.
> 
> Cheers,
> Mauro.
> 
> 
> > 
> > Priority: normal
> > 
> > Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> > 
> > diff -r 8b645aa2ab13 -r 415ca02f74b9 linux/drivers/media/dvb/siano/sms-cards.c
> > --- a/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:28:38 2009 +0300
> > +++ b/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 23:02:05 2009 +0300
> > @@ -17,6 +17,7 @@
> >   *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >   */
> >  
> > +#include "smscoreapi.h"
> >  #include "sms-cards.h"
> >  #include "smsir.h"
> >  
> > @@ -155,6 +156,174 @@ struct sms_board *sms_get_board(int id)
> >  }
> >  EXPORT_SYMBOL_GPL(sms_get_board);
> >  
> > +static inline void sms_gpio_assign_11xx_default_led_config(
> > +		struct smscore_gpio_config *pGpioConfig) {
> > +	pGpioConfig->Direction = SMS_GPIO_DIRECTION_OUTPUT;
> > +	pGpioConfig->InputCharacteristics =
> > +		SMS_GPIO_INPUTCHARACTERISTICS_NORMAL;
> > +	pGpioConfig->OutputDriving = SMS_GPIO_OUTPUTDRIVING_4mA;
> > +	pGpioConfig->OutputSlewRate = SMS_GPIO_OUTPUTSLEWRATE_0_45_V_NS;
> > +	pGpioConfig->PullUpDown = SMS_GPIO_PULLUPDOWN_NONE;
> > +}
> > +
> > +int sms_board_event(struct smscore_device_t *coredev,
> > +		enum SMS_BOARD_EVENTS gevent) {
> > +	int board_id = smscore_get_board_id(coredev);
> > +	struct sms_board *board = sms_get_board(board_id);
> > +	struct smscore_gpio_config MyGpioConfig;
> > +
> > +	sms_gpio_assign_11xx_default_led_config(&MyGpioConfig);
> > +
> > +	switch (gevent) {
> > +	case BOARD_EVENT_POWER_INIT: /* including hotplug */
> > +		switch (board_id) {
> > +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> > +			/* set I/O and turn off all LEDs */
> > +			smscore_gpio_configure(coredev,
> > +					board->board_cfg.leds_power,
> > +					&MyGpioConfig);
> > +			smscore_gpio_set_level(coredev,
> > +					board->board_cfg.leds_power, 0);
> > +			smscore_gpio_configure(coredev, board->board_cfg.led0,
> > +					&MyGpioConfig);
> > +			smscore_gpio_set_level(coredev,
> > +					board->board_cfg.led0, 0);
> > +			smscore_gpio_configure(coredev, board->board_cfg.led1,
> > +					&MyGpioConfig);
> > +			smscore_gpio_set_level(coredev,
> > +					board->board_cfg.led1, 0);
> > +			break;
> > +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> > +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> > +			/* set I/O and turn off LNA */
> > +			smscore_gpio_configure(coredev,
> > +					board->board_cfg.foreign_lna0_ctrl,
> > +					&MyGpioConfig);
> > +			smscore_gpio_set_level(coredev,
> > +					board->board_cfg.foreign_lna0_ctrl,
> > +					0);
> > +			break;
> > +		}
> > +		break; /* BOARD_EVENT_BIND */
> > +
> > +	case BOARD_EVENT_POWER_SUSPEND:
> > +		switch (board_id) {
> > +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> > +			smscore_gpio_set_level(coredev,
> > +						board->board_cfg.leds_power, 0);
> > +			smscore_gpio_set_level(coredev,
> > +						board->board_cfg.led0, 0);
> > +			smscore_gpio_set_level(coredev,
> > +						board->board_cfg.led1, 0);
> > +			break;
> > +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> > +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> > +			smscore_gpio_set_level(coredev,
> > +					board->board_cfg.foreign_lna0_ctrl,
> > +					0);
> > +			break;
> > +		}
> > +		break; /* BOARD_EVENT_POWER_SUSPEND */
> > +
> > +	case BOARD_EVENT_POWER_RESUME:
> > +		switch (board_id) {
> > +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> > +			smscore_gpio_set_level(coredev,
> > +						board->board_cfg.leds_power, 1);
> > +			smscore_gpio_set_level(coredev,
> > +						board->board_cfg.led0, 1);
> > +			smscore_gpio_set_level(coredev,
> > +						board->board_cfg.led1, 0);
> > +			break;
> > +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> > +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> > +			smscore_gpio_set_level(coredev,
> > +					board->board_cfg.foreign_lna0_ctrl,
> > +					1);
> > +			break;
> > +		}
> > +		break; /* BOARD_EVENT_POWER_RESUME */
> > +
> > +	case BOARD_EVENT_BIND:
> > +		switch (board_id) {
> > +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> > +			smscore_gpio_set_level(coredev,
> > +				board->board_cfg.leds_power, 1);
> > +			smscore_gpio_set_level(coredev,
> > +				board->board_cfg.led0, 1);
> > +			smscore_gpio_set_level(coredev,
> > +				board->board_cfg.led1, 0);
> > +			break;
> > +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> > +		case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> > +			smscore_gpio_set_level(coredev,
> > +					board->board_cfg.foreign_lna0_ctrl,
> > +					1);
> > +			break;
> > +		}
> > +		break; /* BOARD_EVENT_BIND */
> > +
> > +	case BOARD_EVENT_SCAN_PROG:
> > +		break; /* BOARD_EVENT_SCAN_PROG */
> > +	case BOARD_EVENT_SCAN_COMP:
> > +		break; /* BOARD_EVENT_SCAN_COMP */
> > +	case BOARD_EVENT_EMERGENCY_WARNING_SIGNAL:
> > +		break; /* BOARD_EVENT_EMERGENCY_WARNING_SIGNAL */
> > +	case BOARD_EVENT_FE_LOCK:
> > +		switch (board_id) {
> > +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> > +			smscore_gpio_set_level(coredev,
> > +			board->board_cfg.led1, 1);
> > +			break;
> > +		}
> > +		break; /* BOARD_EVENT_FE_LOCK */
> > +	case BOARD_EVENT_FE_UNLOCK:
> > +		switch (board_id) {
> > +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> > +			smscore_gpio_set_level(coredev,
> > +						board->board_cfg.led1, 0);
> > +			break;
> > +		}
> > +		break; /* BOARD_EVENT_FE_UNLOCK */
> > +	case BOARD_EVENT_DEMOD_LOCK:
> > +		break; /* BOARD_EVENT_DEMOD_LOCK */
> > +	case BOARD_EVENT_DEMOD_UNLOCK:
> > +		break; /* BOARD_EVENT_DEMOD_UNLOCK */
> > +	case BOARD_EVENT_RECEPTION_MAX_4:
> > +		break; /* BOARD_EVENT_RECEPTION_MAX_4 */
> > +	case BOARD_EVENT_RECEPTION_3:
> > +		break; /* BOARD_EVENT_RECEPTION_3 */
> > +	case BOARD_EVENT_RECEPTION_2:
> > +		break; /* BOARD_EVENT_RECEPTION_2 */
> > +	case BOARD_EVENT_RECEPTION_1:
> > +		break; /* BOARD_EVENT_RECEPTION_1 */
> > +	case BOARD_EVENT_RECEPTION_LOST_0:
> > +		break; /* BOARD_EVENT_RECEPTION_LOST_0 */
> > +	case BOARD_EVENT_MULTIPLEX_OK:
> > +		switch (board_id) {
> > +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> > +			smscore_gpio_set_level(coredev,
> > +						board->board_cfg.led1, 1);
> > +			break;
> > +		}
> > +		break; /* BOARD_EVENT_MULTIPLEX_OK */
> > +	case BOARD_EVENT_MULTIPLEX_ERRORS:
> > +		switch (board_id) {
> > +		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> > +			smscore_gpio_set_level(coredev,
> > +						board->board_cfg.led1, 0);
> > +			break;
> > +		}
> > +		break; /* BOARD_EVENT_MULTIPLEX_ERRORS */
> > +
> > +	default:
> > +		sms_err("Unknown SMS board event");
> > +		break;
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(sms_board_event);
> > +
> >  static int sms_set_gpio(struct smscore_device_t *coredev, int pin, int enable)
> >  {
> >  	int lvl, ret;
> > @@ -179,11 +348,11 @@ static int sms_set_gpio(struct smscore_d
> >  		lvl = enable ? 1 : 0;
> >  	}
> >  
> > -	ret = smscore_configure_gpio(coredev, gpio, &gpioconfig);
> > +	ret = smscore_gpio_configure(coredev, gpio, &gpioconfig);
> >  	if (ret < 0)
> >  		return ret;
> >  
> > -	return smscore_set_gpio(coredev, gpio, lvl);
> > +	return smscore_gpio_set_level(coredev, gpio, lvl);
> >  }
> >  
> >  int sms_board_setup(struct smscore_device_t *coredev)
> > diff -r 8b645aa2ab13 -r 415ca02f74b9 linux/drivers/media/dvb/siano/sms-cards.h
> > --- a/linux/drivers/media/dvb/siano/sms-cards.h	Thu May 14 22:28:38 2009 +0300
> > +++ b/linux/drivers/media/dvb/siano/sms-cards.h	Thu May 14 23:02:05 2009 +0300
> > @@ -86,6 +86,30 @@ extern struct usb_device_id smsusb_id_ta
> >  extern struct usb_device_id smsusb_id_table[];
> >  extern struct smscore_device_t *coredev;
> >  
> > +enum SMS_BOARD_EVENTS {
> > +	BOARD_EVENT_POWER_INIT,
> > +	BOARD_EVENT_POWER_SUSPEND,
> > +	BOARD_EVENT_POWER_RESUME,
> > +	BOARD_EVENT_BIND,
> > +	BOARD_EVENT_SCAN_PROG,
> > +	BOARD_EVENT_SCAN_COMP,
> > +	BOARD_EVENT_EMERGENCY_WARNING_SIGNAL,
> > +	BOARD_EVENT_FE_LOCK,
> > +	BOARD_EVENT_FE_UNLOCK,
> > +	BOARD_EVENT_DEMOD_LOCK,
> > +	BOARD_EVENT_DEMOD_UNLOCK,
> > +	BOARD_EVENT_RECEPTION_MAX_4,
> > +	BOARD_EVENT_RECEPTION_3,
> > +	BOARD_EVENT_RECEPTION_2,
> > +	BOARD_EVENT_RECEPTION_1,
> > +	BOARD_EVENT_RECEPTION_LOST_0,
> > +	BOARD_EVENT_MULTIPLEX_OK,
> > +	BOARD_EVENT_MULTIPLEX_ERRORS
> > +};
> > +
> > +int sms_board_event(struct smscore_device_t *coredev,
> > +		enum SMS_BOARD_EVENTS gevent);
> > +
> >  int sms_board_setup(struct smscore_device_t *coredev);
> >  
> >  #define SMS_LED_OFF 0
> > diff -r 8b645aa2ab13 -r 415ca02f74b9 linux/drivers/media/dvb/siano/smscoreapi.h
> > --- a/linux/drivers/media/dvb/siano/smscoreapi.h	Thu May 14 22:28:38 2009 +0300
> > +++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Thu May 14 23:02:05 2009 +0300
> > @@ -633,9 +633,12 @@ extern void smscore_putbuffer(struct sms
> >  extern void smscore_putbuffer(struct smscore_device_t *coredev,
> >  			      struct smscore_buffer_t *cb);
> >  
> > -int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
> > -			   struct smscore_gpio_config *pinconfig);
> > -int smscore_set_gpio(struct smscore_device_t *coredev, u32 pin, int level);
> > +int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
> > +		struct smscore_gpio_config *pGpioConfig);
> > +int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 PinNum,
> > +		u8 NewLevel);
> > +int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 PinNum,
> > +		u8 *level);
> >  
> >  void smscore_set_board_id(struct smscore_device_t *core, int id);
> >  int smscore_get_board_id(struct smscore_device_t *core);
> > 
> > 
> > 
> >       
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 
> Cheers,
> Mauro




Cheers,
Mauro
