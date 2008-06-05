Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web86703.mail.ukl.yahoo.com ([217.12.13.35])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <stuart_morris@talk21.com>) id 1K4IQK-0001TN-1V
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 18:34:48 +0200
Date: Thu, 5 Jun 2008 17:34:14 +0100 (BST)
From: Stuart Morris <stuart_morris@talk21.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <502885.47327.qm@web86703.mail.ukl.yahoo.com>
Subject: [linux-dvb]  How to get a PCTV Sat HDTC Pro USB (452e) running?
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

Dominik
Thanks for your work on the pctv452e/tts23600 driver.
I intend to purchase a
tt 3600 at some point soon so I have not yet used the
driver, but I have a
couple of comments.

I have recently patched multiproto plus with the
pctv452e/tts23600 patch set
and noticed a problem with VDR 1.7.0.
The patch to linux/include/linux/dvb/frontend.h
towards the end of
patch_multiproto_pctv452e_tts23600.diff causes a
compile error with VDR 1.7.0.
It's not obvious what this patch is for.

There is also a patch to
linux/include/linux/dvb/video.h. Are the patches to
the dvb headers really necessary? Is this intentional?



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
