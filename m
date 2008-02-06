Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m160qF42027506
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 19:52:15 -0500
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m160pgdL029577
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 19:51:42 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Yuri Fundurian <yurifun@mail.ru>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ricardo Cerqueira <v4l@cerqueira.org>
In-Reply-To: <E1JMMVt-000Lwk-00.yurifun-mail-ru@f43.mail.ru>
References: <E1JMMVt-000Lwk-00.yurifun-mail-ru@f43.mail.ru>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 01:48:03 +0100
Message-Id: <1202258883.4261.28.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] [PATCH 2.6.24 1/1] saa7134: fix fm-radio
	pinnacle pctv 110i
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

Am Dienstag, den 05.02.2008, 15:02 +0300 schrieb Yuri Fundurian:
> This patch for fm-radio on pinnacle pctv 110i.
> Without this patch fm-radio doesn't work.
> 
> --- /usr/src/kernels/2.6.24/drivers/media/video/saa7134/saa7134-cards.c 2008-01-25 03:58:37.000000000 +0500
> +++ /usr/src/kernels/2.6.24/drivers/media/video/saa7134/saa7134-cards.c.patch   2008-01-31 11:27:01.000000000 +0500
> @@ -2484,7 +2484,8 @@ struct saa7134_board saa7134_boards[] =
>                 }},
>                 .radio = {
>                           .name = name_radio,
> -                         .amux = LINE1,
> +                       .amux = TV,
> +                       .gpio = 0x0200000,
>                 },
>         },
>         [SAA7134_BOARD_ASUSTeK_P7131_DUAL] = {
> Signed-off-by: Yuri Funduryan <yurifun@mail.ru>
Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>

Yuri, thanks for the fix.

Hartmut, does it apply with some offset or should I prepare something
against v4l-dvb?

Mauro can pull it as a fix for 2.6.25 then.

We also have the same issue on the Avermedia 007, AFAIK.
Next we should fix the indentation on the 110i entry ;)

Got a Medion/Creatix CTX953 today.
Against prior reports, DVB-T and analog TV work very well,
have to check the other inputs.

A patch will follow soon.

No trace of the CTX948 yet I did send to you as a letter in the hope to
save some time. Will try to get it investigated. A new one is bought,
but might take time to arrive.

In between we might call for testers on both lists and point to what we
have so far.

Cheers,
Hermann


 



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
