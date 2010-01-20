Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:53938 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab0ATSaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 13:30:00 -0500
Received: by ewy1 with SMTP id 1so3297456ewy.28
        for <linux-media@vger.kernel.org>; Wed, 20 Jan 2010 10:29:58 -0800 (PST)
Subject: Conexant Systems, Inc. Hauppauge Inc. HDPVR-1250 model 1196 (rev
 04) [How to make it work?]
From: Ukko Happonen <uhappo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 20:29:51 +0200
Message-ID: <1264012191.4038.60.camel@urkkimylly>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I bought a desktop from Pixmania, it's this
http://h10010.www1.hp.com/wwpc/uk/en/ho/WF06b/12454-12454-3329740-64546-64546-4011395-4038054.html

How do I make the TV tuner work?

lspci -d 14f1:8880 -v says
[05:00.0 Multimedia video controller: Conexant Systems, Inc. Hauppauge
Inc. HDPVR-1250 model 1196 (rev 04)
        Subsystem: Avermedia Technologies Inc Device e139
        Flags: bus master, fast devsel, latency 0, IRQ 19
        Memory at fbe00000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: <access denied>
        Kernel driver in use: cx23885
        Kernel modules: cx23885

and sudo lshw says
*-multimedia
                description: Multimedia video controller
                product: Hauppauge Inc. HDPVR-1250 model 1196
                vendor: Conexant Systems, Inc.
                physical id: 0
                bus info: pci@0000:05:00.0
                version: 04
                width: 64 bits
                clock: 33MHz
                capabilities: pciexpress pm vpd msi bus_master cap_list
                configuration: driver=cx23885 latency=0
                resources: irq:19 memory:fbe00000-fbffffff

Any idea what is this and how to make it work?

Thanks!

-- 
Ukko Happonen
Tikaskatu 2 A 10
70820 Kuopio
044-5770227
www.ukkohapponen.fi
uhappo@gmail.com
www.rakkaudenammattilaiset.net
--- Öhömpis ---

