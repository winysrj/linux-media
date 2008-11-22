Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout08.t-online.de ([194.25.134.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <halim.sahin@t-online.de>) id 1L3tRN-0003k6-VP
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 15:26:31 +0100
Date: Sat, 22 Nov 2008 15:26:23 +0100
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-dvb@linuxtv.org
Message-ID: <20081122142623.GA16146@halim.local>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] errormessages skystar2 rev 2.8b with latest v4l-dvb
	branch
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
I.ve installed latest drivers from http://linuxtv.org/hg/v4l-dvb.
My kernel is 2.6.26 kernel (debian lenny).

When I type 
modprobe b2c2_flexcop_pci 
I get:



[91664.058433] b2c2-flexcop: i2c master_xfer failed
[91664.058734] b2c2-flexcop: i2c master_xfer failed
[91664.058793] CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)
[91664.058851] CX24123: wrong demod revision: 87

The card seems to be working but I.ll do more tests.
What is the problem here.
BR.
Halim


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
