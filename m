Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.cooptel.qc.ca ([216.144.115.12] helo=amy.cooptel.qc.ca)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rlemieu@cooptel.qc.ca>) id 1KQXcQ-00028O-Br
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 03:15:16 +0200
Message-ID: <4898FAFC.4030403@cooptel.qc.ca>
Date: Tue, 05 Aug 2008 21:14:36 -0400
From: Richard Lemieux <rlemieu@cooptel.qc.ca>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems using DISEQC with TBS 8920 DVB-S2 card
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





Johannes Michler wrote:
> Hi,
>  
> I recently got an TBS 8920 DVB-S2 card and I'm now trying to get it work 
> using Ubuntu 8.04.
> Since the card wasn't automatcially detected and the list appearing when 
> loading the cx88xx driver doesn't contain the card I downloaded the 
> drivers from here: http://www.tbsdtv.com/english/product/PCIDVBS2.html
> I compiled and installed the drivers as descripted, and after a reboot 
> the card was propely detected.
> 
I also installed the 8920 a couple of weeks ago.  I installed
the driver from the dvd that comes with the card.

The driver file from the web is named the same as the one on
the distribution DVD: v4l-dvb-0776e4801991.tar.gz

The driver works fine and the card scans properly with Kaffeine.  I
scanned Galaxy3C and Galaxy25 and I can tune all non-encrypted channels
on those satellites.

However 'scan' from both the latest version of dvb-apps and and
from version 1.1.1 won't find any channel.  I get "tuning failed".
I use a single Universal LNB.

I was surprised that you at least got a channel list from "A". So,
there might be a bug in the TBS driver.  But how is it that Kaffeine
succeeds?

My satelitte configuration is as follows: I've got a monoblock LNB, with
> Hotbird13 on "A" and Astra19 on "B"
> doing a "scan /usr/share/doc/dvb-utils/examples/scan/dvb-s/Hotbird" 
> reports me a lot of channels. But the diseq signal is being ignored, 
> when doing "scan -s 1 Hotbird" I get the same channels and doing "scan 
> -s 1 Astra" gives me no channels (scan is aborted after a view seconds, 
> saying it cannot do initial tuning)
...
>  
> best regards
> Johannes
> 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
