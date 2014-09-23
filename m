Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:51506 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbaIWImx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 04:42:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Sep 2014 10:42:29 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Digital Devices PCIe bridge update to 0.9.15a
In-Reply-To: <1406951335-24026-1-git-send-email-crope@iki.fi>
References: <1406951335-24026-1-git-send-email-crope@iki.fi>
Message-ID: <90566e3465ba22d729c5d4d023208d8a@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2014-08-02 05:48, Antti Palosaari wrote:

> 
> Tree for testing is here:
> http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=digitaldevices
> 


Hi Antti,

I tried your digitaldevices branch but it does not work for me.

Using w_scan, I'm not able to find any DVB-C transponder.
The very same command works fine with the official drivers.

There is no indication of what is wrong. Everything seems fine, I just 
don't get a lock.

See the relevant output below.

Regards,
   Guy

02:00.0 Multimedia controller: Digital Devices GmbH Device 0005
         Subsystem: Digital Devices GmbH Device 0004
         Flags: bus master, fast devsel, latency 0, IRQ 17
         Memory at d0500000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: [50] Power Management version 3
         Capabilities: [70] MSI: Enable- Count=1/2 Maskable- 64bit+
         Capabilities: [90] Express Endpoint, MSI 00
         Capabilities: [100] Vendor Specific Information: ID=0000 Rev=0 
Len=00c <?>
         Kernel driver in use: ddbridge
         Kernel modules: ddbridge


[40396.241811] Digital Devices PCIE bridge driver 0.9.15, Copyright (C) 
2010-14 Digital Devices GmbH
[40396.242318] DDBridge driver detected: Digital Devices Octopus V3 DVB 
adapter
[40396.242358] HW 00010000 REGMAP 00010004
[40396.352992] Port 0 (TAB 1): DUAL DVB-C/T/T2
[40396.354460] Port 1 (TAB 2): NO MODULE
[40396.355691] Port 2 (TAB 3): NO MODULE
[40396.464656] Port 3 (TAB 4): DUAL DVB-C/T/T2
[40396.467376] 0 netstream channels
[40396.467388] DVB: registering new adapter (DDBridge)
[40396.467392] DVB: registering new adapter (DDBridge)
[40396.467396] DVB: registering new adapter (DDBridge)
[40396.467399] DVB: registering new adapter (DDBridge)
[40396.505488] tda18212 0-0060: NXP TDA18212HN/M successfully identified
[40396.505546] ddbridge 0000:02:00.0: DVB: registering adapter 0 
frontend 0 (CXD2837 DVB-C DVB-T/T2)...
[40396.552506] tda18212 0-0063: NXP TDA18212HN/S successfully identified
[40396.552545] ddbridge 0000:02:00.0: DVB: registering adapter 1 
frontend 0 (CXD2837 DVB-C DVB-T/T2)...
[40396.599404] tda18212 3-0060: NXP TDA18212HN/M successfully identified
[40396.599440] ddbridge 0000:02:00.0: DVB: registering adapter 2 
frontend 0 (CXD2837 DVB-C DVB-T/T2)...
[40396.647594] tda18212 3-0063: NXP TDA18212HN/S successfully identified
[40396.647632] ddbridge 0000:02:00.0: DVB: registering adapter 3 
frontend 0 (CXD2837 DVB-C DVB-T/T2)...



