Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:48526 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbZBWOfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 09:35:03 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1503055fkf.5
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2009 06:35:01 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 23 Feb 2009 15:35:01 +0100
Message-ID: <af2e95fa0902230635o6c5246v494201653c1b6c9f@mail.gmail.com>
Subject: Twinhan 2033, Mantis
From: Henrik Beckman <henrik.list@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any CAM support on this board today or planned ?
Are willing to try bleeding edge code and provide feedback.


Card info,
 25.180805] Mantis 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   25.180843] Mantis 0000:00:07.0: setting latency timer to 64
[   25.180856] irq: 18, latency: 64
[   25.180858]  memory: 0xfdffd000, mmio: 0xf8840000
[   25.180865] found a VP-2033 PCI DVB-C device on (00:07.0),
[   25.180870]     Mantis Rev 1 [1822:0008], irq: 18, latency: 64
[   25.180876]     memory: 0xfdffd000, mmio: 0xf8840000
[   25.184211]     MAC Address=[00:08:ca:1a:f0:60]
<snip>
[   25.704672] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[   25.706090] TDA10021: i2c-addr = 0x0c, id = 0x7c
[   25.706107] mantis_frontend_init (0): found Philips CU1216 DVB-C
frontend (TDA10021) @ 0x0c
[   25.706117] mantis_frontend_init (0): Mantis DVB-C Philips CU1216
frontend attach success
[   25.710822] DVB: registering adapter 0 frontend 0 (Philips TDA10021 DVB-C)...
[   25.712780] mantis_ca_init (0): Registering EN50221 device
[   25.714818] mantis_ca_init (0): Registered EN50221 device
[   25.714844] mantis_hif_init (0): Adapter(0) Initializing Mantis
Host Interface

/Henrik
