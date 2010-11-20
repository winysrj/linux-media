Return-path: <mchehab@gaivota>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44788 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab0KTJpB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 04:45:01 -0500
Date: Sat, 20 Nov 2010 11:19:16 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, sparclinux@vger.kernel.org
Subject: bttv_open NULL dereference on sparc64
Message-ID: <alpine.SOC.1.00.1011192335460.10680@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

bttv driver loaded fine in 2.6.36 (didn't test it yet in this sparc box) 
but gives NULL pointer dereference oops in 2.6.37-rc2-00065-g589136b on 
startup.

[   61.633782] IR NEC protocol handler initialized
[   61.851883] PCI: Enabling device: (0000:01:02.1), cmd 2
[   61.922133] bt87x0: Using board 1, analog, digital (rate 32000 Hz)
[   62.162628] IR RC5(x) protocol handler initialized
[   62.321352] pci-db used greatest stack depth: 8 bytes left
[   63.576591] IR RC6 protocol handler initialized
[   63.676101] PCI: Enabling device: (0000:01:00.0), cmd 1
[   63.910067] PCI: Enabling device: (0000:01:01.0), cmd 2
[   64.166000] IR JVC protocol handler initialized
[   64.293005] IR Sony protocol handler initialized
[   64.396326] PCI: Enabling device: (0000:00:08.0), cmd 3
[   64.861239] Linux video capture interface: v2.00
[   64.948963] lirc_dev: IR Remote Control driver registered, major 252 
[   65.125650] IR LIRC bridge handler initialized
[   65.264400] bttv: driver version 0.9.18 loaded
[   65.322813] bttv: using 8 buffers with 2080k (260 pages) each for capture
[   65.412340] bttv: Bt8xx card found (0).
[   65.462762] PCI: Enabling device: (0000:01:02.0), cmd 2
[   65.531440] bttv0: Bt878 (rev 17) at 0000:01:02.0, irq: 18, latency: 64, mmio: 0x1ff03002000
[   65.645793] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
[   65.749028] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
[   65.830423] bttv0: gpio: en=00000000, out=00000000 in=00fffffb [init]
[   65.917295] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
[   66.032737] tveeprom 1-0050: Hauppauge model 38104, rev B529, serial# 5085141
[   66.126499] tveeprom 1-0050: tuner model is Temic 4006FH5 (idx 29, type 14)
[   66.218031] tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
[   66.296997] tveeprom 1-0050: audio processor is None (idx 0)
[   66.371391] tveeprom 1-0050: has no radio
[   66.424068] bttv0: Hauppauge eeprom indicates model#38104
[   66.495042] bttv0: tuner type=14
[   66.682059] bttv0: audio absent, no audio device found!
[   67.037269] tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
[   67.177464] tuner-simple 1-0061: creating new instance
[   67.245143] tuner-simple 1-0061: type set to 14 (Temic PAL_BG (4006FH5))
[   67.334394] bttv0: registered device video0
[   67.389528] bttv0: registered device vbi0
[   67.442203] bttv0: PLL: 28636363 => 35468950 .. ok
[   67.565972] Unable to handle kernel NULL pointer dereference
[   67.640491] tsk->{mm,active_mm}->context = 0000000000000172
[   67.713763] tsk->{mm,active_mm}->pgd = fffff8007d8fc000
[   67.782441]               \|/ ____ \|/
[   67.782450]               "@'/ .. \`@"
[   67.782457]               /_| \__/ |_\
[   67.782464]                  \__U_/
[   67.975853] v4l_id(530): Oops [#1]
[   68.020493] TSTATE: 0000008811001601 TPC: 00000000006cda28 TNPC: 00000000006cda2c Y: 00000000    Not tainted
[   68.149794] TPC: <__mutex_lock_slowpath+0x28/0xe0>
[   68.212719] g0: fffff80000002cf0 g1: ffffffffffffffff g2: 0000000000000000 g3: fffff8007de378a8
[   68.327145] g4: fffff8007d915540 g5: 0000000000000018 g6: fffff8007de34000 g7: ffffffffffffffff
[   68.441543] o0: ffffffffffffffff o1: fffff8007ddd3418 o2: 0000000000040000 o3: 0000000000000000
[   68.555944] o4: 0000000000000000 o5: 0000000000000000 sp: fffff8007de36ff1 ret_pc: 00000000006cdda8
[   68.674923] RPC: <mutex_lock+0x8/0x40>
[   68.724153] l0: fffff8007d915540 l1: 0000000000000000 l2: 0000000000422214 l3: fffff8007ddd3420
[   68.838573] l4: 0000000000000014 l5: 00000000ffe79f0d l6: fffff8007de34000 l7: 000000000043ec40
[   68.952972] i0: fffff8007ddd3418 i1: 0000000000000000 i2: 0000000000000000 i3: 0000000000000000
[   69.067374] i4: 0000000000000000 i5: 0000000000000000 i6: fffff8007de370c1 i7: 00000000103e45a8
[   69.181976] I7: <bttv_open+0xa8/0x240 [bttv]>
[   69.239208] Call Trace:
[   69.271338]  [00000000103e45a8] bttv_open+0xa8/0x240 [bttv]
[   69.344616]  [0000000010398708] v4l2_open+0xc8/0x100 [videodev]
[   69.422409]  [00000000004bcd74] chrdev_open+0x94/0x140
[   69.489948]  [00000000004b835c] __dentry_open+0x9c/0x2a0
[   69.559772]  [00000000004c45ac] do_last+0x32c/0x680
[   69.623878]  [00000000004c62cc] do_filp_open+0x1cc/0x560
[   69.693701]  [00000000004b8180] do_sys_open+0x40/0x100
[   69.761251]  [0000000000405fd4] linux_sparc_syscall32+0x34/0x40
[   69.839061] Disabling lock debugging due to kernel taint
[   69.908919] Caller[00000000103e45a8]: bttv_open+0xa8/0x240 [bttv]
[   69.989022] Caller[0000000010398708]: v4l2_open+0xc8/0x100 [videodev]
[   70.073691] Caller[00000000004bcd74]: chrdev_open+0x94/0x140
[   70.148087] Caller[00000000004b835c]: __dentry_open+0x9c/0x2a0
[   70.224768] Caller[00000000004c45ac]: do_last+0x32c/0x680
[   70.295737] Caller[00000000004c62cc]: do_filp_open+0x1cc/0x560
[   70.372419] Caller[00000000004b8180]: do_sys_open+0x40/0x100
[   70.446953] Caller[0000000000405fd4]: linux_sparc_syscall32+0x34/0x40
[   70.531600] Caller[0000000000000000]:           (null)
[   70.599133] Instruction DUMP: e677a7e7  82100007  c477a7ef <c6708000> c877a7f7  84100001  c6060000  c3e61003  80a0c001 
[   70.743855] Unable to handle kernel NULL pointer dereference
[   70.818327] tsk->{mm,active_mm}->context = 0000000000000173
[   70.891531] tsk->{mm,active_mm}->pgd = fffff8007d956000
[   70.960210]               \|/ ____ \|/
[   70.960219]               "@'/ .. \`@"
[   70.960226]               /_| \__/ |_\
[   70.960232]                  \__U_/
[   71.153482] v4l_id(531): Oops [#2]
[   71.198162] TSTATE: 0000008811001601 TPC: 00000000006cda28 TNPC: 00000000006cda2c Y: 00000000    Tainted: G      D    
[   71.338897] TPC: <__mutex_lock_slowpath+0x28/0xe0>
[   71.401818] g0: fffff8007de3af91 g1: ffffffffffffffff g2: 0000000000000000 g3: fffff8007de3b8a8
[   71.516241] g4: fffff8007da99aa0 g5: 0000000000000018 g6: fffff8007de38000 g7: ffffffffffffffff
[   71.630654] o0: ffffffffffffffff o1: fffff8007ddd3018 o2: 0000000000040000 o3: 0000000000000000
[   71.745191] o4: 0000000000000000 o5: 0000000000000000 sp: fffff8007de3aff1 ret_pc: 00000000006cdda8
[   71.864139] RPC: <mutex_lock+0x8/0x40>
[   71.913346] l0: fffff8007da99aa0 l1: 0000000000000000 l2: 0000000000422214 l3: fffff8007ddd3020
[   72.027773] l4: 0000000000000014 l5: 00000000ff9c7f11 l6: fffff8007de38000 l7: 000000000043ec40
[   72.142172] i0: fffff8007ddd3018 i1: 0000000000000000 i2: 0000000000000000 i3: 0000000000000000
[   72.256572] i4: 0000000000000000 i5: 0000000000000000 i6: fffff8007de3b0c1 i7: 00000000103e45a8
[   72.371033] I7: <bttv_open+0xa8/0x240 [bttv]>
[   72.428201] Call Trace:
[   72.460330]  [00000000103e45a8] bttv_open+0xa8/0x240 [bttv]
[   72.533601]  [0000000010398708] v4l2_open+0xc8/0x100 [videodev]
[   72.611398]  [00000000004bcd74] chrdev_open+0x94/0x140
[   72.678939]  [00000000004b835c] __dentry_open+0x9c/0x2a0
[   72.748779]  [00000000004c45ac] do_last+0x32c/0x680
[   72.812874]  [00000000004c62cc] do_filp_open+0x1cc/0x560
[   72.882697]  [00000000004b8180] do_sys_open+0x40/0x100
[   72.950377]  [0000000000405fd4] linux_sparc_syscall32+0x34/0x40
[   73.028194] Caller[00000000103e45a8]: bttv_open+0xa8/0x240 [bttv]
[   73.108293] Caller[0000000010398708]: v4l2_open+0xc8/0x100 [videodev]
[   73.192961] Caller[00000000004bcd74]: chrdev_open+0x94/0x140
[   73.267358] Caller[00000000004b835c]: __dentry_open+0x9c/0x2a0
[   73.344040] Caller[00000000004c45ac]: do_last+0x32c/0x680
[   73.415010] Caller[00000000004c62cc]: do_filp_open+0x1cc/0x560
[   73.491691] Caller[00000000004b8180]: do_sys_open+0x40/0x100
[   73.566091] Caller[0000000000405fd4]: linux_sparc_syscall32+0x34/0x40
[   73.650766] Caller[0000000000000000]:           (null)
[   73.718303] Instruction DUMP: e677a7e7  82100007  c477a7ef <c6708000> c877a7f7  84100001  c6060000  c3e61003  80a0c001 

My preliminary analysis of the bttv_open+0xa8/0x240 tells it's past some 
"compare with zero and assign something and jump some lines back to make 
return" which was probably the kmalloc NULL check.

So it seems to be something with the mutex or btv:

        /*
         * btv is protected by btv->lock mutex, while btv->init and other
         * streaming vars are protected by fh->cap.vb_lock. We need to take
         * care of both locks to avoid troubles. However, vb_lock is used also
         * inside videobuf, without calling buf->lock. So, it is a very bad
         * idea to hold both locks at the same time.
         * Let's first copy btv->init at fh, holding cap.vb_lock, and then work
         * with the rest of init, holding btv->lock.
         */
        mutex_lock(&fh->cap.vb_lock);
        *fh = btv->init;
        mutex_unlock(&fh->cap.vb_lock);

Additional printk tells that fh, btv and fh->cap.vb_lock are not NULL.
Where else to look? mutex implementation or initialization?

-- 
Meelis Roos (mroos@linux.ee)
