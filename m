Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:52146 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab0F1SLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 14:11:00 -0400
Message-ID: <4C28E5B0.1070302@kolumbus.fi>
Date: Mon, 28 Jun 2010 21:10:56 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Mantis DMA interrupt with FTRGT flag?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Manu.

Here is Mantis debug messages at verbose level 7:

Jun 28 20:01:53 koivu kernel: -- Stat=<3c00000a> Mask=<802>
--<DMA><FTRGT><RISCI><Unknown> Stat=<30000000> Mask=<802>
Jun 28 20:01:53 koivu kernel: mantis_dma_xfer (0): last block=[2]
finished block=[3]
Jun 28 20:01:53 koivu kernel: demux: skipped 148 bytes at 9497: 00 ..
Jun 28 20:01:53 koivu kernel: TS packet counter mismatch. PID=0x2b2
expected 0xa got 0xb

What FTRGT message means?

Those errors come seemingly randomly at blocks 0, 1, 2 and 3:
56 Stat=<20000000>
68
71 Stat=<10000000>
73 Stat=<30000000>

So above, Stat=<00000000> is hidden.

With bttv, FTRGT means something like FIFO overflow.
How can I make the error more rare?

Regards,
Marko Ristola

