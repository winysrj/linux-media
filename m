Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd6222.kasserver.com ([85.13.131.10]:37461 "EHLO
	dd6222.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab0FAPma (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jun 2010 11:42:30 -0400
Message-ID: <4C052A64.8020107@coronamundi.de>
Date: Tue, 01 Jun 2010 17:42:28 +0200
From: Silamael <Silamael@coronamundi.de>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: PROBLEM: 2.6.34-rc7 kernel panics "BUG: unable to handle kernel
 NULL pointer dereference at (null)" while channel scan running
References: <4C023EE0.8050405@coronamundi.de> <1275347464.2260.60.camel@localhost>
In-Reply-To: <1275347464.2260.60.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/01/2010 01:11 AM, Andy Walls wrote:
> On Sun, 2010-05-30 at 12:33 +0200, Silamael wrote:
>> Kernel trace:
>> ---------------------------------------------------------------
>> [  773.280361] IP: [<f825a7ba>] saa7146_buffer_next+0x5e/0x1ed [saa7146_vv]
>> [  773.280361] *pde = 00000000
>> [  773.280361] Oops: 0000 [#1] SMP
>> [  773.280361] last sysfs file: /sys/module/nfsd/initstate
>> [  773.280361] Modules linked in: nfsd exportfs nfs lockd nfs_acl
>> auth_rpcgss sunrpc f71882fg coretemp loop lnbp21 stv0299 dvb_ttpci
>> snd_hda_codec_realtek dvb_core saa7146_vv videodev v4l1_compat
>> snd_hda_intel saa7146 snd_hda_codec videobuf_dma_sg snd_hwdep
>> videobuf_core snd_pcm i2c_i801 ttpci_eeprom psmouse snd_timer intel_agp
>> evdev pcspkr snd i2c_core serio_raw agpgart video processor rng_core
>> soundcore button output snd_page_alloc usb_storage uhci_hcd ehci_hcd
>> thermal sd_mod crc_t10dif thermal_sys usbcore nls_base e1000e [last
>> unloaded: scsi_wait_scan]
>> [  773.280361]
>> [  773.280361] Pid: 0, comm: swapper Not tainted 2.6.34-rc7 #7
>> A9830IMS/A9830IMS
>> [  773.280361] EIP: 0060:[<f825a7ba>] EFLAGS: 00010246 CPU: 0
>> [  773.280361] EIP is at saa7146_buffer_next+0x5e/0x1ed [saa7146_vv]
>> [  773.280361] EAX: f68b3008 EBX: f733d900 ECX: 00000001 EDX: 00000002
>> [  773.280361] ESI: ffffffd4 EDI: f68b3000 EBP: 00000000 ESP: c135fefc
>> [  773.280361]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>> [  773.280361] Process swapper (pid: 0, ti=c135e000 task=c138cb60
>> task.ti=c135e000)
>> [  773.280361] Stack:
>> [  773.280361]  f68b3000 f733d900 c13640bc 0000000a f825e5f6 f733d900
>> fff7fbf7 f825a759
>> [  773.280361] <0> f733d900 ffffffff f812bdfc fff7fbf7 f6a1e240 00000000
>> c106793a 00000000
>> [  773.280361] <0> 00000000 c1364080 0000000a c13640bc c135ff80 c1069072
>> 0000000a 0000000a
>> [  773.280361] Call Trace:
>> [  773.280361]  [<f825e5f6>] ? vbi_irq_done+0x99/0x9f [saa7146_vv]
>> [  773.280361]  [<f825a759>] ? vv_callback+0x10f/0x112 [saa7146_vv]
>> [  773.280361]  [<f812bdfc>] ? interrupt_hw+0x9f/0x1a8 [saa7146]
>> [  773.280361]  [<c106793a>] ? handle_IRQ_event+0x49/0xe7
>> [  773.280361]  [<c1069072>] ? handle_level_irq+0x55/0x9e
>> [  773.280361]  [<c10044cb>] ? handle_irq+0x17/0x1c
>> [  773.280361]  [<c1003da9>] ? do_IRQ+0x38/0x8e
>> [  773.280361]  [<c1002d30>] ? common_interrupt+0x30/0x38
>> [  773.280361]  [<c10086e6>] ? mwait_idle+0x59/0x5e
>> [  773.280361]  [<c1001ae7>] ? cpu_idle+0x91/0xaa
>> [  773.280361]  [<c13b9881>] ? start_kernel+0x31c/0x321
>> [  773.280361] Code: 50 fc 25 f8 e8 9d 0e 01 c9 83 c4 1c 8b 43 44 89 c2
>> c1 fa 08 38 c2 75 04 0f 0b eb fe 8b 77 08 8d 47 08 39 c6 74 6b 83 ee 2c
>> 31 ed <8b> 4e 2c 8b 56 30 89 51 04 89 0a c7 46 2c 00 01 10 00 c7 46 30
> 
> Refer to linux/drivers/media/common/saa7146_fops.c:saa7146_buffer_next()
>         
>         void saa7146_buffer_next(struct saa7146_dev *dev,
>                                  struct saa7146_dmaqueue *q, int vbi)
>         {
>                 struct saa7146_buf *buf,*next = NULL;
>         
>                 BUG_ON(!q);
>         
>                 DEB_INT(("dev:%p, dmaq:%p, vbi:%d\n", dev, q, vbi));
>         
>                 assert_spin_locked(&dev->slock);
>                 if (!list_empty(&q->queue)) {
>                         /* activate next one from queue */
>                         buf = list_entry(q->queue.next,struct saa7146_buf,vb.queue);
>                         list_del(&buf->vb.queue);
>                         if (!list_empty(&q->queue))
>         [...]
> 
> The code bytes from the above disassemble to:
> 
>   37:   e8 9d 0e 01 c9          call   0xc9010ed9
>   3c:   83 c4 1c                add    $0x1c,%esp
>   3f:   8b 43 44                mov    0x44(%ebx),%eax
>   42:   89 c2                   mov    %eax,%edx
>   44:   c1 fa 08                sar    $0x8,%edx
>   47:   38 c2                   cmp    %al,%dl
>   49:   75 04                   jne    0x4f
>   4b:   0f 0b                   ud2a                  <---+ End of BUG_ON() in
>   4d:   eb fe                   jmp    0x4d           <---| assert_spin_locked()
>   4f:   8b 77 08                mov    0x8(%edi),%esi  ; %esi = q->queue->head
>   52:   8d 47 08                lea    0x8(%edi),%eax  ; %eax = q->queue->head->next
>   55:   39 c6                   cmp    %eax,%esi       ; if (!list_empty(&q->queue))
>   57:   74 6b                   je     0xc4            ; skip to else clause
>   59:   83 ee 2c                sub    $0x2c,%esi      ; buf = list_entry(q->queue.next,struct saa7146_buf,vb.queue);
>   5c:   31 ed                   xor    %ebp,%ebp
>   5e:   8b 4e 2c                mov    0x2c(%esi),%ecx   <--- Oops here; %ecx = buf->vb.queue->next
>   61:   8b 56 30                mov    0x30(%esi),%edx
>   64:   89 51 04                mov    %edx,0x4(%ecx)
>   67:   89 0a                   mov    %ecx,(%edx)
>   69:   c7 46 2c 00 01 10 00    movl   $0x100100,0x2c(%esi)
> 
> The Oops happens because q->queue.next is NULL, which is invalid. There
> is some sort of saa7146_dmaqueue list or videobuf list corruption
> problem somewhere.
> 
> I am not familiar enough with the saa7146 nor videobuf to be of much
> more help.
> 
> Regards,
> Andy
> 

Hi Andy,

Thank you for the deeper analysis of this crash. That is much more i
could have done ;)
Hopefully someone shows up with some solution too.

Greetings,
Matthias
