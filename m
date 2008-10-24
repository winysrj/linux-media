Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <sinter.mann@gmx.de>) id 1KtPZM-0002uk-5h
	for linux-dvb@linuxtv.org; Fri, 24 Oct 2008 18:31:25 +0200
Date: Fri, 24 Oct 2008 18:30:50 +0200
From: sinter.mann@gmx.de
Message-ID: <20081024163050.10790@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Technisat Skystar Revision 2.8 broken in kernel
	2.6.28-rc1
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

Hi everybody,

neither with the latest Mercurial tree from linuxtv.org nor within the latest kernel 2.6.28-rc1 the Technisat Skystar DVB-S card is usable.

To resolve this as an intermediate solution I appended 2 patchsets as outline attachment:

a. skystar2_rev2.8.tar.bz2: the basic patch to run this card with a current kernel >= 2.6.27 - including a self-written docu and patches by Patrick Boettcher plus a precompiled cx24113 module, because this part is still not GPL

b. skystar2628.diff: A reversion concerning modules dvb_frontend.c and dvb_frontend.h: Without that reversion that card runs excellently under kernel 2.6.27.
With that reversion that card runs excellently under 2.6.28-rc1.

Have fun!

Cheers

sinter

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
