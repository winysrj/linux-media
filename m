Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.wnex.hu ([87.229.43.150] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <szab100@bytestorm.hu>) id 1JW8xW-0005CG-DG
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 12:35:54 +0100
Received: from localhost (localhost [127.0.0.1])
	by mail.wnex.hu (Postfix) with ESMTP id 3EFCA1A9D75B
	for <linux-dvb@linuxtv.org>; Mon,  3 Mar 2008 12:35:10 +0100 (CET)
Received: from mail.wnex.hu ([127.0.0.1])
	by localhost (mail.wnex.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dPTFQgjFB0DH for <linux-dvb@linuxtv.org>;
	Mon,  3 Mar 2008 12:35:01 +0100 (CET)
Received: from [192.168.1.2] (catv5403388D.pool.t-online.hu [84.3.56.141])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mail.wnex.hu (Postfix) with ESMTP id B1C6C1A9D748
	for <linux-dvb@linuxtv.org>; Mon,  3 Mar 2008 12:35:01 +0100 (CET)
Message-ID: <47CBD458.6040101@bytestorm.hu>
Date: Mon, 03 Mar 2008 11:35:04 +0100
From: =?ISO-8859-1?Q?Fr=FChwald_Szabolcs?= <szab100@bytestorm.hu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Leadtek TV2000XP Global - stopped working with newest
	version
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


 I've a leadtek tv2000XP Global card, and i was able to make it work 
with v4l-dvb mercurial 1 week ago. Now with the newest source tree its 
not working, recognised by kernel and everything seems to be ok, but 
tvtime/xawtv shows black screen instead of tv picture. Audio seems to be 
ok (sssshhh) but the strange thing is it cannot tune into any channel, 
audio still sssshhh and the picture is still black.

Anybody knows what's the problem??
The card's number (card=) has been changed from 59 -> 61

The card was running really ok with source tree i downloaded 1week 
before, i could tune into channels and both picture and sound was clear.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
