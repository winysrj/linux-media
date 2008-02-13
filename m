Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp-out28.alice.it ([85.33.2.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sarkiaponius@alice.it>) id 1JPPgz-0003GO-8m
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 23:03:01 +0100
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by debian (Postfix) with ESMTP id 4760B1040BD
	for <linux-dvb@linuxtv.org>; Wed, 13 Feb 2008 23:00:05 +0100 (CET)
Message-ID: <47B36863.9000804@alice.it>
Date: Wed, 13 Feb 2008 23:00:03 +0100
From: Andrea Giuliano <sarkiaponius@alice.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Signal strength: szap vs. femon, which is right?
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

Hi.

Since I'm having problem receiving many national channels with my brand 
new KWorld DVB-S 100, I suspect that the signal is not strong enough for 
the card (it is instead strong enough for my standalone FTA receiver).

I'm using szap to tune the channels that scan found, but it says the 
signal is about 0500. Somewhere I read that a good signal is above 8000, 
so the signal indicated by szap is more or less equivalent to no signal 
at all. But I can watch many channels, so the signal cannot be so bad.

Actually, femon reports much higher value instead, about 6900, never 
above 7000. It's les than the "good" value of 8000, but not so far away 
from it.

Which of these values is right? The one shown by szap or the one shown 
by femon?

Also, since the higher of them is still too low, could it be the reason 
why many channels are not found by scan?

Is there a way to improve the signal, or the card sensitivity?

Best regards.

-- 
Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
