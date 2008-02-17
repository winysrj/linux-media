Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from f148.mail.ru ([194.67.57.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JQgKs-0000dN-1p
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 11:01:26 +0100
From: Igor <goga777@bk.ru>
To: Zenon Mousmoulas <zmousm@admin.grnet.gr>
Mime-Version: 1.0
Date: Sun, 17 Feb 2008 13:00:54 +0300
References: <B9DD88E0-E3EA-4E57-BABE-5FD4E520D6F4@admin.grnet.gr>
In-Reply-To: <B9DD88E0-E3EA-4E57-BABE-5FD4E520D6F4@admin.grnet.gr>
Message-Id: <E1JQgKM-000I6q-00.goga777-bk-ru@f148.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?SGF1cHBhdWdlIFdpblRWLUhWUjQwMDAgYW5kIERW?=
	=?koi8-r?b?Qi1TMi4uLg==?=
Reply-To: Igor <goga777@bk.ru>
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> My goal is to get this card to tune to a DVB-S2 transponder, more  
> specifically this one:
> http://en.kingofsat.net/tp.php?tp=2656
> I have a dish with 4 LNBs connected to the HVR4000 through a DiSEqC  
> 1.0 4x1 switch.
> The 4th LNB is pointed to this satellite and I can tune to DVB-S  
> transponders there just fine with another card as well as this one  
> (more on that later).
> 
> I assume multiproto is necessary for DVB-S2 tuning to actually work.  
> Right? 

yes, right. Latest version of multiproto will help you.


> I am working on a Debian testing/lenny system. I have tried the above  
> with kernels 2.6.22 and 2.6.24. The sample kernel output on the wiki  
> says 2.6.26.1. What is the minimum kernel version that must be used  
> with multiproto in order for DVB-S2 to work?

I have 2.6.22 kernel and on my computer hvr4000 with multi[roto + hvr400-patch works well

> Could someone please help? 

next your step - to use the patched szap2. 

> One more thing: I've read about szap2 and perhaps other dvb-apps which  
> have been specifically made compatible with multiproto. I've noticed  
> these being casually mentioned in various list posts. However, I have  
> only been able to find a few somewhat old "traces" of szap2, and not,  
> say, a full patch against dvb-apps. Is there a distribution? Where at?

please, complile the szap2 and try it

here's you can find the links for download of szap2
http://allrussian.info/thread.php?postid=187408#post187408

Igor





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
