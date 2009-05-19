Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:49812 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbZESQbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 12:31:48 -0400
Received: by ewy24 with SMTP id 24so5000678ewy.37
        for <linux-media@vger.kernel.org>; Tue, 19 May 2009 09:31:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <489128.99706.qm@web110801.mail.gq1.yahoo.com>
References: <489128.99706.qm@web110801.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 12:31:47 -0400
Message-ID: <37219a840905190931g79811b86oe4f64f185f626fc0@mail.gmail.com>
Subject: Re: [PATCH] [09051_54] Siano: remove obsolete sms_board_setup
From: Michael Krufky <mkrufky@linuxtv.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 19, 2009 at 12:15 PM, Uri Shkolnik <urishk@yahoo.com> wrote:
>
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1242749967 -10800
> # Node ID 0296b0c436d6deba48c710cfb510988267cea057
> # Parent  dfcfb90798d3a27cb174019b17fffdee9ce7b2b9
> [09051_54] Siano: remove obsolete sms_board_setup
>
> From: Uri Shkolnik <uris@siano-ms.com>
>
> Remove the target specific sms_board_setup from smsdvb. This
> is handled now via smsdvb and sms-cards events.
>
> Priority: normal
>
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
>
> diff -r dfcfb90798d3 -r 0296b0c436d6 linux/drivers/media/dvb/siano/sms-cards.c
> --- a/linux/drivers/media/dvb/siano/sms-cards.c Tue May 19 19:05:02 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/sms-cards.c Tue May 19 19:19:27 2009 +0300
> @@ -303,28 +303,6 @@ static int sms_set_gpio(struct smscore_d
>        return smscore_set_gpio(coredev, gpio, lvl);
>  }
>
> -int sms_board_setup(struct smscore_device_t *coredev)
> -{
> -       int board_id = smscore_get_board_id(coredev);
> -       struct sms_board *board = sms_get_board(board_id);
> -
> -       switch (board_id) {
> -       case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> -               /* turn off all LEDs */
> -               sms_set_gpio(coredev, board->led_power, 0);
> -               sms_set_gpio(coredev, board->led_hi, 0);
> -               sms_set_gpio(coredev, board->led_lo, 0);
> -               break;
> -       case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> -       case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> -               /* turn off LNA */
> -               sms_set_gpio(coredev, board->lna_ctrl, 0);
> -               break;
> -       }
> -       return 0;
> -}
> -EXPORT_SYMBOL_GPL(sms_board_setup);
> -
>  int sms_board_power(struct smscore_device_t *coredev, int onoff)
>  {
>        int board_id = smscore_get_board_id(coredev);
> diff -r dfcfb90798d3 -r 0296b0c436d6 linux/drivers/media/dvb/siano/sms-cards.h
> --- a/linux/drivers/media/dvb/siano/sms-cards.h Tue May 19 19:05:02 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/sms-cards.h Tue May 19 19:19:27 2009 +0300
> @@ -109,8 +109,6 @@ int sms_board_event(struct smscore_devic
>  int sms_board_event(struct smscore_device_t *coredev,
>                enum SMS_BOARD_EVENTS gevent);
>
> -int sms_board_setup(struct smscore_device_t *coredev);
> -
>  #define SMS_LED_OFF 0
>  #define SMS_LED_LO  1
>  #define SMS_LED_HI  2
> diff -r dfcfb90798d3 -r 0296b0c436d6 linux/drivers/media/dvb/siano/smsdvb.c
> --- a/linux/drivers/media/dvb/siano/smsdvb.c    Tue May 19 19:05:02 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/smsdvb.c    Tue May 19 19:19:27 2009 +0300
> @@ -600,7 +600,6 @@ static int smsdvb_hotplug(struct smscore
>        sms_board_dvb3_event(client, DVB3_EVENT_HOTPLUG);
>
>        sms_info("success");
> -       sms_board_setup(coredev);
>
>        return 0;
>
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


This changes the behavior of the Hauppauge devices.  Let Uri get all
his other stuff in place first, and THEN we can look at this
separately.

In addition, this changeset was merged WITHOUT my ack:

http://linuxtv.org/hg/v4l-dvb/rev/37969546eee8 - Siano: smscards -
assign gpio to HPG targets

That changeset 37969546eee8 alone does not cause any change in
behavior, but with Uri's patches from today it will change the
Hauppauge device behavior.

That patch should be reverted and dealt with separately, after Uri is
finished with his other changes.

-Mike
