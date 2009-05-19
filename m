Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:36652 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZESQfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 12:35:21 -0400
Received: by ewy24 with SMTP id 24so5003555ewy.37
        for <linux-media@vger.kernel.org>; Tue, 19 May 2009 09:35:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <716575.53837.qm@web110806.mail.gq1.yahoo.com>
References: <716575.53837.qm@web110806.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 12:35:20 -0400
Message-ID: <37219a840905190935s4f220cbcg7bfe216a5d42b379@mail.gmail.com>
Subject: Re: [PATCH] [09051_55] Siano: smscards - merge the binding handling
From: Michael Krufky <mkrufky@linuxtv.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 19, 2009 at 12:24 PM, Uri Shkolnik <urishk@yahoo.com> wrote:
>
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1242750556 -10800
> # Node ID d92f2dfcb226c5f8b8c3216f7cf96126f7571702
> # Parent  0296b0c436d6deba48c710cfb510988267cea057
> [09051_55] Siano: smscards - merge the binding handling.
>
> From: Uri Shkolnik <uris@siano-ms.com>
>
> Merge the bind handling into the events switch.
>
> Priority: normal
>
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
>
> diff -r 0296b0c436d6 -r d92f2dfcb226 linux/drivers/media/dvb/siano/sms-cards.c
> --- a/linux/drivers/media/dvb/siano/sms-cards.c Tue May 19 19:19:27 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/sms-cards.c Tue May 19 19:29:16 2009 +0300
> @@ -194,7 +194,13 @@ int sms_board_event(struct smscore_devic
>
>        case BOARD_EVENT_BIND:
>                switch (board_id) {
> +               case SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT:
> +               case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A:
> +               case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B:
> +                       request_module("smsdvb");
> +                       break;
>                case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> +                       request_module("smsdvb");
>                        smscore_gpio_set_level(coredev,
>                                board->board_cfg.leds_power, 1);
>                        smscore_gpio_set_level(coredev,
> @@ -366,20 +372,3 @@ int sms_board_lna_control(struct smscore
>        return -EINVAL;
>  }
>  EXPORT_SYMBOL_GPL(sms_board_lna_control);
> -
> -int sms_board_load_modules(int id)
> -{
> -       switch (id) {
> -       case SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT:
> -       case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A:
> -       case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B:
> -       case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> -               request_module("smsdvb");
> -               break;
> -       default:
> -               /* do nothing */
> -               break;
> -       }
> -       return 0;
> -}
> -EXPORT_SYMBOL_GPL(sms_board_load_modules);
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

NACK

Again, let Uri finish his other changesets first, and settle down to a
stable state so that the Hauppauge devices can be tested before and
after these Hauppauge-specific changesets.

This puts the stability of Hauppauge device support in this driver
into jeopardy.

-Mike
