Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1K3fpT-0001Jm-Qo
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 01:22:15 +0200
From: Sigmund Augdal <sigmund@snap.tv>
To: linux-dvb@linuxtv.org
Date: Wed, 04 Jun 2008 01:22:12 +0200
Message-Id: <1212535332.32385.29.camel@pascal>
Mime-Version: 1.0
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Subject: [linux-dvb] Ooops in tda827x.c
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

changeset 49ba58715fe0 (7393) introduces an ooops in tda827x.c in
tda827xa_lna_gain. The initialization of the "msg" variable accesses
priv->cfg before the NULL check causing an oops when it is in fact
NULL. 

Best regards

Sigmund Augdal


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
