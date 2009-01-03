Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smaug.weblizards.de ([88.198.25.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tkeil@datacrystal.de>) id 1LJB5I-0000ic-Id
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 19:18:54 +0100
Received: from [192.168.1.109] (91-65-174-234-dynip.superkabel.de
	[91.65.174.234])
	by smaug.weblizards.de (Postfix) with ESMTPA id 09273DB9EB5
	for <linux-dvb@linuxtv.org>; Sat,  3 Jan 2009 19:18:46 +0100 (CET)
Message-ID: <495FAC07.1010705@datacrystal.de>
Date: Sat, 03 Jan 2009 19:18:47 +0100
From: Thomas Keil <tkeil@datacrystal.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <495FA03F.7040208@datacrystal.de>
In-Reply-To: <495FA03F.7040208@datacrystal.de>
Subject: Re: [linux-dvb] Kernel oops loading cx88 drivers when two
 WinTV-HVR4000 cards present
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

A little correction, the first oops is purely lirc-related.

Relevant is just the latter part:
> cx88_audio 0000:04:06.1: PCI INT A -> GSI 19 (level, low) -> IRQ 
> 19                                                                                                                                     
> cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) 
> DVB-S/S2 [card=69,autodetected], frontend(s): 
> 1                                                                                     
> cx88[0]: TV tuner type -1, Radio tuner type 
> -1                                                                                                                                                          
> tveeprom 1-0050: Hauppauge model 69100, rev B2C3, serial# 
> 3247308                                                                                                                                       
> tveeprom 1-0050: MAC address is 
> 00-0D-FE-31-8C-CC                                                                                                                                                       
> tveeprom 1-0050: tuner model is Conexant CX24118A (idx 123, type 
> 4)                                                                                                                                     
> tveeprom 1-0050: TV standards ATSC/DVB Digital (eeprom 
> 0x80)                                                                                                                                            
> tveeprom 1-0050: audio processor is None (idx 
> 0)                                                                                                                                                        
> tveeprom 1-0050: decoder processor is CX882 (idx 
> 25)                                                                                                                                                    
> tveeprom 1-0050: has no radio, has IR receiver, has no IR 
> transmitter                                                                                                                                   
> cx88[0]: hauppauge eeprom: 
> model=69100                                                                                                                                                                  
> input: cx88 IR (Hauppauge WinTV-HVR400 as 
> /class/input/input3                                                                                                                                           
> cx88[0]/1: CX88x/0: ALSA support for cx2388x 
> boards                                                                                                                                                     
> cx88_audio 0000:04:07.1: PCI INT A -> GSI 20 (level, low) -> IRQ 
> 20                                                                                                                                     
> allocation failed: out of vmalloc space - use vmalloc=<size> to increase 
> size.                                                                                                                          
> cx88[1]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) 
> DVB-S/S2 [card=69,autodetected], frontend(s): 
> 1                                                                                     
> cx88[1]: TV tuner type -1, Radio tuner type 
> -1                                                                                                                                                          
> BUG: unable to handle kernel paging request at 
> 00200034                                                                                                                                                 
>
> IP: [<fd917277>] 
> :cx88xx:cx88_shutdown+0xb/0x94                                                                                                                                                         
>
> *pde = 
> 00000000                                                                                                                                                                                         
>
> Oops: 0002 [#2] 
> SMP                                                                                                                                                                                     
>
> Modules linked in: tuner v4l2_common lirc_imon(+) lirc_dev cx88_alsa(+) 
> cx88xx videodev v4l1_compat snd_hda_intel ir_common i2c_algo_bit 
> videobuf_dvb dvb_core snd_pcm tveeprom videobuf_dma_sg videobuf_core 
> snd_timer ehci_hcd snd btcx_risc soundcore snd_page_alloc i2c_viapro 
> i2c_core uhci_hcd usbcore 8250_pnp 8250 
> serial_core                                                                                                                                                    
>
>
> Pid: 959, comm: modprobe Tainted: G      D   (2.6.27-gentoo-r7 #1)
> EIP: 0060:[<fd917277>] EFLAGS: 00010202 CPU: 0                   
> EIP is at cx88_shutdown+0xb/0x94 [cx88xx]                        
> EAX: f7ba6800 EBX: ffffffff ECX: 00200034 EDX: 00000000          
> ESI: f7ba6800 EDI: f7ba6cb0 EBP: f7ba6800 ESP: f7b6bdf8          
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068                    
> Process modprobe (pid: 959, ti=f7b6a000 task=f7b81ef0 task.ti=f7b6a000)
> Stack: fd917fb6 00000070 f7ba6810 fd916a4c fd920a1f f7ba6810 ffffffff 
> ffffffff
>        00000004 f7b6be64 c02bc88d 0000000d f78fec00 00b6be64 00000039 
> f7ba6bb8
>        0000000d 00000286 c02bc96b 0000000d 00000001 f7b6be64 00000286 
> c01fb6bf
> Call 
> Trace:                                                                   
>  [<fd917fb6>] cx88_reset+0x2d/0x186 
> [cx88xx]                                  
>  [<fd916a4c>] cx88_core_create+0x393/0xac3 
> [cx88xx]                           
>  [<c02bc88d>] 
> raw_pci_read+0x4d/0x55                                          
>  [<c02bc96b>] 
> pci_read+0x1c/0x21                                              
>  [<c01fb6bf>] 
> pci_bus_read_config_byte+0x4e/0x58                              
>  [<c02bb057>] 
> pcibios_set_master+0x1c/0x8d                                    
>  [<fd917406>] cx88_core_get+0x6e/0x9f 
> [cx88xx]                                
>  [<f98ae864>] cx88_audio_initdev+0x94/0x30f 
> [cx88_alsa]                       
>  [<c01f416f>] 
> kobject_get+0xf/0x13                                            
>  [<c0255009>] __driver_attach+0x0/0x55
>  [<c01ff34e>] pci_device_probe+0x36/0x57
>  [<c0254f92>] driver_probe_device+0xb5/0x12c
>  [<c0255040>] __driver_attach+0x37/0x55
>  [<c02548d9>] bus_for_each_dev+0x34/0x56
>  [<c0254e2d>] driver_attach+0x11/0x13
>  [<c0255009>] __driver_attach+0x0/0x55
>  [<c0254c2f>] bus_add_driver+0x8a/0x1a7
>  [<c01f4193>] kset_find_obj+0x20/0x4a
>  [<f98ae1e7>] cx88_audio_init+0x0/0x27 [cx88_alsa]
>  [<c025521d>] driver_register+0x6d/0xc1
>  [<c011e942>] printk+0x14/0x18
>  [<f98ae1e7>] cx88_audio_init+0x0/0x27 [cx88_alsa]
>  [<c01ff50d>] __pci_register_driver+0x3c/0x67
>  [<c010111f>] _stext+0x37/0xfb
>  [<c0116088>] enqueue_task+0xa/0x14
>  [<c0118e6f>] try_to_wake_up+0x11c/0x125
>  [<c013a8b4>] sys_init_module+0x87/0x176
>  [<c0102d91>] sysenter_do_call+0x12/0x25
>  [<c0350000>] rt_mutex_slowlock+0x213/0x3e1
>  =======================
> Code: 41 0c 89 42 04 89 f0 8b 4c 24 1c 45 8d 34 08 3b 6c 24 20 0f 85 40 
> ff ff ff 5b 89 f8 5e 5f 5d c3 8b 48 38 31 d2 81 c1 34 00 20 00 <89> 11 
> 8b 48 38 81 c1 40 c0 31 00 89 11 8b 48 38 81 c1 40 c0 32
> EIP: [<fd917277>] cx88_shutdown+0xb/0x94 [cx88xx] SS:ESP 0068:f7b6bdf8
> ---[ end trace d1865b13e5b6eb16 ]---
>
>   


Thomas




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
