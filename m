Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from correo.cdmon.com ([212.36.74.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jordi@cdmon.com>) id 1LKTTv-0007yF-TD
	for linux-dvb@linuxtv.org; Wed, 07 Jan 2009 09:09:40 +0100
Received: from localhost (localhost.cdmon.com [127.0.0.1])
	by correo.cdmon.com (Postfix) with ESMTP id 8C669130E60
	for <linux-dvb@linuxtv.org>; Wed,  7 Jan 2009 09:09:04 +0100 (CET)
Received: from correo.cdmon.com ([127.0.0.1])
	by localhost (correo.cdmon.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 9oucQEZJOIN6 for <linux-dvb@linuxtv.org>;
	Wed,  7 Jan 2009 09:09:01 +0100 (CET)
Received: from [192.168.0.174] (62.Red-217-126-43.staticIP.rima-tde.net
	[217.126.43.62])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by correo.cdmon.com (Postfix) with ESMTP id 059A3130DBF
	for <linux-dvb@linuxtv.org>; Wed,  7 Jan 2009 09:09:00 +0100 (CET)
Message-ID: <49646315.20709@cdmon.com>
Date: Wed, 07 Jan 2009 09:08:53 +0100
From: Jordi Moles Blanco <jordi@cdmon.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] support for remote in lifeview pci trio
Reply-To: jordi@cdmon.com
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

hi,

i've been googling and trying some things during days with no luck.

i want to get the remote which comes with this card working, and i only 
found old posts like this one:

http://www.spinics.net/lists/vfl/msg29862.html

which assures that the patch gets the remote to work on that card.

i downloaded the latest v4l source code and tried to patch it with the 
code proposed on that post, but var names have changed and i don't have 
a clue on how to apply it properly.

i haven't seen any more recent post, so i guess it may still be in a 
to-do list, or may be it was rejected for some reason to go into the 
main-line.

Could anyone tell me if this patch will ever be included? or... what v4l 
version could i download to be able to patch it as described?

Thanks.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
