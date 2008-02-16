Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from matrix.start.ca ([204.101.248.1])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <colbec@start.ca>) id 1JQUCP-0002y6-5G
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 22:03:53 +0100
Received: from [192.168.0.3] (165.154.24.241.auracom.com [165.154.24.241] (may
	be forged))
	by matrix.start.ca (8.13.6/8.12.11) with ESMTP id m1GL3hXD030069
	for <linux-dvb@linuxtv.org>; Sat, 16 Feb 2008 16:03:43 -0500
Message-ID: <47B74FC2.5040507@start.ca>
Date: Sat, 16 Feb 2008 16:04:02 -0500
From: Colin <colbec@start.ca>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Can get channels in Kaffeine, but scan fails
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Getting G13 with a Skystar II 2.6, channels strong in Kaffeine
kernel 2.6.24, SuSe 10.1, Kaffeine 0.8.6, dvbtools 1.1.1

scan -c (while tuned to a channel) works fine. But :
-------------------------------------
/scan # ./scan -vvvv -a 0 -s 3 ./dvb-s/g13--cb
scanning ./dvb-s/g13--cb
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 3800000 H 27690000 3
 >>> tune to: 3800:h:3:27690
DiSEqC: switch pos 3, 18V, loband (index 13)
diseqc_send_msg:59: DiSEqC: e0 10 38 fe 00 00
Frontend fd is '3', FE_SET_FRONTEND is '1076129612'
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 
22 Invalid argument
 >>> tune to: 3800:h:3:27690
DiSEqC: switch pos 3, 18V, loband (index 13)
diseqc_send_msg:59: DiSEqC: e0 10 38 fe 00 00
Frontend fd is '3', FE_SET_FRONTEND is '1076129612'
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 
22 Invalid argument
ERROR: initial tuning failed
dumping lists (0 services)
Done.
----------------------------------------

Pls note I added an info() statement to get the values being sent to 
frontend_fd and fe_set_frontend. Do these values look acceptable, or am 
I looking in the wrong place?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
