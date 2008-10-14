Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from srv5.sysproserver.de ([78.46.249.130])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nicolai@xeve.de>) id 1KpqdD-0007G5-RD
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 22:36:40 +0200
Received: from [192.168.2.4] (p4FDB4C86.dip.t-dialin.net [79.219.76.134])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by srv5.sysproserver.de (Postfix) with ESMTP id 784FA1D88085
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 22:36:36 +0200 (CEST)
Message-ID: <48F502D7.5070607@xeve.de>
Date: Tue, 14 Oct 2008 22:36:39 +0200
From: Nicolai Spohrer <nicolai@xeve.de>
MIME-Version: 1.0
CC: linux-dvb <linux-dvb@linuxtv.org>
References: <48F4E054.4080304@linuxtv.org>
In-Reply-To: <48F4E054.4080304@linuxtv.org>
Subject: Re: [linux-dvb] S2API / TT3200 / STB0899 support
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

Works for me, too. (Linux 2.6.24)

[ 1032.781874] DVB: registering new adapter (TT-Budget S2-3200 PCI)
[ 1033.906035] adapter has MAC addr = 00:d0:5c:64:be:00
[ 1033.906310] input: Budget-CI dvb ir receiver saa7146 (0) as 
/devices/pci0000:00/0000:00:14.4/0000:02:02.0/input/input7
[ 1034.071011] stb0899_attach: Attaching STB0899
[ 1034.071055] stb6100_attach: Attaching STB6100
[ 1034.071458] DVB: registering frontend 0 (STB0899 Multistandard)...

Zapping to DVB-S channels works fine and I can watch them with mplayer 
or xine.
Zapping to DVB-S2 channels also works, but I can only watch the recorded 
.ts-files with mplayer (audio only). But that's not s2api's fault. Just 
got to work out the right mplayer options...

N.S.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
