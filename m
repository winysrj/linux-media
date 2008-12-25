Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <Hartmut.Niemann@gmx.de>) id 1LFmBz-0003bA-NJ
	for linux-dvb@linuxtv.org; Thu, 25 Dec 2008 10:07:44 +0100
From: Hartmut Niemann <Hartmut.Niemann@gmx.de>
To: linux-dvb@linuxtv.org
Date: Thu, 25 Dec 2008 09:40:13 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812250940.13582.Hartmut.Niemann@gmx.de>
Subject: [linux-dvb] cx88 (Hauppauge Nova-S-Plus DVB-S) doesn't like to
	share interrupt?
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

Hello!
With debian stable (kernel 2.6.24-etchnhalf.1-686 #1 SMP) on AMD Athlon(tm) XP 2600+, 
MSI KT4AV (VIA KT400) my Hauppauge Nova-S-Plus DVB-S does not work well.

The DVB receiver used to share an interrupt with an 
USB / firewire combo interface board.
After a few minutes of viewing TV (kaffeine 0.8.3), the system started
skipping frames, until it displayed only 3 or 4 frames a second,
with heavily distorted audio. Sometimes stopping and restarting helps.

Since I moved the USB interface to a different PCI slot, this problem
seems to be gone.

This is a regression, because as far as I can remember,
when I set up the system some time ago,
it worked far better than now. But I can't tell which change in the system
did this.

Is this a known problem?
Would a dist upgrade to "debian testing" help?

With best regards 
Hartmut Niemann


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
