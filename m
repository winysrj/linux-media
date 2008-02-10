Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from matrix.start.ca ([204.101.248.1])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <colbec@start.ca>) id 1JOHqp-0000cR-FK
	for linux-dvb@linuxtv.org; Sun, 10 Feb 2008 20:28:31 +0100
Received: from [192.168.0.3] (165.154.24.135.auracom.com [165.154.24.135] (may
	be forged))
	by matrix.start.ca (8.13.6/8.12.11) with ESMTP id m1AJSLq8013437
	for <linux-dvb@linuxtv.org>; Sun, 10 Feb 2008 14:28:22 -0500
Message-ID: <47AF5063.4000104@start.ca>
Date: Sun, 10 Feb 2008 14:28:35 -0500
From: Colin <colbec@start.ca>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Error in scan.c - tune to transponder?
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

Running SuSe 10.1, kernel 2.6.24-default, dvbtools 1.1.1, Kaffeine 0.8.6

I have 8 DVB-S lnbs on 2 diseqc switches running into 2 PCI cards, 
Skystar 2 and Geniatech 103G, both of which are supported in the kernel. 
The dishes, lnbs and cards are fine, work well in Windows and with 
standalone receivers Coolsat 6000 and Mercury II.

Kaffeine can scan and display channels from 6 of the 8 lnbs using the 
diseqc switches. I am trying to find out why the other two dishes are 
not tuned. So I started scan which returns the following on all adapter 
/ diseqc combinations:

__tune_to_transponder:1483 ERROR Setting frontend parameters failed: 22 
Invalid argument.

The relevant section of scan.c is

if (ioctl(frontend_fd, FE_SET_FRONTEND, &p) == -1) {
		errorn("Setting frontend parameters failed");
		return -1;
	}

Any suggestions?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
