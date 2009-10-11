Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <reg@dwf.com>) id 1MwsD4-0007Vi-Fe
	for linux-dvb@linuxtv.org; Sun, 11 Oct 2009 08:47:15 +0200
Received: from deneb.dwf.com (localhost.localdomain [127.0.0.1])
	by deneb.dwf.com (8.14.1/8.14.1) with ESMTP id n9B6kcN5014056
	for <linux-dvb@linuxtv.org>; Sun, 11 Oct 2009 00:46:38 -0600
Message-Id: <200910110646.n9B6kcN5014056@deneb.dwf.com>
To: linux-dvb@linuxtv.org
From: clemens@dwf.com
Mime-Version: 1.0
Date: Sun, 11 Oct 2009 00:46:38 -0600
Subject: [linux-dvb] Problems in linux-2.6.31
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

In xconfig for linux-2.6.31 there appears to be only one line that refers to 
the
Technisat Air 2 PCI cards, viz
	Technisat/B2C2 ...
	    Tecnisat/B2C2 Air/Sky/Cable2PC PCI 
	    ...

Yet when I build a kernel with this option my OLD Techisat card 
the Air 2 PC-ATSC-PCI card that requires some microcode to be loaded, comes
up but the newer card, the AirStar-HD5000-PCI does not.

Anyone else see this behaviour?
Everything is fine with an older kernel.

Anyone know  a solution?

Am I missing something?

-- 
                                        Reg.Clemens
                                        reg@dwf.com


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
