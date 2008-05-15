Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway12.websitewelcome.com ([69.93.154.13])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1JwmSk-0002lA-W9
	for linux-dvb@linuxtv.org; Fri, 16 May 2008 01:02:16 +0200
Received: from [77.109.107.153] (port=55522 helo=[192.168.1.3])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1JwmSc-00086H-PV
	for linux-dvb@linuxtv.org; Thu, 15 May 2008 18:02:06 -0500
Message-ID: <482CC0F0.30005@kipdola.com>
Date: Fri, 16 May 2008 01:02:08 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Technotrend S2-3200 Scanning
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

Hi again,

It's been a busy day. So I temporarily removed LinuxMCE to install the 
newer Mythbuntu 8.04 - the drivers finally recognize the S2-3200!

But now I'm stuck again, and it seems to me this is a problem which has 
been faced, and fixed, before - I just can't fix it now because 
apparently so much has changed that all the patches don't work on the 
new source files anymore: any hacked "scan" or "szap" program won't compile.

(Keep in mind I'm using a switch between my S2-3200 card and my 4 LNBs - 
will this cause any problems?)

This is the problem you've no doubt seen before.

$ sudo scan /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E 
 >channels.conf

scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 5
 >>> tune to: 12551:v:0:22000
__tune_to_transponder:1491: ERROR: FE_READ_STATUS failed: 22 Invalid 
argument
 >>> tune to: 12551:v:0:22000
__tune_to_transponder:1491: ERROR: FE_READ_STATUS failed: 22 Invalid 
argument
ERROR: initial tuning failed
dumping lists (0 services)
Done.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
