Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp100.rog.mail.re2.yahoo.com ([206.190.36.78])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <jcoles0727@rogers.com>) id 1KhT2f-0005Zp-OI
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 19:48:19 +0200
Message-ID: <48D688BE.80008@rogers.com>
Date: Sun, 21 Sep 2008 13:47:42 -0400
From: Jonathan Coles <jcoles0727@rogers.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] me-tv doesn't accept its own channel file
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

me-tv scans ATSC channels on my HVR-950Q and creates a channels.conf 
file. The file has channel entries, even though the Channel Scan window 
reports nothing but "Failed to tune" messages. But me-tv cannot use its 
own file. It complains, "There's an invalid channel record in the 
channels.conf file." Oh, come on! Was this application tested even once?

My file contains the following:

CKXTDT:509028615:8VSB:65:67:2
CKXT:509028615:8VSB:81:83:3
HDTV RADIO-CANADA OTTAWA:521028615:8VSB:49:52:11
HDTV CBC OTTAWA:539028615:8VSB:49:52:10

(I live in Canada. Our TV stations have until 2011 to go digital and 
they are moving slowly.)

A possible problem is the strange 2-byte character following "CKXTDT" in 
the first line, hex 0810. Removing this line did not make the file 
acceptable to me-tv.

Does anyone have experience with this glitch?


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
