Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Khb1q-0003jv-8u
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 04:19:59 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7K00JKFRRVX380@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 21 Sep 2008 22:19:08 -0400 (EDT)
Date: Sun, 21 Sep 2008 22:19:07 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48D688BE.80008@rogers.com>
To: Jonathan Coles <jcoles0727@rogers.com>
Message-id: <48D7009B.2000404@linuxtv.org>
MIME-version: 1.0
References: <48D688BE.80008@rogers.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] me-tv doesn't accept its own channel file
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

Jonathan Coles wrote:
> me-tv scans ATSC channels on my HVR-950Q and creates a channels.conf 
> file. The file has channel entries, even though the Channel Scan window 
> reports nothing but "Failed to tune" messages. But me-tv cannot use its 
> own file. It complains, "There's an invalid channel record in the 
> channels.conf file." Oh, come on! Was this application tested even once?
> 
> My file contains the following:
> 
> CKXTDT:509028615:8VSB:65:67:2
> CKXT:509028615:8VSB:81:83:3
> HDTV RADIO-CANADA OTTAWA:521028615:8VSB:49:52:11
> HDTV CBC OTTAWA:539028615:8VSB:49:52:10
> 
> (I live in Canada. Our TV stations have until 2011 to go digital and 
> they are moving slowly.)
> 
> A possible problem is the strange 2-byte character following "CKXTDT" in 
> the first line, hex 0810. Removing this line did not make the file 
> acceptable to me-tv.
> 
> Does anyone have experience with this glitch?

Looks like you have a weird control char on the first line.

Try removing this.

Also use 'azap -r CKTX' to see if you get lock.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
