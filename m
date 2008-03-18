Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx1.melzone.de ([81.169.156.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@tvetc.de>) id 1JbjfP-0000HN-7g
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 22:48:20 +0100
Received: from uucp by mx1.melzone.de with local-rmail (Exim 4.60)
	(envelope-from <linux-dvb@tvetc.de>) id 1JbjfL-0006el-16
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 22:48:15 +0100
Received: by jericho.melzone.de with esmtp (Exim 4.62 #1) id 1JbjE7-0000rE-82
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 22:20:07 +0100
Date: Tue, 18 Mar 2008 22:20:06 +0100 (CET)
From: Karim 'Kasi Mir' Senoucci <linux-dvb@tvetc.de>
To: LinuxTV mailing list <linux-dvb@linuxtv.org>
In-Reply-To: <47DB1DEA.9080401@gmx.net>
Message-ID: <Pine.LNX.4.61.0803182213250.30766@jericho.melzone.de>
References: <Pine.LNX.4.61.0803142323470.11774@jericho.melzone.de>
	<47DB1DEA.9080401@gmx.net>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Terratec Cinergy DVB C PCI CI - CI working?
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

Hello all, 
On Sat, 15 Mar 2008, P. van Gaans wrote:

> Did you get the latest v4l-dvb from http://linuxtv.org/repo/?

I did. 

[...] 
> When you insert your CAM, you should be able to read some message with 
> dmesg about the card having been initialized or having failed. You 
> should also have a /dev/dvb/adapterN/ca0.

Nothing appears in dmesg, nor does anything CI-related appear any other 
logfile that I know of. The only thing appearing over and over again in 
dmesg is "mantis start feed & dma" and "mantis stop feed and dma". 

Sadly, there is no "/dev/dvb/adapterN/ca0", either. 

[...]
> Also check your CI cable. They fail quite often.

CI, CAM and Smartcard are working perfectly with Windows, so I assume 
there's nothing wrong with the CI cable. 

Greetings
Kasi Mir


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
