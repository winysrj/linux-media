Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.acc.umu.se ([130.239.18.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nikke@acc.umu.se>) id 1LLegV-000384-Fn
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 15:19:34 +0100
Received: from localhost (localhost [127.0.0.1])
	by amavisd-new (Postfix) with ESMTP id CA41F8D6
	for <linux-dvb@linuxtv.org>; Sat, 10 Jan 2009 15:19:26 +0100 (MET)
Received: from localhost (localhost [127.0.0.1])
	by mail.acc.umu.se (Postfix) with ESMTP id A9F768D4
	for <linux-dvb@linuxtv.org>; Sat, 10 Jan 2009 15:19:22 +0100 (MET)
Date: Sat, 10 Jan 2009 15:19:22 +0100 (MET)
From: Niklas Edmundsson <nikke@acc.umu.se>
To: linux-dvb@linuxtv.org
Message-ID: <Pine.GSO.4.64.0901101505010.16242@hatchepsut.acc.umu.se>
MIME-Version: 1.0
Subject: [linux-dvb] Latest mantis tree -> oops on load
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


The latest mantis tree from http://jusst.de/hg/mantis makes mantis.ko 
oops on load for me.

I have an Azurewave/Twinhan AD-CP300 without 
CA/CI/crypto/whatchamacallit (my cable provider gives me my basic 
channels unencrypted).

My guess is that the "serial interface implementation" is missing some 
corner case checks ;)

Executive summary of the console is:

mantis_hif_init (0): Adapter(0) Initializing yada yada
BUG: unable to handle kernel NULL pointer dereference at virtual address yada.
<cut>
EIP is at mantis_uart_read+yada


/Nikke
-- 
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Niklas Edmundsson, Admin @ {acc,hpc2n}.umu.se      |     nikke@acc.umu.se
---------------------------------------------------------------------------
  POVERTY: Having too much month left at the end of the money.
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
