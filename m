Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LJBWN-0002vi-Nn
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 19:46:54 +0100
From: Andy Walls <awalls@radix.net>
To: Thomas Keil <tkeil@datacrystal.de>
In-Reply-To: <495FA03F.7040208@datacrystal.de>
References: <495FA03F.7040208@datacrystal.de>
Date: Sat, 03 Jan 2009 13:48:00 -0500
Message-Id: <1231008480.4302.72.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Kernel oops loading cx88 drivers when
	two	WinTV-HVR4000 cards present
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

On Sat, 2009-01-03 at 18:28 +0100, Thomas Keil wrote:
> Hello everyone,
> 
> I'm having trouble with my Nova-HD-S2 WinTV /  WinTV-HVR4000(Lite) cards.
> 
> As long as just one card is present in the system everything is fine, 
> with two cards the driver oopses:
> 
> 
> 
> ------------------------------------------------------------------------
> BUG: unable to handle kernel NULL pointer dereference at 
> 00000000                                                                                                                                                                     
> 
> IP: [<c01f798e>] 
> vsnprintf+0x41e/0x452                                                                                                                                                                                                
> 
> *pde = 
> 00000000                                                                                                                                                                                                                       
> 
> Oops: 0000 [#1] 
> SMP                                                                                                                                                                                                                   
> 
> Modules linked in: lirc_imon(+) lirc_dev cx88_alsa(+) cx88xx videodev 
> v4l1_compat snd_hda_intel(+) ir_common i2c_algo_bit videobuf_dvb 
> dvb_core snd_pcm tveeprom videobuf_dma_sg videobuf_core snd_timer 
> ehci_hcd(+) snd btcx_risc soundcore snd_page_alloc i2c_viapro(+) 
> i2c_core uhci_hcd usbcore 8250_pnp 8250 
> serial_core                                                                                                                                                             
> 
> 
> Pid: 1108, comm: modprobe Not tainted (2.6.27-gentoo-r7 #1)
> EIP: 0060:[<c01f798e>] EFLAGS: 00010216 CPU: 0            
> EIP is at vsnprintf+0x41e/0x452                           
> EAX: 00000000 EBX: f7b5e400 ECX: 00000000 EDX: 00000014   
> ESI: f7b5e49c EDI: f7121e30 EBP: 03d00000 ESP: f7121cd8   
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068             
> Process modprobe (pid: 1108, ti=f7120000 task=f7bac6e0 task.ti=f7120000)
> Stack: 00000014 f7b5e49c c01f7528 c01f7528 f7b5e4b0 f7124628 f7121e74 
> 00000000
>        c01f77fd ffffffff ffffffff 00000000 00000006 f7124628 00ffffff 
> ffffffff
>        f712462e 00000000 ffffffff c042ab22 f7189a40 f7bac6e0 f7121df4 
> c04d2500
> Call 
> Trace:                                                                   
>  [<c01f7528>] 
> string+0x27/0x6f                                                
>  [<c01f7528>] 
> string+0x27/0x6f                                                
>  [<c01f77fd>] 
> vsnprintf+0x28d/0x452                                           
>  [<c01f37d0>] 
> idr_get_empty_slot+0x146/0x239                                  
>  [<c01f7528>] 
> string+0x27/0x6f                                                
>  [<c012fd78>] 
> up+0x9/0x2a                                                     
>  [<c011e506>] 
> release_console_sem+0x16d/0x186                                 
>  [<c012fd78>] 
> up+0x9/0x2a                                                     
>  [<c0253b3a>] 
> device_create_vargs+0x71/0x99                                   
>  [<c0253b86>] 
> device_create+0x24/0x28                                         
>  [<f98c9eb7>] lirc_register_plugin+0x2e3/0x3bc 
> [lirc_dev]                     
>  [<f98c5744>] init_module+0x109c744/0x109c8d8 
> [lirc_imon]                     
>  [<f885e577>] usb_probe_interface+0xbd/0xe2 
> [usbcore]                         
>  [<c0255009>] 
> __driver_attach+0x0/0x55                                        
>  [<c0254f92>] 
> driver_probe_device+0xb5/0x12c                                  
>  [<c0255040>] 
> __driver_attach+0x37/0x55                                       
>  [<c02548d9>] 
> bus_for_each_dev+0x34/0x56                                      
>  [<c0254e2d>] 
> driver_attach+0x11/0x13                                         
>  [<c0255009>] 
> __driver_attach+0x0/0x55                                        
>  [<c0254c2f>] 
> bus_add_driver+0x8a/0x1a7                                       
>  [<c01f4193>] 
> kset_find_obj+0x20/0x4a                                         
>  [<c025521d>] 
> driver_register+0x6d/0xc1                                       
>  [<f885dda7>] usb_register_driver+0x5d/0xb4 
> [usbcore]                         
>  [<f8829000>] init_module+0x0/0x4b 
> [lirc_imon]                                
>  [<f8829028>] init_module+0x28/0x4b 
> [lirc_imon]                               
>  [<c010111f>] 
> _stext+0x37/0xfb                                                
>  [<c013a8b4>] 
> sys_init_module+0x87/0x176                                      
>  [<c0102d91>] 
> sysenter_do_call+0x12/0x25                                      
>  [<c0350000>] 
> rt_mutex_slowlock+0x213/0x3e1                                   
>  =======================                                                       
> 
> Code: f9 1f ff 74 24 14 89 f0 89 df ff 74 24 1c 55 ff 74 24 18 51 52 8b 
> 54 24 28 e8 62 f5 ff ff 89 c6 83 c4 18 ff 44 24 1c 8b 44 24 1c <8a> 00 
> 84 c0 0f 85 4f fc ff ff 83 3c 24 00 74 13 3b 74 24 10 73
> EIP: [<c01f798e>] vsnprintf+0x41e/0x452 SS:ESP 
> 0068:f7121cd8                                                                                                                                            
> 
> ---[ end trace d1865b13e5b6eb16 
> ]---                                                                                                                                                                    

This first ooops looks lirc related.  Perhaps you should black list the
lirc modules and/or not start lirc, just to reduce the number of
unknowns for the time being.  Once you get all the cards up and running,
then reintroduce lirc.


> HDA Intel 0000:80:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
> 17                                                                                                                                      
> 
> HDA Intel 0000:80:01.0: setting latency timer to 
> 64                                                                                                                                                     
> 
> HDA Intel 0000:80:01.0: PCI: Disallowing DAC for 
> device                                                                                                                                                 
> 
> cx88_audio 0000:04:06.1: PCI INT A -> GSI 19 (level, low) -> IRQ 
> 19                                                                                                                                     
> 
> cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) 
> DVB-S/S2 [card=69,autodetected], frontend(s): 
> 1                                                                                     
> 
> cx88[0]: TV tuner type -1, Radio tuner type 
> -1                                                                                                                                                          
> 
> tveeprom 1-0050: Hauppauge model 69100, rev B2C3, serial# 
> 3247308                                                                                                                                       
> 
> tveeprom 1-0050: MAC address is 
> 00-0D-FE-31-8C-CC                                                                                                                                                       
> 
> tveeprom 1-0050: tuner model is Conexant CX24118A (idx 123, type 
> 4)                                                                                                                                     
> 
> tveeprom 1-0050: TV standards ATSC/DVB Digital (eeprom 
> 0x80)                                                                                                                                            
> 
> tveeprom 1-0050: audio processor is None (idx 
> 0)                                                                                                                                                        
> 
> tveeprom 1-0050: decoder processor is CX882 (idx 
> 25)                                                                                                                                                    
> 
> tveeprom 1-0050: has no radio, has IR receiver, has no IR 
> transmitter                                                                                                                                   
> 
> cx88[0]: hauppauge eeprom: 
> model=69100                                                                                                                                                                  
> 
> input: cx88 IR (Hauppauge WinTV-HVR400 as 
> /class/input/input3                                                                                                                                           
> 
> cx88[0]/1: CX88x/0: ALSA support for cx2388x 
> boards                                                                                                                                                     
> 
> cx88_audio 0000:04:07.1: PCI INT A -> GSI 20 (level, low) -> IRQ 
> 20                                                                                                                                     
> 
> allocation failed: out of vmalloc space - use vmalloc=<size> to increase 
> size.                                                                                                                          

You need to fix this.

Check the output of

$ cat /proc/meminfo

and look for how much vmalloc space you have total to work with and how much is used and what is the largest chunk available.

$ cat /proc/iomem

and see what size of vmalloc allocations HVR4000 devices are claiming
for PCI MMIO mappings.

Figure out how much you're short on vmalloc allocation and then add a
kernel command line option in your boot menu

	vmalloc=nnnM

to cover the vmalloc you use, the vmalloc shortfall and soom room to
spare.  Vmalloc address space allocations fragment, and if you need
large chunks of addresses, you'll need to make sure the total available
to the system is large enough to have those large chunks available.  

Note that vmalloc allocations for IO mappings are blocks of address
space and not system physical RAM.  It will generally be a headache for
you to be overly conservative with setting the 'vmalloc=' parameter in
the hopes of "saving RAM" - which you won't be.



> cx88[1]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) 
> DVB-S/S2 [card=69,autodetected], frontend(s): 
> 1                                                                                     
> 
> cx88[1]: TV tuner type -1, Radio tuner type 
> -1                                                                                                                                                          
> 
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

Note that the Ooops happened in cx88_shutdown().  So let's look at the
some code I've culled out from a tree I have lying around:


#define MO_DEV_CNTRL2       0x200034 // Device control

#define cx_write(reg,value)      writel((value), core->lmmio + ((reg)>>2))

void cx88_shutdown(struct cx88_core *core)
{
        /* disable RISC controller + IRQs */
        cx_write(MO_DEV_CNTRL2, 0);
	[...]


The code bytes in the oops disassemble to this:

   0:   41                      inc    %ecx
   1:   0c 89                   or     $0x89,%al
  [...]
  1d:   5f                      pop    %edi
  1e:   5d                      pop    %ebp
  1f:   c3                      ret    
  (everything before here is another function: we don't care)

This should be cx88_shutdown():

  20:   8b 48 38                mov    0x38(%eax),%ecx    <--- fetch core->lmmio into %ecx
  23:   31 d2                   xor    %edx,%edx          <--- make a 0 in %edx
  25:   81 c1 34 00 20 00       add    $0x200034,%ecx     <--- add MO_DEV_CNTRL2 to %ecx
  2b:   89 11                   mov    %edx,(%ecx)        <---- oops here
  2d:   8b 48 38                mov    0x38(%eax),%ecx
  30:   81 c1 40 c0 31 00       add    $0x31c040,%ecx
  36:   89 11                   mov    %edx,(%ecx)
  38:   8b 48 38                mov    0x38(%eax),%ecx
  3b:   81                      .byte 0x81
  3c:   c1 40 c0 32             roll   $0x32,0xffffffc0(%eax)

OK so my source shows a >>2 that your assembed code doesn't, but it's
obvious that "core->lmmio" is NULL (0) because:

>BUG: unable to handle kernel paging request at 00200034

means that MO_DEV_CNTRL2 was added to 0.


So how'd that happen?  Look at the trace back:

> EIP is at cx88_shutdown+0xb/0x94 [cx88xx]
> [<fd917fb6>] cx88_reset 0x2d/0x186 [cx88xx]  
> [<fd916a4c>] cx88_core_create+0x393/0xac3 [cx88xx] 

cx88_reset() looks like this:

int cx88_reset(struct cx88_core *core)
{
        dprintk(1,"%s\n",__func__);
        cx88_shutdown(core);
	[...]

So its involvement is trivial before calling cx88_shutdown().

cx88_core_create() looks like this:

struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
{
	[...]
        core->lmmio = ioremap(pci_resource_start(pci, 0),
                              pci_resource_len(pci, 0));
        core->bmmio = (u8 __iomem *)core->lmmio;

        /* board config */
	[...]
        /* init hardware */
        cx88_reset(core);
	[...]



Ooops.  Nothing checked if the output of ioremap() was NULL.

Why would the output of ioremap() equal NULL?  I can happen when you're
out of vmalloc space....



> Does anyone know what's wrong here?

You need to fix your 'vmalloc=' commandline allocation.

The cx88 driver maintainer (I'm not sure who that is, but Gerd's name is
the copyright) should add a check in cx88_core_create() to detect the
failure of ioremap() and handle it gracefully.

Regards,
Andy

> Thanks
> Thomas



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
