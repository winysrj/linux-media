Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout.perfora.net ([74.208.4.195])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlenz@vorgon.com>) id 1JVuVi-0005ZB-LF
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 21:10:15 +0100
Message-ID: <000c01c87ca1$6a25cc20$0a00a8c0@vorg>
From: "Timothy D. Lenz" <tlenz@vorgon.com>
To: <linux-dvb@linuxtv.org>
Date: Sun, 2 Mar 2008 13:10:01 -0700
MIME-Version: 1.0
Subject: [linux-dvb] ATSC card support
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

I am looking into getting a ATSC tuner for my VDR system and am collecting
info on what is supported.  I would pefer a dual tuner. I'm also looking
into what tuner chipsets they use and how they compair to the  LG DT3303
which seems to be the current bench mark to aim for. Dual ATSC tuner
cards/devices I've found so far:

Cat's Eye 164e: Seems to be no linux support, chipset unknown

WinTV-HVR-2250: available in February 2008, linux support unknown, chipset
unknown

HDHomeRun: LAN connection, usable with MythTV, might work with vdr using
IPTV plugin?? Chipsets used:
    Rev 1.x uses the Oren CAS220 chipset.
    Rev 2.x uses the latest generation Micronas DRXJ chipset.
 One review I found for the HomRun said multipath tuning was close to the
qualty of the  pcHDTV HD-5500 which uses the LG chipset. Think he had the
Rev 1 but not sure. Can't find the link now.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
