Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from roope.top.tkukoulu.fi ([192.103.98.2])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tpeland@tkukoulu.fi>) id 1JYg43-0001dD-CX
	for linux-dvb@linuxtv.org; Mon, 10 Mar 2008 12:21:44 +0100
Received: from localhost (localhost [127.0.0.1])
	by roope.top.tkukoulu.fi (Postfix) with ESMTP id 33DAE231997
	for <linux-dvb@linuxtv.org>; Mon, 10 Mar 2008 13:17:11 +0200 (EET)
Date: Mon, 10 Mar 2008 13:17:10 +0200
From: Tero Pelander <tpeland@tkukoulu.fi>
To: linux-dvb@linuxtv.org
Message-ID: <20080310111710.GA27766@tkukoulu.fi>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] illegal bandwith value,
	driver for Terratec Cinergy DT usb XS
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

The driver in linux kernel 2.6.24.2 for "Terratec Cinergy DT usb XS 
diversity" sets the reported bandwith outside the fe_bandwidth_t range. 
The value 0 (BANDWIDTH_8_MHZ) is replaced with 8000. Here is an example 
showing the problem...

Device: Terratec Cinergy DT usb xs diversity
Linux: 2.6.24.2 (modules: mt2266, dvb_usb_dib0700)
Firmware: dvb-usb-dib0700-1.10.fw


Received event for frontend 0

Status for frontend 0 is now:
   0 (no signal)

Reported parameters for frontend 0 are now:
   Frequency: 714000000 Hz
   Inversion: AUTO (2)
   Bandwidth: 8 (0)
   High priority stream code rate: AUTO (9)
   Low priority stream code rate: AUTO (9)
   Constellation: QAM64 (3)
   Transmission mode: AUTO (2)
   Guard interval: AUTO (4)
   Hierarchy information: AUTO (4)

Received event for frontend 0

Status for frontend 0 is now:
   FE_HAS_SIGNAL (found something above the noise level)
   FE_HAS_CARRIER (found a DVB signal)
   FE_HAS_VITERBI (FEC is stable)
   FE_HAS_SYNC (found sync bytes)
   FE_HAS_LOCK (everything's working)

Reported parameters for frontend 0 are now:
   Frequency: 714000000 Hz
   Inversion: AUTO (2)
   Bandwidth: ??? (8000)
   High priority stream code rate: 2/3 (2)
   Low priority stream code rate: 1/2 (1)
   Constellation: QAM64 (3)
   Transmission mode: 8K (1)
   Guard interval: 1/8 (2)
   Hierarchy information: NONE (0)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
