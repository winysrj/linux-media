Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JYUwh-0007Rn-AX
	for linux-dvb@linuxtv.org; Mon, 10 Mar 2008 00:28:50 +0100
Message-ID: <47D472A4.8040306@linuxtv.org>
Date: Sun, 09 Mar 2008 19:28:36 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: aldebaran <aldebx@yahoo.fr>
References: <47D4674B.6010603@yahoo.fr>
In-Reply-To: <47D4674B.6010603@yahoo.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] ~stoth/cx23885-video compile failure
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

aldebaran wrote:
> I own an HP/Hauppauge WinTv885 mod 77001 with cx23885 and xc3028 chipsets.
>
> Following the threads on this mailing list I understood these chipsets were supported by 
> http://linuxtv.org/hg/~stoth/cx23885-video code, however I cannot even get past the 'make all'.
>
> [snip]
> Is it a bug?
> Were I supposed to do something?
> Thank you.
>   
your card is supported in the master repository:

http://linuxtv.org/hg/v4l-dvb

If you continue to see these types of errors, please post again.  While waiting for a response, you can get past those errors by disabling the offending driver from the build.  try 'make menuconfig'.

hth,

Mike




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
