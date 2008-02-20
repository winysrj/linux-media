Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail144.messagelabs.com ([216.82.254.51])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <Greg.Wickham@aarnet.edu.au>) id 1JRj3Z-0007U2-BX
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 08:07:53 +0100
Received: from vm-a-ex1.ms.aarnet.edu.au (vm-a-ex1.ms.aarnet.edu.au
	[202.158.212.104])
	by clix.aarnet.edu.au (8.12.11.20060308/8.12.11) with ESMTP id
	m1K77OZW022353
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 18:07:24 +1100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Wed, 20 Feb 2008 18:04:49 +1100
Message-ID: <964C943783CDCE4BBA0CE327AA8E7BA5015F0C44@vm-a-ex1.ms.aarnet.edu.au>
From: "Greg Wickham" <Greg.Wickham@aarnet.edu.au>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Problems - 2.6.24 + HG + Mantis 1034 = No lock
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


Hi All,

The hardware is a Mantis 1034 card.

I've just tried Linux 2.6.24 with a HG clone from
http://jusst.de/hg/mantis and unfortunately with the software I was
using I can't get a lock.

Should this combination work? (It compiles cleanly).

Any hints as to what to do?

I've added verbose flags to both the mb86a16 and mantis modules but
nothing obviously wrong is identifiable.

Tia,

   -greg

--

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
