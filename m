Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 202.7.249.79.dynamic.rev.aanet.com.au ([202.7.249.79]
	helo=home.singlespoon.org.au)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <paulc@singlespoon.org.au>) id 1KjQHj-0002gd-Bk
	for linux-dvb@linuxtv.org; Sat, 27 Sep 2008 05:15:56 +0200
Message-ID: <48DDA4CE.20205@singlespoon.org.au>
Date: Sat, 27 Sep 2008 13:13:18 +1000
From: Paul Chubb <paulc@singlespoon.org.au>
MIME-Version: 1.0
To: larrykathy3@verizon.net
References: <494928.55243.qm@web84108.mail.mud.yahoo.com>
In-Reply-To: <494928.55243.qm@web84108.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] geniatech x8000 hdtv
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

Hi Ruth,
              please do an lspci and lspci -n from a terminal and post 
the results.

Cheers Paul

Ruth Fernandez wrote:
> I have a geniatech x8000 hdtv card #63. I have installed v4l, firmware 
> and put modprobe cx88--dvb into rc.local. I use Ubuntu desktop 
> 2.6.24.19(latest). I did the blacklist and still the card is unkown to 
> the driver.     Larry
>
>
>  45.289876] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> [   45.289988] cx88[0]: Your board isn't known (yet) to the driver.  
> You can
> [   45.289990] cx88[0]: try to pick one of the existing card configs via
> [   45.289992] cx88[0]: card=<n> insmod option.  Updating to the latest
>
>
> -- 
> This message has been scanned for viruses and
> dangerous content by *MailScanner* <http://www.mailscanner.info/>, and is
> believed to be clean.
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
