Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1K063A-00073f-FM
	for linux-dvb@linuxtv.org; Sun, 25 May 2008 04:33:38 +0200
From: Andy Walls <awalls@radix.net>
To: Jose Alberto Reguero <jareguero@telefonica.net>
In-Reply-To: <200805241817.07810.jareguero@telefonica.net>
References: <200805241817.07810.jareguero@telefonica.net>
Date: Sat, 24 May 2008 22:33:03 -0400
Message-Id: <1211682783.3200.36.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] kernel BUG with AverTV DVB-T 777 and
	kernel	2.6.23-rc3
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

On Sat, 2008-05-24 at 18:17 +0200, Jose Alberto Reguero wrote:
> Work well with kernel 2.6.25
> 
> Jose Alberto
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


I've figured this one out, but don't have time to make a patch just yet.
See below:


> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffffa0b1953b>] :tuner_simple:simple_tuner_attach+0x99/0x396

Note the memory address 8 access in simple_tuner_attach().

> PGD 7d988067 PUD 7d989067 PMD 0                                                 
> Oops: 0000 [1] SMP                                                              
> CPU 1                                                                           
> Modules linked in: tuner_simple tuner_types mt352 saa7134_dvb(+) mt2060 snd_usb_audio(+) videobuf_dvb snd_seq_dummy snd_hda_intel snd_seq_oss(+) saa7134 snd_seq_midi_event snd_seq snd_pcm_oss v4l2_common videobuf_dma_sg snd_mixer_oss videobuf_core snd_pcm ir_kbd_i2c dvb_usb_dib0700(+) snd_timer dib7000p ir_common dib7000m nvidia(P) pwc snd_usb_lib dvb_usb dvb_core dib3000mc dibx000_common snd_page_alloc sr_mod tveeprom compat_ioctl32 dib0070 i2c_viapro snd_rawmidi snd_seq_device snd_hwdep i2c_core cdrom sg videodev v4l1_compat button ppdev parport_pc k8temp hwmon pata_via shpchp snd serio_raw pcspkr atl1 mii parport soundcore floppy ahci ata_generic pata_acpi sata_via libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]                         
> Pid: 1553, comm: modprobe Tainted: P          2.6.26-rc3 #2                     
> RIP: 0010:[<ffffffffa0b1953b>]  [<ffffffffa0b1953b>] :tuner_simple:simple_tuner_attach+0x99/0x396

Note modprobe making a system call caused the fault, and that segment
selector 010, the kernel code segment, means the problem is in kernel
code.

> RSP: 0018:ffff81007d0d7c88  EFLAGS: 00010286                                    
> RAX: 0000000000000043 RBX: ffff81007d45c000 RCX: 00000000c3e796e9               
> RDX: 00000000ffffffff RSI: 00000000000000c3 RDI: ffff81007d45c208               
> RBP: ffff81007d0d7ce8 R08: 0000000000000001 R09: 0000000000000000               
> R10: 0000000000000000 R11: ffffffffa0b1af00 R12: ffff81007d45c1d0               
> R13: ffff81007e411408 R14: ffff81007d45c161 R15: 0000000000000043               
> FS:  00007fc159ba16f0(0000) GS:ffff81007f802780(0000) knlGS:0000000000000000    
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                               
> CR2: 0000000000000008 CR3: 000000007d98b000 CR4: 00000000000006e0               
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000               
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400               
> Process modprobe (pid: 1553, threadinfo ffff81007d0d6000, task ffff81007e142d20)
> Stack:  0000000000000000 ffffffff81054bf8 ffff000100010061 ffff81007d0d7cb7     
>  ffff81007d45c000 ffffffffa0b06e80 ffff81007d45c170 ffff81007d45c000            
>  ffff81007d45c000 ffffffffa0b06e80 ffff81007d45c170 0000000000000000            
> Call Trace:                                                                     
>  [<ffffffff81054bf8>] ? gpl_only_unused_warning+0x0/0x1b                        
>  [<ffffffffa0b033e5>] :saa7134_dvb:dvb_init+0xec5/0x15bd                        
>  [<ffffffff8102ba59>] ? try_to_wake_up+0x1cc/0x1dd                              
>  [<ffffffffa0a3c9f8>] :saa7134:saa7134_ts_register+0x4a/0x92                    
>  [<ffffffffa0139010>] :saa7134_dvb:dvb_register+0x10/0x12                       
>  [<ffffffff81057bcc>] sys_init_module+0x199c/0x1af8                             
>  [<ffffffff810a3c90>] ? do_sync_read+0xe7/0x12d                                 
>  [<ffffffff8100ba4a>] ? do_notify_resume+0x88f/0x8b0                            
>  [<ffffffff8103e66e>] ? msleep+0x0/0x1e                                         
>  [<ffffffff8100bf8b>] system_call_after_swapgs+0x7b/0x80                        
> 
> 
> Code: 60 01 00 00 48 85 c0 74 07 be 01 00 00 00 ff d0 48 8d 75 b0 ba 01 00 00 00 4c 89 e7 e8 93 4d 65 ff ff c8 74 44 44 89 f8 83 ca ff <8a> 0c 25 08 00 00 00 48 6b c0 30 4c 8b 80 90 26 b1 a0 48 8b 04                                         

The above code disassembles to:

  70:   00 00                   add    %al,(%rax)
  72:   48 85 c0                test   %rax,%rax
  75:   74 07                   je     0x7e
  77:   be 01 00 00 00          mov    $0x1,%esi
  7c:   ff d0                   callq  *%rax
  7e:   48 8d 75 b0             lea    0xffffffffffffffb0(%rbp),%rsi
  82:   ba 01 00 00 00          mov    $0x1,%edx
  87:   4c 89 e7                mov    %r12,%rdi
  8a:   e8 93 4d 65 ff          callq  0xffffffffff654e22
  8f:   ff c8                   dec    %eax
  91:   74 44                   je     0xd7
  93:   44 89 f8                mov    %r15d,%eax
  96:   83 ca ff                or     $0xffffffffffffffff,%edx
  99:   8a 0c 25 08 00 00 00    mov    0x8,%cl
                                       ^^^
                         Your problem --+  
  a0:   48 6b c0 30             imul   $0x30,%rax,%rax
  a4:   4c 8b 80 90 26 b1 a0    mov    0xffffffffa0b12690(%rax),%r8


The assembly code emitted by gcc for this segment of
tuner-simple.c:simple_tuner_attach() looks like:

        movl    $1, %edx
        movq    %r12, %rdi
        call    i2c_transfer
        decl    %eax
        je      .L362
        .loc 1 1056 0              <----- Source line 1056
        mov     %r15d, %eax
        orl     $-1, %edx
        movb    8, %cl             <----- Your problem
        imulq   $48, %rax, %rax
        movq    tuners(%rax), %r8
        movq    16, %rax           <----- Another problem
        testq   %rax, %rax
        je      .L366


The relevant section of tuner-simple.c:simple_tuner_attach():

1052                 if (fe->ops.i2c_gate_ctrl)
1053                         fe->ops.i2c_gate_ctrl(fe, 1);
1054 
1055                 if (1 != i2c_transfer(i2c_adap, &msg, 1))
1056                         tuner_warn("unable to probe %s, proceeding anyway.",
1057                                    tuners[type].name);
1058 
1059                 if (fe->ops.i2c_gate_ctrl)
1060                         fe->ops.i2c_gate_ctrl(fe, 0);


It looks like something about the "tuner_warn()" macro is causing
references to be made to very low memory addresses.  That is probably
not right.

So let's look further: here is the same section of
tuner-simple.c:simple_tuner_attach() after preprocessing, but before
conversion to assembly:

    if (fe->ops.i2c_gate_ctrl)
     fe->ops.i2c_gate_ctrl(fe, 1);

    if (1 != i2c_transfer(i2c_adap, &msg, 1))
     do { do { printk("<4>" "%s %d-%04x: " "unable to probe %s,
proceeding anyway.", priv->i2c_props.name, priv->i2c_props.adap ?
i2c_adapter_id(priv->i2c_props.adap) : -1, priv->i2c_props.addr,
tuners[type].name); } while (0); } while (0);


    if (fe->ops.i2c_gate_ctrl)
     fe->ops.i2c_gate_ctrl(fe, 0);
 

Hmmm. Lots of dereferences of something called "priv".  Looking at the
top of tuner-simple.c:simple_tuner_attach() we find:

1032         struct tuner_simple_priv *priv = NULL;
1033         int instance;

With no other operations on "priv" before the "tuner_warn()" invocation.


So tuner-simple.c:simple_tuner_attach() has a hard coded NULL pointer
dereference buried in a macro that only sometimes gets executed.
Changing the "tuner_warn()" invocation to something simple and innocuous
(e.g. plain old printk()) will work around your problem for now.

Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
