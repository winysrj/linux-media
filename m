Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1KZiy7-0001w9-Hv
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 11:11:35 +0200
Message-ID: <48BA6019.10705@chaosmedia.org>
Date: Sun, 31 Aug 2008 11:10:49 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: Goga777 <goga777@bk.ru>,
	LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
References: <20080830213831.7b8e2c42@bk.ru>
In-Reply-To: <20080830213831.7b8e2c42@bk.ru>
Subject: Re: [linux-dvb] cat: /dev/dvb/adapter0/dvr0: Value too large for
 defined data type
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



Goga777 wrote:
>
> env LANG=C cat /dev/dvb/adapter0/dvr0 | ffplay - 
>
>   
> "cat: /dev/dvb/adapter0/dvr0: Value too large for defined data type"
>
> is it possible to fix it ?
>
>   
i usually have better results with dd

i don't remember the exact command line but it should be something like :

dd id=/dev/dvb/adapter0/dvr0 conv=noerror | mplayer -

but it's not perfect and also suffer buffer problem, i know you can set some buffer sizes with dd but i couldn't get something working flawlessly

try googling "dd dvr0 mplayer" you may find some more clues..


Marc


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
