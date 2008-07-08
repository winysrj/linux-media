Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.siberianet.ru ([89.105.136.7])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <wmn@siberianet.ru>) id 1KG8lx-0000Ps-2C
	for linux-dvb@linuxtv.org; Tue, 08 Jul 2008 10:42:07 +0200
Received: from mail.siberianet.ru (mail.siberianet.ru [89.105.136.7])
	by mail.siberianet.ru (Postfix) with ESMTP id C8BDD1DE1E9
	for <linux-dvb@linuxtv.org>; Tue,  8 Jul 2008 16:41:29 +0800 (KRAST)
Received: from wmn.siberianet.ru (wmn.siberianet.ru [192.168.100.16])
	by mail.siberianet.ru (Postfix) with ESMTP id A97BF1DE1DC
	for <linux-dvb@linuxtv.org>; Tue,  8 Jul 2008 16:41:29 +0800 (KRAST)
From: Wmn <wmn@siberianet.ru>
To: linux-dvb@linuxtv.org
Date: Tue, 8 Jul 2008 16:41:09 +0800
References: <48732671.2070900@itsystems.ro>
In-Reply-To: <48732671.2070900@itsystems.ro>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807081641.10009.wmn@siberianet.ru>
Subject: Re: [linux-dvb] cx24113 - SkyStar2 Rev2.8
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

[Tuesday 08 July 2008 16:33:53] Robert Grozea:
> Hi All,
>
> I managed to make the binary driver work. The whole ideea is that the
> only distribution which fitted was Fedora.
> It seems that the driver has been written in Fedora and it includes some
> function calls which are only available in Fedora.
> Since I do not appreciate this kind of proprietary thinking I still wait
> for a new version of driver which will work on other distros.
>
> Best regards,
>
> Robert

What version of fedora/kernel did you use?

I have got that problem under 2.6.25.9-76.fc9.i686.

/var/log/messages:
kernel: cx24113: Unknown symbol kmem_cache_zalloc
kernel: cx24113: Unknown symbol malloc_sizes
kernel: b2c2_flexcop: Unknown symbol cx24113_agc_callback
kernel: b2c2_flexcop: Unknown symbol cx24113_agc_callback
kernel: b2c2_flexcop: Unknown symbol cx24113_agc_callback
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_device_exit
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_pass_dmx_packets
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_dma_control_timer_irq
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_sram_set_dest
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_dma_allocate
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_dma_xfer_control
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_dma_free
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_device_kmalloc
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_dma_config
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_device_kfree
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_device_initialize
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_pass_dmx_data
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_dma_config_timer
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_dump_reg
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_i2c_request
kernel: b2c2_flexcop_pci: Unknown symbol flexcop_eeprom_check_mac_addr

Thanks,
Wmn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
