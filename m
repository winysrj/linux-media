Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpgw01.world4you.com ([80.243.163.21])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <treitmayr@devbase.at>) id 1KozW9-0002x2-UK
	for linux-dvb@linuxtv.org; Sun, 12 Oct 2008 13:53:53 +0200
From: Thomas Reitmayr <treitmayr@devbase.at>
To: linux-dvb@linuxtv.org
Date: Sun, 12 Oct 2008 13:53:07 +0200
Message-Id: <1223812387.7633.12.camel@localhost>
Mime-Version: 1.0
Subject: [linux-dvb] Oops with dvb-usb-dib0700 on Marvell Orion ARM SOC
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
after installing kernel 2.6.27 I noticed the same kernel Oops described
here by Info Peukes:
  http://linuxtv.org/pipermail/linux-dvb/2008-May/025889.html

The patch from the same mail thread works perfectly on my device (a QNAP
TS-109 II featuring a Marvell Orion5x ARM SOC) -> no oops anymore and
perfect reception. As I have not found any follow-ups on this patch and
as it apparently did not get applied in HG, what is its status?

Best regards,
-Thomas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
