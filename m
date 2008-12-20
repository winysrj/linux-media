Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jyrki.n@telia.com>) id 1LDw8U-0007cT-Lp
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 08:20:31 +0100
Received: from [192.168.128.33] (90.228.209.229) by
	pne-smtpout1-sn2.hy.skanova.net (7.3.129) (authenticated as
	u49403269) id 48A144C502155D8A for linux-dvb@linuxtv.org;
	Sat, 20 Dec 2008 08:19:57 +0100
Message-ID: <494C9CA8.6010500@telia.com>
Date: Sat, 20 Dec 2008 08:20:08 +0100
From: Jyrki Niskala <jyrki.n@telia.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <492D441D.1050108@telia.com>
In-Reply-To: <492D441D.1050108@telia.com>
Subject: Re: [linux-dvb] Can't get signal lock with Hauppauge Nova TD-500
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

Jyrki Niskala wrote:
> Hello
>
> I'm stucked here with a problem with a new Hauppauge card called Nova 
> TD-500.
> When tuning, I got lock on 4 of 5 muxes.  The fifth, non working mux, is 
> at 778 MHz.
> It's same behaviour on both tuners, with tzap or MythTV,  with or 
> without lna option.
> I have also tried with another computer with same result.
> The signal is not a problem. I have 3 other dvb-t cards up and running 
> for the moment...
> All muxes are from 538 MHz to 778 MHz (64 QAM, 8 MHz bandwith, 8k 
> transmission mode)
>
>   
Hi again,

For completeness and reference for others I need to close this issue.

By comparing usbsnoop logs from Windows driver with source code of the 
demod (dib7000p) I found out that the windows driver is using auto guard 
interval when tuning. My channel configurations,  tzap and MythTV, was 
using manual guard interval at 1/8.  After changing my configurations to 
use auto guard interval I got 5:th mux working.
Now the card is back in duty ...

Merry Christmas,

/ Jyrki


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
