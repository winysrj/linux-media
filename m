Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1LIael-0003sp-Ig
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 04:25:04 +0100
Received: by fk-out-0910.google.com with SMTP id f40so3802278fka.1
	for <linux-dvb@linuxtv.org>; Thu, 01 Jan 2009 19:25:00 -0800 (PST)
Message-ID: <495D8909.4030601@gmail.com>
Date: Fri, 02 Jan 2009 04:24:57 +0100
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <495D862C.3020805@gmail.com>
In-Reply-To: <495D862C.3020805@gmail.com>
From: thomas schorpp <thomas.schorpp@googlemail.com>
Subject: [linux-dvb] [BUG]2.6.28 breaks dvb-usb devices FE i2c
Reply-To: thomas schorpp <thomas.schorpp@gmail.com>
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

thomas schorpp schrieb:
> hi,
> 
> usb 2-2: Product: TvTUNER
> usb 2-2: Manufacturer: SKGZ
> ID 04ca:f001 Lite-On Technology Corp.
> 
> FE has been (mostly, until the 3rd try) detected until 2.6.27.10:
> Dec 31 12:01:33 tom1 kernel: MT2060: successfully identified (IF1 = 1241)
> 
> but no more with 2.6.28.
> 

> 
> this should be the breaking changeset included in 2.6.28 stable kernel 
> release, others are too old:
> 

> http://linuxtv.org/hg/v4l-dvb/rev/5bfadacec8a2 Signed-off-by: Mauro 
> Carvalho Chehab <mchehab@redhat.com>

no, takeback, too trivial 
http://linuxtv.org/hg/v4l-dvb/diff/5bfadacec8a2/linux/drivers/media/dvb/frontends/dibx000_common.c

2.6.28 i2c broken or this driver needs updating for 2.6.28.

y
tom

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
