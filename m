Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KYWuY-0006XK-KM
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 04:06:59 +0200
Message-ID: <48B6083B.5000803@linuxtv.org>
Date: Wed, 27 Aug 2008 22:06:51 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Paul Gardiner <lists@glidos.net>
References: <48B5D5CF.3060401@glidos.net>
In-Reply-To: <48B5D5CF.3060401@glidos.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Looks like there's a new unsupported WinTV Nova T
 500	out there
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

Paul Gardiner wrote:
> Just trying to get MythTV up and running, plugged in my
> newly arrived WinTV Nova T 500 and no /dev/dvb directory
> appeared. It's not the known probelmatic Diversity version,
> but it does say v2.1 on the box, and it seems to have
> different chips. :-(
> 
> Just thought I'd warn people and maybe ask if anyone
> else has run into this.

What is the 5-digit model number of your PCI card?

Did you confirm that it doesn't work in the v4l-dvb master repository?

If that's the case, give me a few days and I'll push in a patch for it.

-MiKE

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
