Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Kg3Vt-0001i3-Dv
	for linux-dvb@linuxtv.org; Wed, 17 Sep 2008 22:20:38 +0200
Message-ID: <34408.85.23.68.42.1221682831.squirrel@webmail.kapsi.fi>
In-Reply-To: <200809172115.19851.dirk_vornheder@yahoo.de>
References: <200809152345.37786.dirk_vornheder@yahoo.de>
	<48CF85C2.1030806@iki.fi>
	<200809172115.19851.dirk_vornheder@yahoo.de>
Date: Wed, 17 Sep 2008 23:20:31 +0300 (EEST)
From: "Antti Palosaari" <crope@iki.fi>
To: "Dirk Vornheder" <dirk_vornheder@yahoo.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] UNS: Re:  New unspported device AVerMedia DVB-T
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

ke 17.9.2008 22:15 Dirk Vornheder kirjoitti:
>
> Compile produces undefined symbol:
>
>   Building modules, stage 2.
>   MODPOST 166 modules
> WARNING: "__udivdi3" [/backup/privat/kernel/af9015_test-
> c8583d119095/v4l/af9013.ko] undefined!

I fixed this yesterday  but only for af9015 main tree :-( Unfortunately I
am not in my home so I cannot fix this just now for your test tree. But if
you can, you can fix it yourself.

Open file af9015_test/linux/drivers/media/dvb/frontends/af9013.c
Remove lines 982-986. Compile and test. Hopefully it works.
You can remove following lines (982-986).
	if (total_bit_count) {
		numerator = error_bit_count * 1000000000;
		denominator = total_bit_count;
		state->ber = numerator / denominator;
	}

regards
Antti



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
