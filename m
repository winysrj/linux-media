Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:55126 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab2GSSdm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 14:33:42 -0400
Received: from [10.2.0.129] (unknown [10.2.0.129])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by 7of9.schinagl.nl (Postfix) with ESMTPSA id 2354924423
	for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 20:34:19 +0200 (CEST)
Message-ID: <50085326.1080104@schinagl.nl>
Date: Thu, 19 Jul 2012 20:34:14 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Actually working DVB cards, linuxtv.org wiki vague.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Since I'm not getting any feedback about the TechnoTrend DVB-T 1500 PCI 
and it's cam module, I'm thinking of going a different route. DVB-C. My 
ISP actually does transmit unencrypted DVB-C (if you pay for TV) so I 
may as well switch to DVB-C for now.

There are two potential devices I see.

Technisat CableStar HD2 [1]
This card may be slow PCI, but as far as I know far and far plenty of 
bandwith for DVB-C right? You can grab the entire transport-stream and 
still have BW left to spare? It is only a single tuner however (which is 
ok, the DVB-C signal is all on one transponder/frequency).

I see all modules mentioned from the wiki in the kernel, so while the 
wiki is outdated, it should work. But have people got experience with 
the reliability of this? Does it work and work fast?

The hardware cam is nice to have, but completely useless. Unless I could 
get a USB DVB-* device and feed it's transport stream through THAT cam 
interface.


Terratec Cinergy T PCIe Dual [2]
This card is also very interesting. It would steal one of the viewer 
available PCI-e sockets, it does feature a dual tuners. I believe you 
can tune either one DVB-C channel (+one analog channel, but that is 
really not important at all) or TWO dvb-T channels. This one does not 
feature a cam, but for DVB-C that is not important and for DVB-T, 
softcam could be the solution.

Anybody have any experience with this card? I found _some_ references in 
the 3.3.7 kernel I have on my desktop atm but appearantly 3.4.3 should 
work better.

I'm sorry for asking here, but I'm not quite sure where else to ask for 
decent supported cards, and my wallet has run dry from buying badly 
supported crap :(


[1] http://linuxtv.org/wiki/index.php/Technisat_CableStar_HD2
[2] http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_PCIe_dual
