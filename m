Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64885 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0GXA3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 20:29:05 -0400
Received: by gxk23 with SMTP id 23so366762gxk.19
        for <linux-media@vger.kernel.org>; Fri, 23 Jul 2010 17:29:03 -0700 (PDT)
Message-ID: <4C4A348F.9020402@gmail.com>
Date: Fri, 23 Jul 2010 20:32:15 -0400
From: Emmanuel <eallaud@gmail.com>
MIME-Version: 1.0
To: OJ <olejl77@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Mystique SaTiX-S2 Dual
References: <AANLkTilWS3hIJ1cX6kXrONDFFprMybtELXSnHs7Tx8lm@mail.gmail.com> <AANLkTilELEYFm3a4_TjdF6GiVKRVhjIpQprvxawgcuLj@mail.gmail.com>
In-Reply-To: <AANLkTilELEYFm3a4_TjdF6GiVKRVhjIpQprvxawgcuLj@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OJ a écrit :
> I am using this card:
> http://www.linuxtv.org/wiki/index.php/Mystique_SaTiX-S2_Dual (v2)
>
> According to the wiki I should use the ngene driver, but I am not able
> to compile it. Downloaded the latest version from Mercury yesterday.
> Error message when compiling:
>
> $ make ngene
> make -C /home/olejl/src/v4l-dvb/v4l ngene
> make[1]: Entering directory `/home/olejl/src/v4l-dvb/v4l'
> cc -I.   ngene.o   -o ngene
> /usr/lib/gcc/x86_64-linux-gnu/4.4.3/../../../../lib/crt1.o: In
> function `_start':
> (.text+0x20): undefined reference to `main'
> ngene.o: In function `irq_handler':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:202: undefined reference to `__wake_up'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:211: undefined reference to
> `_spin_lock'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `irq_handler':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:250: undefined reference to
> `_spin_lock'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `tasklet_schedule':
> /usr/src/linux-headers-2.6.32-23-generic/include/linux/interrupt.h:469:
> undefined reference to `__tasklet_schedule'
> ngene.o: In function `irq_handler':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:218: undefined reference to `__wake_up'
> ngene.o: In function `tasklet_schedule':
> /usr/src/linux-headers-2.6.32-23-generic/include/linux/interrupt.h:469:
> undefined reference to `__tasklet_schedule'
> ngene.o: In function `irq_handler':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:239: undefined reference to `printk'
> ngene.o: In function `demux_tasklet':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:103: undefined reference to
> `_spin_lock_irq'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `raw_local_irq_enable':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:864:
> undefined reference to `pv_irq_ops'
> ngene.o: In function `demux_tasklet':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:173: undefined reference to
> `_spin_lock_irq'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:139: undefined reference to `printk'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `raw_local_irq_enable':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:864:
> undefined reference to `pv_irq_ops'
> ngene.o: In function `demux_tasklet':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:146: undefined reference to `printk'
> ngene.o: In function `ngene_stop':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1602: undefined reference to `down'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1603: undefined reference to
> `i2c_del_adapter'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1604: undefined reference to
> `i2c_del_adapter'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1612: undefined reference to `free_irq'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1615: undefined reference to
> `pci_disable_msi'
> ngene.o: In function `ngene_command':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:380: undefined reference to `down'
> ngene.o: In function `ngene_command_mutex':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:328: undefined reference to
> `_spin_lock_irq'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `raw_local_irq_enable':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:864:
> undefined reference to `pv_irq_ops'
> ngene.o: In function `ngene_command_mutex':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:341: undefined reference to
> `autoremove_wake_function'
> ngene.o: In function `get_current':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/current.h:14:
> undefined reference to `per_cpu__current_task'
> ngene.o: In function `ngene_command_mutex':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:341: undefined reference to
> `prepare_to_wait'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:341: undefined reference to
> `schedule_timeout'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:341: undefined reference to
> `finish_wait'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:351: undefined reference to `printk'
> ngene.o: In function `memcpy_fromio':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/io_64.h:151:
> undefined reference to `__memcpy_fromio'
> ngene.o: In function `dump_command_io':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:278: undefined reference to `printk'
> ngene.o: In function `memcpy_fromio':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/io_64.h:151:
> undefined reference to `__memcpy_fromio'
> ngene.o: In function `dump_command_io':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:283: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:288: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:292: undefined reference to `printk'
> ngene.o: In function `ngene_command':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:382: undefined reference to `up'
> ngene.o: In function `ngene_command_mutex':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:341: undefined reference to
> `finish_wait'
> ngene.o: In function `memcpy_toio':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/io_64.h:157:
> undefined reference to `__memcpy_toio'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/io_64.h:157:
> undefined reference to `__memcpy_toio'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/io_64.h:157:
> undefined reference to `__memcpy_toio'
> ngene.o: In function `ngene_command_stream_control':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:717: undefined reference to `down'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:738: undefined reference to
> `_spin_lock_irq'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `raw_local_irq_enable':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:864:
> undefined reference to `pv_irq_ops'
> ngene.o: In function `ngene_command_stream_control':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:753: undefined reference to `up'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:790: undefined reference to
> `_spin_lock_irq'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:790: undefined reference to
> `_spin_lock_irq'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `raw_local_irq_enable':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:864:
> undefined reference to `pv_irq_ops'
> ngene.o: In function `ngene_command_stream_control':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:853: undefined reference to `up'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `raw_local_irq_enable':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:864:
> undefined reference to `pv_irq_ops'
> ngene.o: In function `flush_buffers':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:669: undefined reference to `msleep'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:670: undefined reference to
> `_spin_lock_irq'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `raw_local_irq_enable':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:864:
> undefined reference to `pv_irq_ops'
> ngene.o: In function `ngene_command_stream_control':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:790: undefined reference to
> `_spin_lock_irq'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:850: undefined reference to `up'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:730: undefined reference to `printk'
> ngene.o: In function `set_transfer':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:925: undefined reference to
> `_spin_lock_irq'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:927: undefined reference to
> `dvb_ringbuffer_flush'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `raw_local_irq_enable':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:864:
> undefined reference to `pv_irq_ops'
> ngene.o: In function `set_transfer':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:875: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:892: undefined reference to
> `_spin_lock_irq'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:896: undefined reference to
> `dvb_ringbuffer_flush'
> ngene.o: In function `__raw_spin_unlock':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:769:
> undefined reference to `pv_lock_ops'
> ngene.o: In function `raw_local_irq_enable':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/paravirt.h:864:
> undefined reference to `pv_irq_ops'
> ngene.o: In function `set_transfer':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:870: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:922: undefined reference to `printk'
> ngene.o: In function `release_channel':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1760: undefined reference to
> `tasklet_kill'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1772: undefined reference to
> `dvb_unregister_frontend'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1773: undefined reference to
> `dvb_frontend_detach'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1781: undefined reference to
> `dvb_dmxdev_release'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1782: undefined reference to
> `dvb_dmx_release'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1785: undefined reference to
> `dvb_unregister_adapter'
> ngene.o: In function `get_dma_ops':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> ngene.o: In function `ngene_release_buffers':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1483: undefined reference to `iounmap'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1485: undefined reference to `vfree'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1486: undefined reference to `vfree'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1487: undefined reference to `vfree'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1488: undefined reference to `vfree'
> ngene.o: In function `pci_free_consistent':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> ngene.o: In function `get_dma_ops':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `x86_dma_fallback_dev'
> ngene.o: In function `dma_alloc_coherent':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:133:
> undefined reference to `x86_dma_fallback_dev'
> ngene.o: In function `get_dma_ops':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `x86_dma_fallback_dev'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `x86_dma_fallback_dev'
> ngene.o: In function `dma_alloc_coherent':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:133:
> undefined reference to `x86_dma_fallback_dev'
> ngene.o: In function `get_dma_ops':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> ngene.o: In function `pci_alloc_consistent':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `x86_dma_fallback_dev'
> ngene.o: In function `i2c_set_adapdata':
> /usr/src/linux-headers-2.6.32-23-generic/include/linux/i2c.h:361:
> undefined reference to `dev_set_drvdata'
> ngene.o: In function `ngene_i2c_init':
> /home/olejl/src/v4l-dvb/v4l/ngene-i2c.c:227: undefined reference to
> `i2c_add_adapter'
> ngene.o: In function `i2c_get_adapdata':
> /usr/src/linux-headers-2.6.32-23-generic/include/linux/i2c.h:356:
> undefined reference to `dev_get_drvdata'
> ngene.o: In function `ngene_i2c_master_xfer':
> /home/olejl/src/v4l-dvb/v4l/ngene-i2c.c:132: undefined reference to `down'
> /home/olejl/src/v4l-dvb/v4l/ngene-i2c.c:150: undefined reference to `up'
> /home/olejl/src/v4l-dvb/v4l/ngene-i2c.c:154: undefined reference to `up'
> ngene.o: In function `demod_attach_lg330x':
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:211: undefined reference to
> `__symbol_get'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:217: undefined reference to
> `__symbol_get'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:211: undefined reference to
> `__request_module'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:211: undefined reference to
> `__symbol_get'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:211: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:211: undefined reference to
> `__symbol_put'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:213: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:217: undefined reference to
> `__request_module'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:217: undefined reference to
> `__symbol_get'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:217: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:217: undefined reference to
> `__symbol_put'
> ngene.o: In function `tuner_attach_stv6110':
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:58: undefined reference to
> `__symbol_get'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:58: undefined reference to
> `__request_module'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:58: undefined reference to
> `__symbol_get'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:58: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:58: undefined reference to
> `__symbol_put'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:61: undefined reference to `printk'
> ngene.o: In function `ngene_resume':
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:872: undefined reference to `printk'
> ngene.o: In function `ngene_slot_reset':
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:866: undefined reference to `printk'
> ngene.o: In function `ngene_link_reset':
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:860: undefined reference to `printk'
> ngene.o: In function `ngene_error_detected':
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:850: undefined reference to `printk'
> ngene.o: In function `demod_attach_stv0900':
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:175: undefined reference to
> `__symbol_get'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:185: undefined reference to
> `__symbol_get'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:175: undefined reference to
> `__request_module'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:175: undefined reference to
> `__symbol_get'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:175: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:175: undefined reference to
> `__symbol_put'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:181: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:185: undefined reference to
> `__request_module'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:185: undefined reference to
> `__symbol_get'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:185: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:185: undefined reference to
> `__symbol_put'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:187: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:188: undefined reference to
> `dvb_frontend_detach'
> ngene.o: In function `my_dvb_dmxdev_ts_card_init':
> /home/olejl/src/v4l-dvb/v4l/ngene-dvb.c:563: undefined reference to
> `dvb_dmxdev_init'
> ngene.o: In function `my_dvb_dmx_ts_card_init':
> /home/olejl/src/v4l-dvb/v4l/ngene-dvb.c:549: undefined reference to
> `dvb_dmx_init'
> ngene.o: In function `tsout_exchange':
> /home/olejl/src/v4l-dvb/v4l/ngene-dvb.c:433: undefined reference to
> `dvb_ringbuffer_avail'
> /home/olejl/src/v4l-dvb/v4l/ngene-dvb.c:440: undefined reference to
> `dvb_ringbuffer_read'
> /home/olejl/src/v4l-dvb/v4l/ngene-dvb.c:443: undefined reference to `__wake_up'
> ngene.o: In function `tsin_exchange':
> /home/olejl/src/v4l-dvb/v4l/ngene-dvb.c:421: undefined reference to
> `dvb_dmx_swfilter'
> ngene.o: In function `pci_get_drvdata':
> /usr/src/linux-headers-2.6.32-23-generic/include/linux/pci.h:1156:
> undefined reference to `dev_get_drvdata'
> ngene.o: In function `ngene_remove':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1918: undefined reference to
> `tasklet_kill'
> ngene.o: In function `pci_set_drvdata':
> /usr/src/linux-headers-2.6.32-23-generic/include/linux/pci.h:1161:
> undefined reference to `dev_set_drvdata'
> ngene.o: In function `ngene_remove':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1924: undefined reference to
> `pci_disable_device'
> ngene.o: In function `ngene_probe':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1933: undefined reference to
> `pci_enable_device'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1936: undefined reference to `vmalloc'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1945: undefined reference to `printk'
> ngene.o: In function `pci_set_drvdata':
> /usr/src/linux-headers-2.6.32-23-generic/include/linux/pci.h:1161:
> undefined reference to `dev_set_drvdata'
> ngene.o: In function `get_dma_ops':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> ngene.o: In function `dma_alloc_coherent':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:133:
> undefined reference to `x86_dma_fallback_dev'
> ngene.o: In function `get_dma_ops':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:36:
> undefined reference to `dma_ops'
> ngene.o: In function `dma_alloc_coherent':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/dma-mapping.h:133:
> undefined reference to `x86_dma_fallback_dev'
> ngene.o: In function `ngene_get_buffers':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1496: undefined reference to `vmalloc'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1499: undefined reference to
> `dvb_ringbuffer_init'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1503: undefined reference to `vmalloc'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1506: undefined reference to
> `dvb_ringbuffer_init'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1509: undefined reference to `vmalloc'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1512: undefined reference to
> `dvb_ringbuffer_init'
> ngene.o: In function `ioremap':
> /usr/src/linux-headers-2.6.32-23-generic/arch/x86/include/asm/io.h:170:
> undefined reference to `ioremap_nocache'
> ngene.o: In function `ngene_start':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1638: undefined reference to
> `__init_waitqueue_head'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1639: undefined reference to
> `__init_waitqueue_head'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1640: undefined reference to
> `__init_waitqueue_head'
> ngene.o: In function `ngene_load_firm':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1577: undefined reference to
> `request_firmware'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1578: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1580: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1585: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1589: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1595: undefined reference to
> `release_firmware'
> ngene.o: In function `ngene_start':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1658: undefined reference to
> `pci_msi_enabled'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1660: undefined reference to `free_irq'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1661: undefined reference to
> `pci_enable_msi_block'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1663: undefined reference to `printk'
> ngene.o: In function `request_irq':
> /usr/src/linux-headers-2.6.32-23-generic/include/linux/interrupt.h:120:
> undefined reference to `request_threaded_irq'
> ngene.o: In function `ngene_start':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1710: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1737: undefined reference to `free_irq'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1741: undefined reference to
> `pci_disable_msi'
> ngene.o: In function `init_channel':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1807: undefined reference to
> `tasklet_init'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1821: undefined reference to
> `__this_module'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1821: undefined reference to
> `dvb_register_adapter'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1860: undefined reference to
> `dvb_register_frontend'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1868: undefined reference to `printk'
> ngene.o: In function `ngene_probe':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1997: undefined reference to
> `pci_disable_device'
> ngene.o: In function `pci_set_drvdata':
> /usr/src/linux-headers-2.6.32-23-generic/include/linux/pci.h:1161:
> undefined reference to `dev_set_drvdata'
> ngene.o: In function `ngene_start':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1625: undefined reference to
> `pci_set_master'
> ngene.o: In function `ngene_init':
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1526: undefined reference to
> `tasklet_init'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1528: undefined reference to
> `memset_io'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1529: undefined reference to
> `memset_io'
> /home/olejl/src/v4l-dvb/v4l/ngene-core.c:1543: undefined reference to `printk'
> ngene.o: In function `request_irq':
> /usr/src/linux-headers-2.6.32-23-generic/include/linux/interrupt.h:120:
> undefined reference to `request_threaded_irq'
> ngene.o: In function `module_exit_ngene':
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:908: undefined reference to
> `pci_unregister_driver'
> ngene.o: In function `module_init_ngene':
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:897: undefined reference to `printk'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:900: undefined reference to
> `__this_module'
> /home/olejl/src/v4l-dvb/v4l/ngene-cards.c:900: undefined reference to
> `__pci_register_driver'
> ngene.o:(.rodata+0x70): undefined reference to `param_set_short'
> ngene.o:(.rodata+0x78): undefined reference to `param_get_short'
> ngene.o:(__param+0x10): undefined reference to `param_array_set'
> ngene.o:(__param+0x18): undefined reference to `param_array_get'
> ngene.o:(__param+0x38): undefined reference to `param_set_int'
> ngene.o:(__param+0x40): undefined reference to `param_get_int'
> ngene.o:(__param+0x60): undefined reference to `param_set_int'
> ngene.o:(__param+0x68): undefined reference to `param_get_int'
> collect2: ld returned 1 exit status
> make[1]: *** [ngene] Error 1
> make[1]: Leaving directory `/home/olejl/src/v4l-dvb/v4l'
> make: *** [ngene] Error 2
>
>
> Anyone know how I can fix it?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.htm
>   
Sorry for the thread hijacking ;-) but I would like to know if someone 
has managed to tune to a high rate (meaning 45MS/s) DVB-S2 transponder 
(I am interested in QPSK but something else is OK also).
TIA
Bye
Manu

