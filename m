Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.22]:25699 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbeI1SlJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 14:41:09 -0400
Received: from mail.dobel.click
        by smtp.strato.de (RZmta 44.2 AUTH)
        with ESMTPSA id Q04b95u8SCBK8Ca
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-media@vger.kernel.org>;
        Fri, 28 Sep 2018 14:11:20 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Sep 2018 14:11:20 +0200
From: Markus Dobel <linux-media@spam.dobel.click>
To: linux-media@vger.kernel.org
Subject: cx23885 - regression between 4.17.x and 4.18.x
Message-ID: <1699f339dc035001865a42a1b1ad46f6@spam.dobel.click>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

First of all, sorry for not correctly replying to the thread. I just 
subscribed to the list yesterday, so I do not have the message in my 
inbox.

I am referring to this message: 
https://www.spinics.net/lists/linux-media/msg140286.html

My system also suffered from the problem that, with Kernel 4.18 my DVB 
card became unresponsive after a few hours. I am using tvheadend as a 
video recorder, and with Kernel 4.18, tvheadend started missing 
recordings, with log messages like the following:

   linuxdvb: Silicon Labs Si2168 : DVB-C #1 - poll TIMEOUT
   subscription: 0163: service instance is bad, reason: No input detected
   subscription: 0162: service instance is bad, reason: No input detected
   subscription: 0163: No input source available for subscription "DVR: 
..." to channel "..."

In this state, the DVB card was not usable until unloading the cx23885 
module and reloading it -- just to fail again few hours later.

Also, I noticed log messages like these, not directly correlatable to 
the failures (not at the same time as the failed recordings, and 
sometimes also working recordings after such a log message).

   kernel: cx23885 0000:02:00.0: dma in progress detected 0x00000001 
0x00000001, clearing

Nevertheless, the patch introducing the log message seems also to cause 
the failure:

   [PATCH 3/5] cx23885: Ryzen DMA related RiSC engine stall fixes
   https://www.spinics.net/lists/linux-media/msg133899.html

I never suffered the problem the patch is trying to solve (card used to 
work flawlessly for months). To see if that patch is not only the 
messenger, but also the culprit, I built a custom kernel based on the 
kernel-4.18.9-200.fc28.x86_64 source RPM from Fedora 28, only applying 
the patch above in reverse -- and did not have a single failure for > 48 
hours now.

Since the author tried to solve a problem, and maybe even did for his 
system, I guess reversing the patch alone is not a proper solution for 
everyone. And since the author did submit this patch, I guess he also 
did not suffer from the problem I have right now... so a 
fits-for-all-solution might be harder to find, also because the failure 
is not immediate.

Unfortunately I don't know enough about the code in question (or kernel 
development as whole), so I have no clue how to analyze (or even fix) 
this any further. What I can offer is to test modified versions of the 
patch above on my computer, as it does not seem to affect everyone.

Some information on my system:

- HP Microserver G7 N54L with AMD Turion II Neo CPU
- DVBSky T982 PCI-E card with dual DVB-T/C tuners, identifying as
   02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 
PCI Video and Audio Decoder (rev 04)
	Subsystem: DVBSky T982
	Flags: bus master, fast devsel, latency 0, IRQ 16, NUMA node 0
	Memory at fe600000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: <access denied>
	Kernel driver in use: cx23885
	Kernel modules: cx23885
- Fedora 28, currently with a custom kernel, usually with the most 
recent "stock" fedora kernel.
- kernel-4.18.9-200.fixdvb.fc28.x86_64 ("fixdvb" being my local 
extraversion, only difference to the original kernel: the reversed patch 
above)
- tvheadend-4.2.6-1.fc28.x86_64

Regards,
Markus
