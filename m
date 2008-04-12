Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JkhI9-0003PN-Qh
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 17:05:22 +0200
Received: from mail01.m-online.net (mail.m-online.net [192.168.3.149])
	by mail-out.m-online.net (Postfix) with ESMTP id BA4B221D736
	for <linux-dvb@linuxtv.org>; Sat, 12 Apr 2008 17:04:55 +0200 (CEST)
Received: from localhost (unknown [192.168.1.157])
	by mail.m-online.net (Postfix) with ESMTP id 7AFD790075
	for <linux-dvb@linuxtv.org>; Sat, 12 Apr 2008 17:04:47 +0200 (CEST)
Received: from mail.mnet-online.de ([192.168.3.149])
	by localhost (scanner1.m-online.net [192.168.1.157]) (amavisd-new,
	port 10024) with ESMTP id g9YpXnNk-BS1 for <linux-dvb@linuxtv.org>;
	Sat, 12 Apr 2008 17:04:46 +0200 (CEST)
Received: from gauss.x.fun (ppp-88-217-104-133.dynamic.mnet-online.de
	[88.217.104.133]) by mail.nefkom.net (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Sat, 12 Apr 2008 17:04:46 +0200 (CEST)
Message-Id: <20080412150444.987445669@gentoo.org>
Date: Sat, 12 Apr 2008 17:04:45 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [patch 0/5] mt312: Add support for zl10313 demod
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

mt312: Cleanup driver and add support for zl10313.

These patches add support for the Zarlink zl10313 demod to mt312 driver.
This chip is used at least on Avermedia A700 DVB-S and
Compro VideoMate S300/S350 DVB-S cards.

Regards
Matthias

-- 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
