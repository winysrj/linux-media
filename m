Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1L4DBJ-0007fT-0s
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 12:31:13 +0100
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1L4DBD-0001FW-EG
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 11:31:07 +0000
Received: from 81.210.216.21 ([81.210.216.21])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 11:31:07 +0000
Received: from chris.ace by 81.210.216.21 with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 11:31:07 +0000
To: linux-dvb@linuxtv.org
From: Christian Tramnitz <chris.ace@gmx.net>
Date: Sun, 23 Nov 2008 12:30:57 +0100
Message-ID: <ggbetk$2pc$1@ger.gmane.org>
References: <E1KvSWe-0000jN-8W@www.linuxtv.org>	<200810302359.11772.liplianin@tut.by>	<200811091656.03941.liplianin@tut.by>
	<49271FB5.1040805@gmail.com>
Mime-Version: 1.0
In-Reply-To: <49271FB5.1040805@gmail.com>
Subject: Re: [linux-dvb] [PATCH] TT S2-3200: Support for high symbol rates.
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

Manu Abraham wrote:
> The STB0899 is never rated to run at 135MHz clock. Some older die cuts
> would even cause clock race arounds at even 108MHz. The recommended
> maximum clock is 99 MHz at maximum.

Hi Manu,

do you have more detailed information about this, i.e. how to find out 
the hw revision that would be affected?

Igor, are there any dependencies in your repository on the higher clock 
rate or can we just lower it so 99 again to be on the safe side?

Best regards,
    Christian


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
