Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KgnnD-0007Ct-KS
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 23:45:36 +0200
Message-ID: <48D41D7B.90609@iki.fi>
Date: Sat, 20 Sep 2008 00:45:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dirk Vornheder <dirk_vornheder@yahoo.de>
References: <200809152345.37786.dirk_vornheder@yahoo.de>	<48CF85C2.1030806@iki.fi>
	(sfid-20080916_200620_773173_78C7D8C0)
	<200809172115.19851.dirk_vornheder@yahoo.de>
In-Reply-To: <200809172115.19851.dirk_vornheder@yahoo.de>
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

Dirk Vornheder wrote:
> Compile produces undefined symbol:
> 
>   Building modules, stage 2.
>   MODPOST 166 modules
> WARNING: "__udivdi3" [/backup/privat/kernel/af9015_test-
> c8583d119095/v4l/af9013.ko] undefined!
>   CC      /backup/privat/kernel/af9015_test-c8583d119095/v4l/af9013.mod.o
>   LD [M]  /backup/privat/kernel/af9015_test-c8583d119095/v4l/af9013.ko
>   CC      /backup/privat/kernel/af9015_test-c8583d119095/v4l/au8522.mod.o
>   LD [M]  /backup/privat/kernel/af9015_test-c8583d119095/v4l/au8522.ko

That's now fixed, please test: http://linuxtv.org/hg/~anttip/af9015_test

>>> I buy a new notebook HP Pavilion dv7-1070eg which includes one

Did you mean that this AverMedia DVB-T device is integrated to the 
motherboard of your computer?

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
