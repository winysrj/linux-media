Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <n.wagenaar@xs4all.nl>) id 1KhOkg-0000ah-0k
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 15:13:26 +0200
Received: from shalafi.ath.cx (shalafi-old.xs4all.nl [82.95.219.165])
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id m8LDDHVe040927
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 15:13:22 +0200 (CEST)
	(envelope-from n.wagenaar@xs4all.nl)
Received: from shalafi.ath.cx (localhost [127.0.0.1])
	by shalafi.ath.cx (8.14.2/8.14.2/Debian-2build1) with ESMTP id
	m8LDDHSk022977
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 15:13:17 +0200
From: =?us-ascii?Q?Niels_Wagenaar?= <n.wagenaar@xs4all.nl>
To: linux-dvb@linuxtv.org
Date: Sun, 21 Sep 2008 15:13:17 +0200
Mime-Version: 1.0
Message-Id: <vmime.48d6486d.2764.1cf647ed6cec189b@shalafi.ath.cx>
Subject: Re: [linux-dvb] Full Mantis pull with TerraTec Cinergy S2 PCI HD
 hangs system on boot
Reply-To: n.wagenaar@xs4all.nl
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

Hello All,

Currently I have some more information. When using the repo from http://jusst.de/hg/mantis.old and compile it (I didn't change the ID) it works. It boots Linux, it's detected and the /dev/dvb/adapter0 folder has contents.

Next thing is to test if it works with VDR. But I should warn you that other use the location as discribed in the Wiki. And upto three people have problems with the tutorial in combination with the TerraTec Cinergy S2 PCI HD where the system hangs on boot or during a manual modprobe.

Regards,

Niels Wagenaar

-----Original message-----
From: Niels Wagenaar <n.wagenaar@xs4all.nl>
Sent: Sun 21-09-2008 13:49
To: linux-dvb@linuxtv.org; 
Subject: Re: [linux-dvb] Full Mantis pull with TerraTec Cinergy S2 PCI HD hangs system on boot

> On smaller detail, when using modprobe I get fatal errors and the message: 
> "Mantis disagrees on symbol formats" for about 8 times. The message may not be 
> entirely correct, because soon the system hang again.
> 
> Regards,
> 
> Niels Wagenaar
> 
> > -----Oorspronkelijk bericht-----
> > Van: n.wagenaar@xs4all.nl [mailto:linux-dvb-bounces@linuxtv.org] Namens
> > Niels Wagenaar
> > Verzonden: zondag 21 september 2008 0:57
> > Aan: linux-dvb@linuxtv.org
> > Onderwerp: [linux-dvb] Full Mantis pull with TerraTec Cinergy S2 PCI HD
> > hangs system on boot
> > 
> > Hello All,
> > 
> > For a friend of mine, I'm setting up a HTPC based upon Xubuntu 8.04 and
> > VDR. Currently he has a Terratec TerraTec Cinergy S2 PCI HD and I
> > followed the Wiki for this card. I pull the latest Mantis and changed
> > the ID in mantis_vp1041.h as it's told in the Wiki.
> > 
> > However. When rebooting, the system hangs and doesn't want to continue
> > booting. I also found out that other people experience the same
> > problem.
> > 
> > So I think that the Wiki is not entirely up-to-date anymore. Could
> > somebody give me some more information how to get the TerraTec Cinergy
> > S2 PCI HD working?
> > 
> > Thanks in advance,
> > 
> > Niels Wagenaar
> > 
> > 
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
