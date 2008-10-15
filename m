Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f110.mail.ru ([194.67.57.230])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KpyDV-0001hG-Lf
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 06:42:38 +0200
Received: from mail by f110.mail.ru with local id 1KpyCw-0002md-00
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 08:42:02 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0
Date: Wed, 15 Oct 2008 08:42:02 +0400
In-Reply-To: <48F502D7.5070607@xeve.de>
References: <48F502D7.5070607@xeve.de>
Message-Id: <E1KpyCw-0002md-00.goga777-bk-ru@f110.mail.ru>
Subject: Re: [linux-dvb]
	=?koi8-r?b?UzJBUEkgLyBUVDMyMDAgLyBTVEIwODk5IHN1cHBv?=
	=?koi8-r?b?cnQ=?=
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

> [ 1032.781874] DVB: registering new adapter (TT-Budget S2-3200 PCI)
> [ 1033.906035] adapter has MAC addr = 00:d0:5c:64:be:00
> [ 1033.906310] input: Budget-CI dvb ir receiver saa7146 (0) as 
> /devices/pci0000:00/0000:00:14.4/0000:02:02.0/input/input7
> [ 1034.071011] stb0899_attach: Attaching STB0899
> [ 1034.071055] stb6100_attach: Attaching STB6100
> [ 1034.071458] DVB: registering frontend 0 (STB0899 Multistandard)...
> 
> Zapping to DVB-S channels works fine and I can watch them with mplayer 
> or xine.
> Zapping to DVB-S2 channels also works, but I can only watch the recorded 
> .ts-files with mplayer (audio only). But that's not s2api's fault. Just 
> got to work out the right mplayer options...

You can use the ffplay instead of mplayer. Ffplay can play h.264 stream from dvb-s2 channels

Goga

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
