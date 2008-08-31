Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f106.mail.ru ([194.67.57.205])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KZjOD-0003X4-Nn
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 11:38:34 +0200
Received: from mail by f106.mail.ru with local id 1KZjNf-000GHD-00
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 13:37:59 +0400
From: Goga777 <goga777@bk.ru>
To: LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
Mime-Version: 1.0
Date: Sun, 31 Aug 2008 13:37:59 +0400
In-Reply-To: <48BA6019.10705@chaosmedia.org>
References: <48BA6019.10705@chaosmedia.org>
Message-Id: <E1KZjNf-000GHD-00.goga777-bk-ru@f106.mail.ru>
Subject: Re: [linux-dvb]
	=?koi8-r?b?Y2F0OiAvZGV2L2R2Yi9hZGFwdGVyMC9kdnIwOiBW?=
	=?koi8-r?b?YWx1ZSB0b28gbGFyZ2UgZm9yZGVmaW5lZCBkYXRhIHR5cGU=?=
Reply-To: Goga777 <goga777@bk.ru>
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

> > env LANG=C cat /dev/dvb/adapter0/dvr0 | ffplay - 
> >
> >   
> > "cat: /dev/dvb/adapter0/dvr0: Value too large for defined data type"
> >
> > is it possible to fix it ?
> >
> >   
> i usually have better results with dd
> 
> i don't remember the exact command line but it should be something like :
> 
> dd id=/dev/dvb/adapter0/dvr0 conv=noerror | mplayer -
> 
> but it's not perfect and also suffer buffer problem, i know you can set some buffer sizes with dd but i couldn't get something working flawlessly
> 
> try googling "dd dvr0 mplayer" you may find some more clues..

seems to me it's temporary solutiuon. How to fix this bug if I will use the software like VDR , not szap2 & MPlayer ?

Goga

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
