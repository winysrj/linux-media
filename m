Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <udo_richter@gmx.de>) id 1LEZZx-0002jH-5l
	for linux-dvb@linuxtv.org; Mon, 22 Dec 2008 02:27:29 +0100
Message-ID: <494EECDD.6000106@gmx.de>
Date: Mon, 22 Dec 2008 02:26:53 +0100
From: Udo Richter <udo_richter@gmx.de>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] How to runtime-detect S2API kernel?
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

Hi list,


Is there an official safe way to detect S2API capable DVB drivers at 
runtime, so that a program compiled against S2API headers can check for 
S2API drivers and switch to old API otherwise?

Does it work to call FE_HAS_EXTENDED_CAPS? Do all old drivers return 
this flag under the new API, or only S2API-aware drivers?

Or is it better to call FE_SET_PROPERTY with num=0 commands? Does this 
always return success under S2API?


Cheers,

Udo

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
