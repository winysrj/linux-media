Return-path: <mchehab@gaivota>
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:46867
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768Ab1AADC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 22:02:58 -0500
Message-ID: <4D1E9717.3000003@iinet.net.au>
Date: Sat, 01 Jan 2011 13:53:11 +1100
From: Alex Biddulph <bidski@iinet.net.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: SAA7136E and AverMedia A188
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

HI all,

Does anyone know if the SAA7136E chipset and/or the AverMEdia A188 PCI-e
device are supported yet?

$ lspci -v
03:00.0 Multimedia controller: Philips Semiconductors Device 7160
(rev 01)
Subsystem: Avermedia Technologies Inc DEvice 1855
Flags: bus master, fast devsel, latency 0, IRQ 7
Memory at fd800000 (64-bit, non-prefetachable) [size=1M]
Capabilities: <access denied>

Regards
Bidski
