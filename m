Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:44570 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZBVTkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 14:40:15 -0500
Received: by bwz5 with SMTP id 5so4155436bwz.13
        for <linux-media@vger.kernel.org>; Sun, 22 Feb 2009 11:40:12 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 22 Feb 2009 20:40:12 +0100
Message-ID: <af2e95fa0902221140ha93378j5b6d36e654e9ee8a@mail.gmail.com>
Subject: Twinhan mantis, any CAM support in progress
From: Henrik Beckman <henrik.list@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any work in progress for CAM support on the 2033?

Currently using, http://mercurial.intuxication.org/hg/s2-liplianin but
I´ll switch to whatever has or will have CAM.

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
