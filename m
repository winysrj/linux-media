Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.189.19.216] (helo=mail.strictly-it.nl)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <jerremy@wordtgek.nl>) id 1KdoRS-0006aq-2x
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 17:50:48 +0200
MIME-Version: 1.0
Date: Thu, 11 Sep 2008 17:50:31 +0200
From: <jerremy@wordtgek.nl>
To: linux-dvb@linuxtv.org
Message-ID: <487bc33a2b1e54ddc6fb62745bfc02c6@10.0.0.2>
Subject: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
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

This issue has come up at least once a bit more then a month ago and is
still present in the current release of the V4L-DVB drivers. The
Technotrend C-1501 drivers are unable to get a lock on 388Mhz (and a couple
of other frequencies, like 682Mhz and 322Mhz, but I can only test 388Mhz). 

The dmesg will mention an I2C timeout when this occurs, I'm not sure if its
related (as it'll randomly give those timeouts when viewing working
channels too).

I have two seperate installs of Linux (Ubuntu 8.04 64-Bit with 1 received
and Ubuntu 8.04 32-Bit with 2 receivers) which both suffer the same
inability to lock onto that frequency. So its unlikely to be a hardware
problem, also the Windows drivers do not seem to have any issues.

Is anyone looking into this issue? If not, what would be the place to
experiment?

Gr,

Jerremy Koot



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
