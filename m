Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate01.web.de ([217.72.192.221])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <martinpauly@web.de>) id 1LGu9q-00063o-Jz
	for linux-dvb@linuxtv.org; Sun, 28 Dec 2008 12:50:11 +0100
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate01.web.de (Postfix) with ESMTP id 4C393FB239EA
	for <linux-dvb@linuxtv.org>; Sun, 28 Dec 2008 12:49:37 +0100 (CET)
Received: from [79.233.70.181] (helo=[192.168.2.101])
	by smtp07.web.de with asmtp (WEB.DE 4.110 #273) id 1LGu9J-0004Ee-00
	for linux-dvb@linuxtv.org; Sun, 28 Dec 2008 12:49:37 +0100
From: Martin Pauly <martinpauly@web.de>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1230340151.6819.16.camel@martin>
References: <1230340151.6819.16.camel@martin>
Date: Sun, 28 Dec 2008 12:49:36 +0100
Message-Id: <1230464976.6668.1.camel@martin>
Mime-Version: 1.0
Subject: [linux-dvb] AverTv Hybrid Nano Express
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


Hi,

I've been trying to install my AverTv Hybrid Nano Express.
Until now I had no succes. I created a page in the wiki for this card.
but here is my problem: I'm using ubuntu 8.10. I installed the LinuxTV
drivers via mercurial. 
I got no /dev/dvb folder. But in /dev/.static/dev/dvb/  I have adapters
0 to 3 listed, each one a folder, with textfiles(audio0, ca0, ...) in
them, each of them with size 0 bytes. 
Anybody any ideas how I could make it work?
or is this something about my setup (i use a crypted partition and
ubuntu)? 

thanks for any help
regards,
martin



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
