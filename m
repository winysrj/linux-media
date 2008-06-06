Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1K4cxT-0002WN-NW
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 16:30:24 +0200
Received: from [192.168.0.188] (89.97.249.170) by relay-pt1.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 48487E810000CF0E for linux-dvb@linuxtv.org;
	Fri, 6 Jun 2008 16:30:19 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Fri, 6 Jun 2008 16:30:35 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806061630.35379.Nicola.Sabbi@poste.it>
Subject: [linux-dvb] Remote on Lifeview Trio: anyone got it working?
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

Hi,
did anyone get the remote controller on the Trio working?
I found a patch from which it seems that it talks via i2c either
at 0x0b or at 0x0e address and someone reported success,
but it seems that no patch was applied to linuxtv's HG repository.

Can anyone who has it working post the correct patch(-es), please?

Thanks,
	Nico

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
