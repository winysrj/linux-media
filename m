Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39418 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbaAKOWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jan 2014 09:22:12 -0500
Message-ID: <1389450174.1917.19.camel@palomino.walls.org>
Subject: tda8290 broken badly with cx18 (Re: Kernel crash with modprobe cx18)
From: Andy Walls <awalls@md.metrocast.net>
To: Scott Robinson <scott.robinson55@gmail.com>,
	Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Date: Sat, 11 Jan 2014 09:22:54 -0500
In-Reply-To: <CAL0vL9w56ZG5KHFhcSxvp4kwE-Oi6-B-BqnAW9DTMApyMWp7pA@mail.gmail.com>
References: <CAL0vL9x-zWXVdyffrtfczkOHjmf9qUcf_Eeqqzew8Xw+F9Hy+Q@mail.gmail.com>
	 <1387417215.2011.5.camel@palomino.walls.org>
	 <CAL0vL9x939figYiHkOk1obFTPtB4YQ4jLS3uzxw_BsT_U3m+Ew@mail.gmail.com>
	 <1387501871.1888.11.camel@palomino.walls.org>
	 <CAL0vL9ywTw3xcwPLkRbbsbNQiTg+zaE_OiJXNN3BPnWasu6USQ@mail.gmail.com>
	 <1388246077.2129.16.camel@palomino.walls.org>
	 <CAL0vL9w56ZG5KHFhcSxvp4kwE-Oi6-B-BqnAW9DTMApyMWp7pA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2014-01-10 at 10:55 -0600, Scott Robinson wrote:
> I did the bisect. My results are as follows:

Hi Scott,

Thank you! for doing a bisection.  It is a non-trivial investment in
time.

Ondrej and Mike,

The change Scott isolated below breaks cx18 driver use of the TDA8290.
See the Ooops in the email chain below.

For how the cx18 driver initializes analog tuners, see the following:

	cx18-driver.c:cx18_probe() (search for 'struct tuner_setup')
	cx18-i2c.c:cx18_i2c_register()

Do you have any recommendations on how to fix the Oops by the tda8290
driver?

Regards,
Andy

> cdcd141c95f0c2b88e0b0869028c320cd031a23b is the first bad commit
> commit cdcd141c95f0c2b88e0b0869028c320cd031a23b
> Author: Ondrej Zary <linux@rainbow-software.org>
> Date:   Sat Apr 6 14:21:36 2013 -0300
> 
>     [media] tuner-core: Change config from unsigned int to void *
> 
>     config looks like a hack that was added to tuner-core to allow some
>     configuration of TDA8290 tuner (it's not used by any other driver).
>     But with the new configuration options of tda8290 driver (no_i2c_gate
>     and std_map), it's no longer sufficient.
>     Change config to be void * instead, which allows passing tuner-dependent
>     config struct to drivers.
>     Also update saa7134 driver to reflect this change (no other driver
> uses this).
> 
>     Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>     Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> :040000 040000 f2492f3c86adf77f671bcda6bd9fcc3541b69e48
> 9e42c49fecb111f2f6aec6102bed1e29194a2fd5 M    drivers
> :040000 040000 23c5843c6a01e8b8a69bd2237a2d2f1e5aa7a154
> d7937ce34beccf87efcffb742504a1c545e6a9eb M    include
> 
> Regards,
> Scott
> 
> 
> On Sat, Dec 28, 2013 at 9:54 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> > On Thu, 2013-12-26 at 06:57 -0600, Scott Robinson wrote:
> >> The machine with which I encountered this problem has two HVR-1600
> >> cards. I moved one card to another machine. The card still fails at
> >> the same point. I ran memtest, which passed. The machine has about 3GB
> >> memory free. I loaded other versions of the kernel. Up to and
> >> including 3.9.11-200.fc18 work. Starting at 3.10.4-100.fc18 fail. I
> >> tried a Ubuntu 13.10 (kernel-3.11.0-12-generic) livecd; the machine
> >> failed at the same point.
> >
> > OK.  I'll have to find some time to bisect this problem with my own
> > setup at home.  Having known good and bad versions helps bound where the
> > problem could be, thanks.
> >
> > I'm very busy at work until about mid-January, so don't expect much
> > until then. Bisection iterations take me about 2 hours each, IIRC.
> >
> >         $ git bisect start v3.10 v3.9
> >
> > tells me I have 14 steps, so 28 hours, or 3.5 full work days.
> >
> >
> >> I am wondering what changed, starting with the 3.10 series, that may
> >> cause this problem.
> >
> > A change to the tuner driver in question; not likely the cx18 driver
> > itself.
> >
> > I'll wildly speculate that it might be a driver problem with attempting
> > to use too much memory from the kernel stack.
> >
> > It doesn't matter. The Oops is close to useless in finding the cause.
> > It'll have to be bisected.
> >
> >>  I also wonder why I haven't seen this problem
> >> reported before.
> >
> > Both Conventional (legacy) PCI and Analog TV are about dead; that
> > probably means a small user base.
> >
> >
> >> I looked at modinfo. That's above my skill level. I use the cards to
> >> record using the analog cable input, the mpeg encoder. What options
> >> could I use to inhibit everything else?
> >>
> >> I would appreciate any advise as to what else I may check to isolate
> >> this problem.
> >
> > I'll say not much at this point; unless you want to start bisecting
> > kernel source code revisions and compiling, installing, and tetsing
> > custom kernels.
> >
> > Regards,
> > Andy
> >
> >> Thanks,
> >> Scott
> >>
> >>
> >> On Thu, Dec 19, 2013 at 7:11 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> >> > On Thu, 2013-12-19 at 07:00 -0600, Scott Robinson wrote:
> >> >> Please see attachment. Many thanks for your response.
> >> >
> >> >> On Wed, Dec 18, 2013 at 7:40 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> >> >> > On Wed, 2013-12-18 at 13:06 -0600, Scott Robinson wrote:
> >> >> >> I am running Fedora 18, x86_64, and recently updated the kernel to
> >> >> >> 3.11.10-100.fc18 from 3.6.10-4.fc18.
> >> >> >>
> >> >> >> When I try to install the cx18 module, the kernel crashes with the following:
> >> >> >
> >> >> > Can you provide the output of
> >> >> >
> >> >> >         $ objdump -d -l -F /lib/modules/3.11.10-100.fc18.x86_64/kernel/drivers/media/common/tuners/tda8290.ko
> >> >> >
> >> >> > for the first few screenfuls of the tda829x_attach function?
> >> >> >
> >> >> > I can match that up with the kernel v3.10 source code and see what
> >> >> > pointer is NULL.
> >> >
> >> >> >> [  495.361662] netconsole: network logging started
> >> >> >> [  558.481787] media: Linux media interface: v0.10
> >> >> >> [  558.502941] Linux video capture interface: v2.00
> >> >> >> [  558.617145] cx18:  Start initialization, version 1.5.1
> >> >> >> [  558.617237] cx18-0: Initializing card 0
> >> >
> >> >> >> [  558.725076] cx18-0:  info: activating i2c...
> >> >> >> [  558.725084] cx18-0:  i2c: i2c init
> >> >> >> [  558.858738] tveeprom 6-0050: Hauppauge model 74351, rev F1F5, serial# 7764125
> >> >> >> [  558.858766] tveeprom 6-0050: MAC address is 00:0d:fe:76:78:9d
> >> >> >> [  558.858790] tveeprom 6-0050: tuner model is NXP 18271C2 (idx 155, type 54)
> >> >> >> [  558.858801] tveeprom 6-0050: TV standards PAL(B/G) NTSC(M) PAL(I)
> >> >> >> SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> >> >> >> [  558.858817] tveeprom 6-0050: audio processor is CX23418 (idx 38)
> >> >> >> [  558.858825] tveeprom 6-0050: decoder processor is CX23418 (idx 31)
> >> >> >> [  558.858839] tveeprom 6-0050: has no radio
> >> >> >> [  558.858847] cx18-0: Autodetected Hauppauge HVR-1600
> >> >> >> [  558.858860] cx18-0:  info: Worldwide tuner detected
> >> >> >> [  558.858882] cx18-0:  info: GPIO initial dir: 0000cffe/0000ffff out:
> >> >> >> 00003001/00000000
> >> >> >> [  558.908552] cx18-0: Simultaneous Digital and Analog TV capture supported
> >> >> >> [  559.075778] tuner 7-0042: Tuner -1 found with type(s) Radio TV.
> >> >> >> [  559.098598] cs5345 6-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
> >> >> >> [  559.105203] BUG: unable to handle kernel NULL pointer dereference
> >> >> >> at 0000000000000202
> >> >> >> [  559.109526] IP: [<ffffffffa04facae>] tda829x_attach+0x6e/0xba0 [tda8290]
> >> >> >> [  559.113832] PGD 0
> >> >> >> [  559.118058] Oops: 0000 [#1] SMP
> >> >> >> [  559.122219] Modules linked in: cs5345 tda8290 tuner cx18(+)
> >> >> >> videobuf_vmalloc tveeprom cx2341x videobuf_core dvb_core v4l2_common
> >> >> >> videodev media netconsole nfsv4 dns_resolver nfs lockd fscache
> >> >> >> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq
> >> >> >> snd_seq_device snd_pcm snd_page_alloc ppdev kvm_amd kvm sp5100_tco
> >> >> >> snd_timer snd soundcore shpchp parport_pc parport microcode serio_raw
> >> >> >> edac_core k10temp edac_mce_amd acpi_cpufreq mperf i2c_piix4 uinput
> >> >> >> ata_generic pata_acpi radeon i2c_algo_bit drm_kms_helper pata_atiixp
> >> >> >> ttm r8169 drm mii i2c_core sunrpc
> >> >> >> [  559.137276] CPU: 0 PID: 26 Comm: kworker/0:1 Not tainted
> >> >> >> 3.11.10-100.fc18.x86_64 #1
> >> >> >> [  559.142306] Hardware name: FOXCONN A6VMX/A6VMX, BIOS 080014  06/03/2009
> >> >> >> [  559.147406] Workqueue: events work_for_cpu_fn
> >> >> >> [  559.152497] task: ffff880121ef9e80 ti: ffff8801219a0000 task.ti:
> >> >> >> ffff8801219a0000
> >> >> >> [  559.157655] RIP: 0010:[<ffffffffa04facae>]  [<ffffffffa04facae>]
> >> >> >> tda829x_attach+0x6e/0xba0 [tda8290]
> >> >> >> [  559.162964] RSP: 0018:ffff8801219a1b68  EFLAGS: 00010202
> >> >> >> [  559.168238] RAX: ffff88011d3bf060 RBX: ffff88011c734000 RCX: 0000000000000000
> >> >> >> [  559.173537] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88011d3bf0c0
> >> >> >> [  559.178905] RBP: ffff8801219a1bf8 R08: 0000000000016f00 R09: ffff880123401a00
> >> >> >> [  559.184294] R10: ffffffffa04fac87 R11: 0000000000000000 R12: ffff88011d3bf060
> >> >> >> [  559.189662] R13: 0000000000000202 R14: ffff88012099d698 R15: 0000000000000042
> >> >> >> [  559.195081] FS:  00007fc9f1c89840(0000) GS:ffff880127c00000(0000)
> >> >> >> knlGS:0000000000000000
> >> >> >> [  559.200563] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >> >> >> [  559.206034] CR2: 0000000000000202 CR3: 0000000001c0c000 CR4: 00000000000007f0
> >> >> >> [  559.211611] Stack:
> >> >> >> [  559.217124]  ffff8801219a1bc8 ffffffff810cc08d ffff88012099d370
> >> >> >> ffffffffa04f6138
> >> >> >> [  559.222852]  ffff8801219a0101 ffffffffa04fe060 0000000000000000
> >> >> >> ffffffffa04fd030
> >> >> >> [  559.228659]  ffff8801219a1c4c ffffffffa04fd030 0000000000000036
> >> >> >> 00000000b58d6d22
> >> >> >> [  559.234345] Call Trace:
> >> >> >> [  559.239922]  [<ffffffff810cc08d>] ? find_symbol+0x3d/0xb0
> >> >> >> [  559.245535]  [<ffffffffa04f3605>] set_type+0x325/0x9f0 [tuner]
> >> >> >> [  559.251177]  [<ffffffffa04c95ca>] ? cx18_i2c_register+0x15a/0x210 [cx18]
> >> >> >> [  559.256814]  [<ffffffffa04f3d6f>] tuner_s_type_addr+0x9f/0x140 [tuner]
> >> >> >> [  559.262494]  [<ffffffffa04c8722>] cx18_probe+0xda2/0x1560 [cx18]
> >> >> >> [  559.268195]  [<ffffffff8133d4ab>] local_pci_probe+0x4b/0x80
> >> >> >> [  559.273897]  [<ffffffff81080da8>] work_for_cpu_fn+0x18/0x30
> >> >> >> [  559.279604]  [<ffffffff8108391a>] process_one_work+0x17a/0x400
> >> >> >> [  559.285341]  [<ffffffff81083bcc>] process_scheduled_works+0x2c/0x40
> >> >> >> [  559.291056]  [<ffffffff81084ed2>] worker_thread+0x262/0x370
> >> >> >> [  559.296787]  [<ffffffff81084c70>] ? manage_workers.isra.21+0x2b0/0x2b0
> >> >> >> [  559.302532]  [<ffffffff8108b3e0>] kthread+0xc0/0xd0
> >> >> >> [  559.308252]  [<ffffffff81010000>] ? perf_trace_xen_mc_callback+0xe0/0xe0
> >> >> >> [  559.314017]  [<ffffffff8108b320>] ? kthread_create_on_node+0x120/0x120
> >> >> >> [  559.319770]  [<ffffffff8167576c>] ret_from_fork+0x7c/0xb0
> >> >> >> [  559.325544]  [<ffffffff8108b320>] ? kthread_create_on_node+0x120/0x120
> >> >> >> [  559.331343] Code: c9 a8 c9 e0 48 85 c0 49 89 c4 0f 84 7e 0a 00 00
> >> >> >> 4d 85 ed 48 89 83 28 03 00 00 44 88 38 4c 89 70 08 48 c7 40 18 87 d4
> >> >> >> 4f a0 74 12 <41> 8b 45 00 41 89 44 24 38 49 8b 45 08 49 89 44 24 48 4d
> >> >> >> 8d 74
> >> >> >> [  559.344343] RIP  [<ffffffffa04facae>] tda829x_attach+0x6e/0xba0 [tda8290]
> >> >> >> [  559.350561]  RSP <ffff8801219a1b68>
> >> >> >> [  559.356632] CR2: 0000000000000202
> >> >> >> [  559.396189] ---[ end trace d9c77bf63cfd8777 ]---
> >> >
> >> > OK, this is kind of weird.  The failure point in question is here in
> >> > drivers/media/tuners/tda8290.c:tda829x_attach():
> >> >
> >> >         struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
> >> >                                             struct i2c_adapter *i2c_adap, u8 i2c_addr,
> >> >                                             struct tda829x_config *cfg)
> >> >         {
> >> >                 struct tda8290_priv *priv = NULL;
> >> >                 char *name;
> >> >
> >> >                 priv = kzalloc(sizeof(struct tda8290_priv), GFP_KERNEL);
> >> >                 if (priv == NULL)
> >> >                         return NULL;
> >> >                 fe->analog_demod_priv = priv;
> >> >
> >> >                 priv->i2c_props.addr     = i2c_addr;
> >> >                 priv->i2c_props.adap     = i2c_adap;
> >> >                 priv->i2c_props.name     = "tda829x";
> >> >                 if (cfg) {
> >> >                         priv->cfg.config = cfg->lna_cfg;
> >> >                         priv->tda18271_std_map = cfg->tda18271_std_map;
> >> >                 }
> >> >
> >> >                 if (tda8290_probe(&priv->i2c_props) == 0) {
> >> >                         priv->ver = TDA8290;
> >> >                         memcpy(&fe->ops.analog_ops, &tda8290_ops,   <------- accessing tda8290_ops seems to be it
> >> >                                sizeof(struct analog_demod_ops));
> >> >                 }
> >> >                 [...]
> >> >
> >> > The memcpy() gets unrolled by the compiler, and when the processor is
> >> > copying the first word of the "tda8290_ops" variable, the NULL
> >> > dereference occurs.
> >> >
> >> >              c87:       f6 be d0                test   %rax,%rax ; if (priv == NULL)
> >> >              c8a:       80 00 00                mov    %rax,%r12
> >> >              c8d:       41 55 49 89 cd 41       je     1711 <tda829x_release+0x16e1> (File Offset: 0x1751); return NULL;
> >> >              c93:       54 53 48                test   %r13,%r13 ; if (cfg) {
> >> >              c96:       89 fb 48 83 ec 68 48    mov    %rax,0x328(%rbx) ; fe->analog_demod_priv = priv;
> >> >              c9d:       8b 3d 00                mov    %r15b,(%rax) ; priv->i2c_props.addr     = i2c_addr;
> >> >              ca0:       00 00 00 65             mov    %r14,0x8(%rax) ; priv->i2c_props.adap     = i2c_adap;
> >> >              ca4:       48 8b 04 25 28 00 00    movq   $0x0,0x18(%rax) ; priv->i2c_props.name     = "tda829x";
> >> >              cab:       00
> >> >              cac:       48 89                   je     cc0 <tda829x_release+0xc90> (File Offset: 0xd00)
> >> >              cae:       45 c8 31 c0             mov    0x0(%r13),%eax ; cfg->lna_cfg
> >> >              cb2:       e8 00 00 00 00          mov    %eax,0x38(%r12) ; priv->cfg.config = cfg->lna_cfg;
> >> >              cb7:       48 85 c0 49             mov    0x8(%r13),%rax
> >> >              cbb:       89 c4 0f 84 7e          mov    %rax,0x48(%r12) ; priv->tda18271_std_map = cfg->tda18271_std_map;
> >> >              cc0:       0a 00 00 4d 85          lea    0x8(%r12),%r14 ; &priv->i2c_props.adap
> >> >              cc5:       ed 48 89                mov    %r12,%rdi ; &priv->i2c_props
> >> >              cc8:       83 28 03                mov    %r14,%rsi ; priv->i2c_props.adap
> >> >              ccb:       00 00 44 88 38          callq  50 <tda829x_release+0x20> (File Offset: 0x90) ; tda8290_probe();
> >> >              cd0:       4c 89                   test   %eax,%eax ; if (tda8290_probe(&priv->i2c_props) == 0) {
> >> >              cd2:       70 08 48 c7 40 18       jne    d5c <tda829x_release+0xd2c> (File Offset: 0xd9c)
> >> >              cd8:       00 00 00 00 74 12 41    mov    0x0(%rip),%rax        # cdf <tda829x_release+0xcaf> (File Offset: 0xd1f) ; unrolled memcpy(&fe->ops.analog_ops, &tda8290_ops, sizeof(struct analog_demod_ops)); first read
> >> >              cdf:       8b 45 00 41 89 44       movb   $0x1,0x22(%r12) ; priv->ver = TDA8290;
> >> >              ce5:       24 38 49 8b 45 08 49    mov    %rax,0x2a8(%rbx) ; first write of unrolled memcpy()
> >> >              cec:       89 44 24 48 4d 8d 74    mov    0x0(%rip),%rax        # cf3 <tda829x_release+0xcc3> (File Offset: 0xd33) ; second read of unrolled memcpy()
> >> >              cf3:       24 08 4c 89 e7 4c 89    mov    %rax,0x2b0(%rbx) ; second write of unrolled memcpy();
> >> >         [...]
> >> >
> >> > But that "tda8290_ops" structure should be a constant that doesn't
> >> > change.  Either you've got a serious memory problem or something is
> >> > going on that I can't see.
> >> >
> >> > The page fault below that follows the initial fault is likely another
> >> > symptom, but it doesn't help find the real problem.
> >> >
> >> > The cx18 driver is a bit of pig when it comes to memory; it grabs a
> >> > bunch of memory for various streams at module load.
> >> >
> >> > You can use the module options to the cx18 driver to inhibit it from
> >> > allocating memory for streams you don't use and for lower memory grabbed
> >> > for streams you do use.  See 'modinfo cx18'.
> >> >
> >> > Regards,
> >> > Andy
> >> >
> >> >> >> [  559.398420] BUG: unable to handle kernel paging request at ffffffffffffffd8
> >> >> >> [  559.404868] IP: [<ffffffff8108b6c0>] kthread_data+0x10/0x20
> >> >> >> [  559.411371] PGD 1c0f067 PUD 1c11067 PMD 0
> >> >> >> [  559.417676] Oops: 0000 [#2] SMP
> >> >> >> [  559.423821] Modules linked in: cs5345 tda8290 tuner cx18(+)
> >> >> >> videobuf_vmalloc tveeprom cx2341x videobuf_core dvb_core v4l2_common
> >> >> >> videodev media netconsole nfsv4 dns_resolver nfs lockd fscache
> >> >> >> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq
> >> >> >> snd_seq_device snd_pcm snd_page_alloc ppdev kvm_amd kvm sp5100_tco
> >> >> >> snd_timer snd soundcore shpchp parport_pc parport microcode serio_raw
> >> >> >> edac_core k10temp edac_mce_amd acpi_cpufreq mperf i2c_piix4 uinput
> >> >> >> ata_generic pata_acpi radeon i2c_algo_bit drm_kms_helper pata_atiixp
> >> >> >> ttm r8169 drm mii i2c_core sunrpc
> >> >> >> [  559.444987] CPU: 0 PID: 26 Comm: kworker/0:1 Tainted: G      D
> >> >> >> 3.11.10-100.fc18.x86_64 #1
> >> >> >> [  559.452106] Hardware name: FOXCONN A6VMX/A6VMX, BIOS 080014  06/03/2009
> >> >> >> [  559.459180] task: ffff880121ef9e80 ti: ffff8801219a0000 task.ti:
> >> >> >> ffff8801219a0000
> >> >> >> [  559.466267] RIP: 0010:[<ffffffff8108b6c0>]  [<ffffffff8108b6c0>]
> >> >> >> kthread_data+0x10/0x20
> >> >> >> [  559.473364] RSP: 0018:ffff8801219a1758  EFLAGS: 00010092
> >> >> >> [  559.480514] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000f
> >> >> >> [  559.487469] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880121ef9e80
> >> >> >> [  559.494212] RBP: ffff8801219a1758 R08: ffff880121ef9ef0 R09: 000000000000005f
> >> >> >> [  559.500757] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880127c14180
> >> >> >> [  559.507118] R13: 0000000000000000 R14: 0000000000000001 R15: ffff880121ef9e80
> >> >> >> [  559.513429] FS:  00007f73ce1a6980(0000) GS:ffff880127c00000(0000)
> >> >> >> knlGS:0000000000000000
> >> >> >> [  559.519763] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >> >> >> [  559.526047] CR2: 0000000000000028 CR3: 000000011dcc0000 CR4: 00000000000007f0
> >> >> >> [  559.532331] Stack:
> >> >> >> [  559.538475]  ffff8801219a1778 ffffffff81085065 ffff8801219a1778
> >> >> >> ffff880121efa190
> >> >> >> [  559.544779]  ffff8801219a17e8 ffffffff8166af62 ffff880121ef9e80
> >> >> >> ffff8801219a1fd8
> >> >> >> [  559.551125]  ffff8801219a1fd8 ffff8801219a1fd8 ffff8801219a17d8
> >> >> >> ffff880121ef9e80
> >> >> >> [  559.557344] Call Trace:
> >> >> >> [  559.563534]  [<ffffffff81085065>] wq_worker_sleeping+0x15/0xa0
> >> >> >> [  559.569761]  [<ffffffff8166af62>] __schedule+0x492/0x7a0
> >> >> >> [  559.575925]  [<ffffffff8166bc99>] schedule+0x29/0x70
> >> >> >> [  559.582047]  [<ffffffff8106bd12>] do_exit+0x6b2/0xa20
> >> >> >> [  559.588098]  [<ffffffff8166e0a2>] oops_end+0xa2/0xf0
> >> >> >> [  559.594098]  [<ffffffff81661fc7>] no_context+0x253/0x27e
> >> >> >> [  559.600051]  [<ffffffff81318e8a>] ? delay_tsc+0x4a/0x80
> >> >> >> [  559.605971]  [<ffffffff816621b2>] __bad_area_nosemaphore+0x1c0/0x1df
> >> >> >> [  559.611958]  [<ffffffff816621e4>] bad_area_nosemaphore+0x13/0x15
> >> >> >> [  559.617885]  [<ffffffff81670f06>] __do_page_fault+0x3a6/0x4f0
> >> >> >> [  559.623767]  [<ffffffff8131e460>] ? bsearch+0x60/0x90
> >> >> >> [  559.629658]  [<ffffffff810cb2e0>] ? mod_find_symname+0x80/0x80
> >> >> >> [  559.635542]  [<ffffffff810cb469>] ? find_symbol_in_section+0x49/0x120
> >> >> >> [  559.641411]  [<ffffffff810cb420>] ? section_objs+0x60/0x60
> >> >> >> [  559.647307]  [<ffffffff810cbc16>] ? each_symbol_section.part.6+0x186/0x1e0
> >> >> >> [  559.653186]  [<ffffffff8167105e>] do_page_fault+0xe/0x10
> >> >> >> [  559.659062]  [<ffffffff8166d4d8>] page_fault+0x28/0x30
> >> >> >> [  559.664950]  [<ffffffffa04fac87>] ? tda829x_attach+0x47/0xba0 [tda8290]
> >> >> >> [  559.670858]  [<ffffffffa04facae>] ? tda829x_attach+0x6e/0xba0 [tda8290]
> >> >> >> [  559.676742]  [<ffffffffa04fac87>] ? tda829x_attach+0x47/0xba0 [tda8290]
> >> >> >> [  559.682581]  [<ffffffff810cc08d>] ? find_symbol+0x3d/0xb0
> >> >> >> [  559.688381]  [<ffffffffa04f3605>] set_type+0x325/0x9f0 [tuner]
> >> >> >> [  559.694200]  [<ffffffffa04c95ca>] ? cx18_i2c_register+0x15a/0x210 [cx18]
> >> >> >> [  559.700050]  [<ffffffffa04f3d6f>] tuner_s_type_addr+0x9f/0x140 [tuner]
> >> >> >> [  559.705866]  [<ffffffffa04c8722>] cx18_probe+0xda2/0x1560 [cx18]
> >> >> >> [  559.711697]  [<ffffffff8133d4ab>] local_pci_probe+0x4b/0x80
> >> >> >> [  559.717304]  [<ffffffff81080da8>] work_for_cpu_fn+0x18/0x30
> >> >> >> [  559.722660]  [<ffffffff8108391a>] process_one_work+0x17a/0x400
> >> >> >> [  559.727981]  [<ffffffff81083bcc>] process_scheduled_works+0x2c/0x40
> >> >> >> [  559.733268]  [<ffffffff81084ed2>] worker_thread+0x262/0x370
> >> >> >> [  559.738544]  [<ffffffff81084c70>] ? manage_workers.isra.21+0x2b0/0x2b0
> >> >> >> [  559.743828]  [<ffffffff8108b3e0>] kthread+0xc0/0xd0
> >> >> >> [  559.749053]  [<ffffffff81010000>] ? perf_trace_xen_mc_callback+0xe0/0xe0
> >> >> >> [  559.754273]  [<ffffffff8108b320>] ? kthread_create_on_node+0x120/0x120
> >> >> >> [  559.759536]  [<ffffffff8167576c>] ret_from_fork+0x7c/0xb0
> >> >> >> [  559.764568]  [<ffffffff8108b320>] ? kthread_create_on_node+0x120/0x120
> >> >> >> [  559.769386] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01
> >> >> >> c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 b8 02 00 00
> >> >> >> 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66
> >> >> >> 66 90
> >> >> >> [  559.779908] RIP  [<ffffffff8108b6c0>] kthread_data+0x10/0x20
> >> >> >> [  559.784720]  RSP <ffff8801219a1758>
> >> >> >> [  559.789434] CR2: ffffffffffffffd8
> >> >> >> [  559.794086] ---[ end trace d9c77bf63cfd8778 ]---
> >> >> >> [  559.794094] Fixing recursive fault but reboot is needed!
> >> >> >>
> >> >> >> Please advise.
> >> >> >>
> >> >> >> Scott
> >> >> >>
> >> >> >> _______________________________________________
> >> >> >> ivtv-users mailing list
> >> >> >> ivtv-users@ivtvdriver.org
> >> >> >> http://ivtvdriver.org/mailman/listinfo/ivtv-users
> >> >> >


