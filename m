Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate01.web.de ([217.72.192.221])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <SiestaGomez@web.de>) id 1K7vxG-0005vG-Il
	for linux-dvb@linuxtv.org; Sun, 15 Jun 2008 19:23:56 +0200
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate01.web.de (Postfix) with ESMTP id C2ECEE42593E
	for <linux-dvb@linuxtv.org>; Sun, 15 Jun 2008 19:23:01 +0200 (CEST)
Received: from [88.152.136.212] (helo=midian.waldorf.intern)
	by smtp08.web.de with asmtp (WEB.DE 4.109 #226) id 1K7vwS-0000Ir-00
	for linux-dvb@linuxtv.org; Sun, 15 Jun 2008 19:23:00 +0200
Date: Sun, 15 Jun 2008 19:23:00 +0200
From: SG <SiestaGomez@web.de>
To: linux-dvb@linuxtv.org
Message-Id: <20080615192300.90886244.SiestaGomez@web.de>
Mime-Version: 1.0
Subject: [linux-dvb]  [PATCH] experimental support for C-1501
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

The patch works quite well and nearly all channels seem to work.

But when tuning to some radio channels I'll get this kernel message:

saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer

Also I'm not able to tune to 'transponder 386000000 6900000 0 3' which works
smoothly when using Win32.

initial transponder 386000000 6900000 0 3
 >>> tune to: 386:M64:C:6900:
WARNING: >>> tuning failed!!!
 >>> tune to: 386:M64:C:6900: (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

Any hints ?

Thanks and regards.
Martin

Sigmund Augdal wrote:

> Here is a new version. This one passes checkpatch without warnings. I
> removed the read_pwm function, as it always uses the fallback path for
> my card (and frankly I have no idea wether it is actually relevant at
> all for this kind of card). Furthermore the tda10023 driver doesn't seem
> to use this value for anything.
>
> Best regards
>
> Sigmund Augdal

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
