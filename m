Return-path: <linux-media-owner@vger.kernel.org>
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:11453 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751832AbaI3R32 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 13:29:28 -0400
Received: from unknown (HELO email.aon.at) ([172.18.1.196])
          (envelope-sender <klammerj@a1.net>)
          by fallback44.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-media@vger.kernel.org>; 30 Sep 2014 17:22:38 -0000
Received: from 80-123-5-59.adsl.highway.telekom.at (HELO [192.168.0.2]) ([80.123.5.59])
          (envelope-sender <klammerj@a1.net>)
          by smarthub76.res.a1.net (qmail-ldap-1.03) with SMTP
          for <linux-media@vger.kernel.org>; 30 Sep 2014 17:21:42 -0000
Message-ID: <542AE6A6.9000504@a1.net>
Date: Tue, 30 Sep 2014 19:21:42 +0200
From: Johann Klammer <klammerj@a1.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: saa7146_wait_for_debi_done_sleep timed out
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

After updating the kernel to 3.14.15 I am seeing these messages:

[273684.964081] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273690.020061] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273695.076082] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273700.132077] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273705.188070] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273710.244066] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273715.300187] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273720.356068] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273725.412188] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273730.468094] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273735.524070] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed
[273740.580176] saa7146: saa7146 (0): saa7146_wait_for_debi_done_sleep 
timed out while waiting for registers getting programmed

filling up the logs(one about every 5 seconds).

The TV card is a Terratec Cinergy 1200 DVBS (I believe.. it's rather old).

I can not observe any erratic behavior, just those pesky messages...

I see there was an earlier post here in 2008 about a similar 
problem...(Cinergy 1200 DVB-C... a coincidence?)

What does it mean?
Do I need to be worried?

I am using a debian testing on a 32 bit box.
The previous kernel was linux-image-3.12-1-486.
It did not show those messages, but maybe due to some configure 
options... I built this one from linux-source-3.14...

