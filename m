Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <greid+linux-dvb@thereidfamily.net>)
	id 1LCsW7-0006uY-7Q
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 10:16:32 +0100
Received: from aamtaout02-winn.ispmail.ntl.com ([81.103.221.35])
	by mtaout03-winn.ispmail.ntl.com
	(InterMail vM.7.08.04.00 201-2186-134-20080326) with ESMTP id
	<20081217091557.GJAA1691.mtaout03-winn.ispmail.ntl.com@aamtaout02-winn.ispmail.ntl.com>
	for <linux-dvb@linuxtv.org>; Wed, 17 Dec 2008 09:15:57 +0000
Received: from [10.0.1.1] (really [81.96.199.243])
	by aamtaout02-winn.ispmail.ntl.com
	(InterMail vG.2.02.00.01 201-2161-120-102-20060912) with ESMTP id
	<20081217091557.CVCC21638.aamtaout02-winn.ispmail.ntl.com@[10.0.1.1]>
	for <linux-dvb@linuxtv.org>; Wed, 17 Dec 2008 09:15:57 +0000
Message-ID: <4948C341.8090206@thereidfamily.net>
Date: Wed, 17 Dec 2008 09:15:45 +0000
From: George Reid <greid+linux-dvb@thereidfamily.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Hauppauge Nova-TD-500 84xxx remote control
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

Hi all,

I have just bought one of these cards (a Nova-TD-500 84xxx) for my dad 
as a Christmas present (no, he hasn't opened it yet!).  While the tuners 
are functioning perfectly, the driver doesn't support the infrared 
receiver on the card.  I have tried using the latest firmware and 
drivers from hg but the driver itself defines no remote control query 
function or key mapping for these devices.  It also doesn't work if I 
bodge in the regular Nova-T 500 rc_query and keymaps.

Does anybody have any ideas about how the infrared receiver in this 
device (84xxx) is accessed differently to the older Nova-T 500 cards?  
I'd love to try and get it working but I don't really know anything 
about these devices or where to start.  Does anybody have any pointers 
or documentation for the 84xxx card?

Kind regards,

George Reid



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
