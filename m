Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <n.wagenaar@xs4all.nl>) id 1KhPAA-0002bd-IK
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 15:39:47 +0200
From: =?us-ascii?Q?Niels_Wagenaar?= <n.wagenaar@xs4all.nl>
To: =?us-ascii?Q?Manu_Abraham?= <abraham.manu@gmail.com>
Date: Sun, 21 Sep 2008 15:39:36 +0200
Mime-Version: 1.0
Message-Id: <vmime.48d64e98.2764.5267ca3d1c0e6acb@shalafi.ath.cx>
Cc: linux-dvb@linuxtv.org
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

-----Original message-----
From: Manu Abraham <abraham.manu@gmail.com>
Sent: Sun 21-09-2008 15:27
To: Niels Wagenaar <n.wagenaar@xs4all.nl>; 
CC: linux-dvb@linuxtv.org; 
Subject: Re: [linux-dvb] Full Mantis pull with TerraTec Cinergy S2 PCI HD hangs system on boot

> -- SNIP --
>
> Is this the offending changeset ?
> 
> http://jusst.de/hg/mantis/rev/e466a650ef20
> 

I think it is. An other person I know, did a pull on 16 September. And he didn't encounter the problems as I and others had this weekend. And yes, the other three persons tried the installation since last friday(-evening). So it's a good bet, that the changeset is indeed the problematic one.

The reason for why several people had this problems, is because they all wanted to test VDR. And this DVB-S2 card is one of the cheapest to buy over here in the Netherlands.  

> Regards,
> Manu
> 

Regards,

Niels Wagenaar

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
