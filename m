Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-1.orange.nl ([193.252.22.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1Kikc4-0003TW-Un
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 08:46:11 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf6009.online.nl (SMTP Server) with ESMTP id CF1957000085
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 08:45:34 +0200 (CEST)
Received: from asterisk.verbraak.thuis (s55939d86.adsl.wanadoo.nl
	[85.147.157.134])
	by mwinf6009.online.nl (SMTP Server) with ESMTP id 9E14B7000084
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 08:45:30 +0200 (CEST)
Message-ID: <48DB3388.2030303@verbraak.org>
Date: Thu, 25 Sep 2008 08:45:28 +0200
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [RFC] Let the future decide between the two.
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

I have been following the story about the discussion of the future of 
the DVB API for the last two years and after seen all the discussion I 
would like to propose the following:

- Keep the two different DVB API sets next to one another. Both having a 
space on Linuxtv.org to explain their knowledge and how to use them.
- Each with their own respective maintainers to get stuff into the 
kernel. I mean V4L had two versions.
- Let driver developers decide which API they will follow. Or even 
develop for both.
- Let application developers decide which API they will support.
- Let distribution packagers decide which API they will have activated 
by default in their distribution.
- Let the end users decide which one will be used most. (Probably they 
will decide on: Is my hardware supported or not).
- If democracy is that strong one of them will win or maybey the two 
will get merged and we, the end users, get best of both worlds.

As the subject says: This is a Request For Comment.

Regards,

Michel (end user and application developer).


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
