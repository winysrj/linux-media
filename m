Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.jhcomp.cz ([88.146.207.5]:58959 "EHLO jhcinternet.jhcomp.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbZDSMLo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 08:11:44 -0400
Date: Sun, 19 Apr 2009 14:03:13 +0200
From: Marcel Sebek <sebek64@post.cz>
To: linux-media@vger.kernel.org, manu@linuxtv.org
Subject: saa716x driver
Message-ID: <20090419120313.GA4672@fourproc.fourproc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

I have a card named "AverMedia TV Hybrid Speedy PCI-E" and I'm tryiing
to make it working under linux. I've found the drivers at

http://jusst.de/hg/saa716x/

The drivers hangs on loading, this is the output:

saa716x_pci_init (0): found a Avermedia H788 PCIe card
SAA716x Hybrid 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
SAA716x Hybrid 0000:03:00.0: setting latency timer to 64
    SAA7160 Rev 3 [1461:1455], irq: 17,
    mmio: 0xffffc20005700000
    SAA7160 64Bit, MSI Disabled, MSI-X=32 msgs
saa716x_i2c_hwinit (0): Adapter (c000) SAA716x I2C Core 0 RESET
saa716x_i2c_hwinit (0): Adapter (b000) SAA716x I2C Core 1 RESET
saa716x_i2c_send (0): TXFIFO not empty after Timeout, tried 10 loops,
100 mS!
saa716x_i2c_hwinit (0): Adapter (c000) SAA716x I2C Core 0 RESET

this repeats many times, modprobe hangs for a few minutes

saa716x_i2c_hwinit (0): Adapter (c000) SAA716x I2C Core 0 RESET
saa716x_eeprom_header (0): ERROR: Header size mismatch! Read size=8 bytes, Expected=65535
saa716x_eeprom_data (0): ERROR: Header Read failed <-1>
saa716x_hybrid_pci_probe (0): SAA716x EEPROM dump failed
DVB: registering new adapter (SAA716x dvb adapter)

I've also tried various int_type values but with no success. After some
experiments, I've found that reverting patches "Fix BUS ordering" and
"Fix swapped I2C buses" fixed the hang during module loading, now it
the output is:

saa716x_pci_init (0): found a Avermedia H788 PCIe card
SAA716x Hybrid 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
SAA716x Hybrid 0000:03:00.0: setting latency timer to 6
    SAA7160 Rev 3 [1461:1455], irq: 17,
    mmio: 0xffffc20005b00000
    SAA7160 64Bit, MSI Disabled, MSI-X=32 msgs
saa716x_i2c_hwinit (0): Adapter (49152) SAA716x I2C Core
saa716x_i2c_hwinit (0): Adapter (45056) SAA716x I2C Core
saa716x_get_offset (0): Offset @ 192
saa716x_read_rombytes (0): Last Message length=16
    SAA7160 ROM: ===== Device 0 =====
    SAA7160 ROM: ===== Device 1 =====
    SAA7160 ROM: ===== Device 2 =====
    SAA7160 ROM: ===== Device 3 =====
    SAA7160 ROM: ===== Device 4 =====
DVB: registering new adapter (SAA716x dvb adapter)

After that, there are created some device nodes in /dev/dvb/adapter0
(demux0, dvr0, net0) but no frontend device node. It looks like the
drivers are not yet fully working. Is there a chance that the card will
be usable under linux?

-- 
Marcel Šebek

