Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KXFNb-0000Mc-2N
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 15:11:40 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 24 Aug 2008 15:10:48 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808241510.48819@orion.escape-edv.de>
Cc: Martin Dauskardt <martin.dauskardt@gmx.de>
Subject: [linux-dvb] Cablestar DVB-C (Flexcop + stv0297) broken since
	changeset 7fb12d754061 (7469)
Reply-To: linux-dvb@linuxtv.org
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

according to the thread
  http://www.vdr-portal.de/board/thread.php?threadid=76932
in vdr-portal, the modifications of the flexcop i2c handling in
changeset 7fb12d754061 (7469) broke support for the Cablestar card.

Note that stv0297 does not support repeated start conditions (same
problem as with s5h1420).

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
