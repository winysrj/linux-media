Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34664 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0LQDbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 22:31:39 -0500
Received: by wyb28 with SMTP id 28so232143wyb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 19:31:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012161429.32658.me@boris64.net>
References: <201012161429.32658.me@boris64.net>
Date: Fri, 17 Dec 2010 05:31:37 +0200
Message-ID: <AANLkTi=X-xn+iSmp5OLGP-FK8dqvyRgEcX-HjTQF5dHn@mail.gmail.com>
Subject: Re: TeVii S470 dvb-s2 issues
From: Anca Emanuel <anca.emanuel@gmail.com>
To: me@boris64.net
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, Dec 16, 2010 at 3:29 PM, Boris Cuber <me@boris64.net> wrote:
> Hello linux-media people!
>
> I have to problems with my dvb card ("TeVii S470"). I already
> filed 2 bug reports some time ago, but no one seems to have
> noticed/read them, so i'm trying it here now.
>
> 1) "TeVii S470 dvbs-2 card (cx23885) is not usable after pm-suspend/resume"
> https://bugzilla.kernel.org/show_bug.cgi?id=16467
>
> 2) "cx23885: ds3000_writereg: writereg error on >=kernel-2.6.36-rc with TeVii"
> S470 dvb-s2 card
> -> https://bugzilla.kernel.org/show_bug.cgi?id=18832
>
> Are these issues known? If so, are there any fixes yet? When will these
> get into mainline? Could somebody point me into the right direction.
> Can i help somehow to debug these problems?
> Where is the correct place to report bugs about dvb/v4l kernel stuff?
>
> Thank you in advance.
>
> Regards,
>        Boris Cuber
>
> --
> http://boris64.net 20xx ;)
>

paste from dmesg you sent:
[    4.581930] IR NEC protocol handler initialized
[    4.623358] cx23885 driver version 0.0.2 loaded
[    4.623391] cx23885 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.623802] CORE cx23885[0]: subsystem: d470:9022, board: TeVii
S470 [card=15,autodetected]
[    4.653935] IR RC5(x) protocol handler initialized
[    4.751392] cx23885_dvb_register() allocating 1 frontend(s)
[    4.751395] cx23885[0]: cx23885 based dvb card
[    4.828732] IR RC6 protocol handler initialized
[    4.864909] DS3000 chip version: 0.192 attached.
[    4.864912] DVB: registering new adapter (cx23885[0])
[    4.864915] DVB: registering adapter 0 frontend 0 (Montage
Technology DS3000/TS2020)...
[    4.875357] IR JVC protocol handler initialized
[    4.892265] TeVii S470 MAC= 00:18:bd:5b:2d:bc
[    4.892270] cx23885_dev_checkrevision() Hardware revision = 0xb0
[    4.892276] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfea00000
[    4.892282] cx23885 0000:04:00.0: setting latency timer to 64
[    4.892353] cx23885 0000:04:00.0: irq 42 for MSI/MSI-X
[    5.108173] IR Sony protocol handler initialized
[    5.145513] lirc_dev: IR Remote Control driver registered, major 251
[    5.155400] IR LIRC bridge handler initialized
[    5.584627] vboxdrv: Found 4 processor cores.
[    5.584882] VBoxDrv: dbg - g_abExecMemory=ffffffffa0093480
[    5.584929] vboxdrv: fAsync=0 offMin=0x40b offMax=0x1c28
[    5.584985] vboxdrv: TSC mode is 'synchronous', kernel timer mode
is 'normal'.
[    5.584987] vboxdrv: Successfully loaded version 3.2.12 (interface
0x00140001).
[    6.259015] EXT4-fs (sdc1): mounted filesystem without journal. Opts: (null)
[   14.791291] EXT4-fs (sdc1): mounted filesystem without journal. Opts: (null)
[   22.876565] EXT4-fs (sda5): re-mounted. Opts: (null)
[   23.324249] EXT4-fs (dm-1): mounted filesystem with ordered data
mode. Opts: (null)
[   23.436401] EXT4-fs (dm-2): mounted filesystem with ordered data
mode. Opts: (null)
[   25.240374] Adding 4000148k swap on /dev/mapper/crypto_swap20xx.
Priority:-1 extents:1 across:4000148k
[   25.519058] atl1 0000:02:00.0: irq 43 for MSI/MSI-X
[   25.519163] atl1 0000:02:00.0: eth0 link is up 100 Mbps full duplex
[   43.110030] start_kdeinit (1551): /proc/1551/oom_adj is deprecated,
please use /proc/1551/oom_score_adj instead.
[  129.613967] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  129.626975] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  136.462969] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  136.475975] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)

And dmesg after suspend/resume with cx23885.debug=1
[  239.053885] ds3000_firmware_ondemand: Waiting for firmware upload
(dvb-fe-ds3000.fw)...
[  239.053890] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[  240.901976] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  240.914973] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  248.242966] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  248.255975] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  256.403969] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  256.416980] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  263.563968] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  263.576977] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  278.125971] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  278.138974] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  278.440704] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x12)
[  305.437940] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  305.451975] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  305.758569] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x12)
[  881.880964] cx23885 driver version 0.0.2 loaded
[  881.880997] cx23885 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  881.881218] cx23885[0]/0: cx23885_dev_setup() Memory configured for
PCIe bridge type 885
[  881.881220] cx23885[0]/0: cx23885_init_tsport(portno=1)
[  881.881892] CORE cx23885[0]: subsystem: d470:9022, board: TeVii
S470 [card=15,autodetected]
[  881.881893] cx23885[0]/0: cx23885_pci_quirks()
[  881.881897] cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0
tuner_addr = 0x0
[  881.881899] cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0
radio_addr = 0x0
[  881.881900] cx23885[0]/0: cx23885_reset()
[  881.981923] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [VID A]
[  881.981935] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch2]
[  881.981938] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS1 B]
[  881.981951] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch4]
[  881.981953] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch5]
[  881.981955] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS2 C]
[  881.981968] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch7]
[  881.981970] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch8]
[  881.981973] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch9]
[  882.009919] cx23885_dvb_register() allocating 1 frontend(s)
[  882.009923] cx23885[0]: cx23885 based dvb card
[  882.013133] DS3000 chip version: 0.192 attached.
[  882.013136] DVB: registering new adapter (cx23885[0])
[  882.013139] DVB: registering adapter 0 frontend 0 (Montage
Technology DS3000/TS2020)...
[  882.045231] TeVii S470 MAC= 00:18:bd:5b:2d:bc
[  882.045237] cx23885_dev_checkrevision() Hardware revision = 0xb0
[  882.045245] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfea00000
[  882.045253] cx23885 0000:04:00.0: setting latency timer to 64
[  882.045328] cx23885 0000:04:00.0: irq 42 for MSI/MSI-X
[  919.789976] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  919.802979] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  920.167974] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  920.180973] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  920.544969] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  920.557973] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  920.926968] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  920.939974] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  921.304971] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  921.317973] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  921.681959] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  921.694965] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  922.081966] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  922.094961] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  922.477970] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  922.491982] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  922.856980] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  922.869988] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  923.236967] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  923.249978] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  923.615969] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  923.628969] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  923.992968] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  924.005978] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  924.369971] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  924.382969] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  924.746968] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  924.759971] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  925.123967] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  925.136973] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  925.500967] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  925.513970] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  925.877969] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  925.890977] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  926.307970] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  926.320975] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  927.684969] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  927.697985] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  929.062967] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  929.075971] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  933.283967] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  933.297017] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x11)
[  933.594630] ds3000_writereg: writereg error(err == -6, reg == 0x03,
value == 0x12)
[  933.598373] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76eee00
[  933.598396] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76efa00
[  933.598410] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76ef800
[  933.598423] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76efe00
[  933.598436] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76efc00
[  933.598448] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76ee600
[  933.598462] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76ee400
[  933.598480] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76ef000
[  933.598493] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76ef400
[  933.598507] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76eec00
[  933.598521] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76eea00
[  933.598534] cx23885[0]/0: cx23885_buf_prepare: ffff8801d76ef200
[  933.598548] cx23885[0]/0: cx23885_buf_prepare: ffff88020ea08a00
[  933.598562] cx23885[0]/0: cx23885_buf_prepare: ffff88020ea09a00
[  933.598577] cx23885[0]/0: cx23885_buf_prepare: ffff88020ea09600
[  933.598590] cx23885[0]/0: cx23885_buf_prepare: ffff88020ea09000
[  933.598605] cx23885[0]/0: cx23885_buf_prepare: ffff88020ea08000
[  933.598619] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af6800
[  933.598633] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af6a00
[  933.598648] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af7c00
[  933.598665] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af7200
[  933.598683] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af6600
[  933.598701] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af7000
[  933.598719] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af6000
[  933.598735] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af6200
[  933.598755] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af7a00
[  933.598773] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af6c00
[  933.598791] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af7400
[  933.598809] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af7600
[  933.598831] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af6400
[  933.598850] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af7800
[  933.598868] cx23885[0]/0: cx23885_buf_prepare: ffff8801d7af7e00
[  933.598886] cx23885[0]/0: queue is empty - first active
[  933.598889] cx23885[0]/0: cx23885_start_dma() w: 752, h: 32, f: 2
[  933.598893] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS1 B]
[  933.599003] cx23885[0]/0: cx23885_start_dma() enabling TS int's and DMA
[  933.599003] cx23885[0]/0: [ffff8801d76eee00/0] cx23885_buf_queue -
first active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76efa00/1] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76ef800/2] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76efe00/3] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76efc00/4] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76ee600/5] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76ee400/6] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76ef000/7] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76ef400/8] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76eec00/9] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76eea00/10] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d76ef200/11] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff88020ea08a00/12] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff88020ea09a00/13] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff88020ea09600/14] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff88020ea09000/15] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff88020ea08000/16] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af6800/17] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af6a00/18] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af7c00/19] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af7200/20] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af6600/21] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af7000/22] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af6000/23] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af6200/24] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af7a00/25] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af6c00/26] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af7400/27] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af7600/28] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af6400/29] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af7800/30] cx23885_buf_queue -
append to active
[  933.599003] cx23885[0]/0: queue is not empty - append to active
[  933.599003] cx23885[0]/0: [ffff8801d7af7e00/31] cx23885_buf_queue -
append to active
[  934.600004] cx23885[0]/0: cx23885_timeout()
[  934.600007] cx23885[0]/0: cx23885_stop_dma()
[  934.600016] cx23885[0]/0: [ffff8801d76eee00/0] timeout - dma=0xcad59000
[  934.600019] cx23885[0]/0: [ffff8801d76efa00/1] timeout - dma=0xcae05000
[  934.600021] cx23885[0]/0: [ffff8801d76ef800/2] timeout - dma=0xcadfe000
[  934.600024] cx23885[0]/0: [ffff8801d76efe00/3] timeout - dma=0xcadf7000
[  934.600027] cx23885[0]/0: [ffff8801d76efc00/4] timeout - dma=0xcadf0000
[  934.600029] cx23885[0]/0: [ffff8801d76ee600/5] timeout - dma=0xcac51000
[  934.600032] cx23885[0]/0: [ffff8801d76ee400/6] timeout - dma=0xcae8a000
[  934.600035] cx23885[0]/0: [ffff8801d76ef000/7] timeout - dma=0xcac6b000
[  934.600037] cx23885[0]/0: [ffff8801d76ef400/8] timeout - dma=0xcac8c000
[  934.600040] cx23885[0]/0: [ffff8801d76eec00/9] timeout - dma=0xcad6d000
[  934.600043] cx23885[0]/0: [ffff8801d76eea00/10] timeout - dma=0xcacce000
[  934.600045] cx23885[0]/0: [ffff8801d76ef200/11] timeout - dma=0xcac2f000
[  934.600048] cx23885[0]/0: [ffff88020ea08a00/12] timeout - dma=0xcac28000
[  934.600051] cx23885[0]/0: [ffff88020ea09a00/13] timeout - dma=0xcac31000
[  934.600054] cx23885[0]/0: [ffff88020ea09600/14] timeout - dma=0xcac26000
[  934.600056] cx23885[0]/0: [ffff88020ea09000/15] timeout - dma=0xcacc3000
[  934.600059] cx23885[0]/0: [ffff88020ea08000/16] timeout - dma=0xcac60000
[  934.600062] cx23885[0]/0: [ffff8801d7af6800/17] timeout - dma=0xcacad000
[  934.600064] cx23885[0]/0: [ffff8801d7af6a00/18] timeout - dma=0xcacbe000
[  934.600067] cx23885[0]/0: [ffff8801d7af7c00/19] timeout - dma=0xcaca3000
[  934.600070] cx23885[0]/0: [ffff8801d7af7200/20] timeout - dma=0xcad50000
[  934.600072] cx23885[0]/0: [ffff8801d7af6600/21] timeout - dma=0xcac71000
[  934.600075] cx23885[0]/0: [ffff8801d7af7000/22] timeout - dma=0xcacdc000
[  934.600077] cx23885[0]/0: [ffff8801d7af6000/23] timeout - dma=0xcac23000
[  934.600080] cx23885[0]/0: [ffff8801d7af6200/24] timeout - dma=0xcacc4000
[  934.600083] cx23885[0]/0: [ffff8801d7af7a00/25] timeout - dma=0xcaca9000
[  934.600085] cx23885[0]/0: [ffff8801d7af6c00/26] timeout - dma=0xcacf0000
[  934.600088] cx23885[0]/0: [ffff8801d7af7400/27] timeout - dma=0xcac9f000
[  934.600091] cx23885[0]/0: [ffff8801d7af7600/28] timeout - dma=0xcae36000
[  934.600093] cx23885[0]/0: [ffff8801d7af6400/29] timeout - dma=0xcae3d000
[  934.600096] cx23885[0]/0: [ffff8801d7af7800/30] timeout - dma=0xcad44000
[  934.600099] cx23885[0]/0: [ffff8801d7af7e00/31] timeout - dma=0xcad4b000
[  934.600100] cx23885[0]/0: restarting queue
