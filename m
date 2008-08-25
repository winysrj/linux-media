Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KXdIJ-0007eC-Hn
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 16:43:48 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K65004CGVK03U60@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 25 Aug 2008 10:43:12 -0400 (EDT)
Date: Mon, 25 Aug 2008 10:43:12 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <002801c9062b$141c01f0$3c5405d0$@net>
To: Dustin Coates <dcoates@systemoverload.net>
Message-id: <48B2C500.6010906@linuxtv.org>
MIME-version: 1.0
References: <1219545012.23807.1.camel@sysmain> <48B16766.7070306@linuxtv.org>
	<002801c9062b$141c01f0$3c5405d0$@net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1800 Analog issues
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

Dustin Coates wrote:
> Thanks. 
> 
> I got all the modules loaded, but lspci -vnn is still show it as
> unreconized. 
>   
> 02:00.0 Multimedia video controller [0400]: Conexant Unknown device
> [14f1:8880] (rev 0f)
> 	Subsystem: Hauppauge computer works Inc. Unknown device [0070:7801]
> 	Flags: bus master, fast devsel, latency 0, IRQ 16
> 	Memory at e9000000 (64-bit, non-prefetchable) [size=2M]
> 	Capabilities: <access denied>

That's normal. It means the PCI database of strings needs a patch. It 
does not effect driver behavior.

<cut>

> 
> I have the HVR-1800 MCE kit edition
> 
> Also another issue, don't know if this is mythtv relateed or drive
> related. 
> 
> When i set the card up in mythtv is /dev/video0 lets me choos
> television/s-video/composite whereas /dev/video1 is stuck on unset. 
> 
> Anything i can do to help? It's been ages since i've programmed, but i
> have a high learning curve. 

Does it work in MythTV, even though it's set to unset?

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
