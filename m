Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:47006 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbZKKBB1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 20:01:27 -0500
Subject: Re: Hauppauge HVR-1600 cx18 loading problem
From: Andy Walls <awalls@radix.net>
To: John Nuszkowski <john.nuszkowski@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <ddfe20800911100913l2ebe777dya3ef47fc944e6897@mail.gmail.com>
References: <ddfe20800911100913l2ebe777dya3ef47fc944e6897@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 20:03:43 -0500
Message-Id: <1257901423.4040.53.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-11-10 at 12:13 -0500, John Nuszkowski wrote:
> My new Hauppauge HVR-1600 does not load the firmware.  The driver was
> built using the source from over the weekend.  I am using mythbuntu.
> 
> Below is a "modprobe cx18 debug=511" command
> 
> Any help would greatly be appreciated.
> 
> [43594.063182] cx18:  Start initialization, version 1.2.0
> [43594.063306] cx18-0: Initializing card 0
> [43594.063312] cx18-0: Autodetected Hauppauge card
> [43594.063447] cx18-0:  info: base addr: 0xdc000000
> [43594.063450] cx18-0:  info: Enabling pci device
> [43594.063478] cx18 0000:00:0c.0: PCI INT A -> Link[LNKA] -> GSI 10
> (level, low) -> IRQ 10
> [43594.063493] cx18-0:  info: cx23418 (rev 0) at 00:0c.0, irq: 10,
> latency: 64, memory: 0xdc000000
> [43594.063498] cx18-0:  info: attempting ioremap at 0xdc000000 len 0x04000000
> [43594.065656] cx18-0: cx23418 revision 01010000 (B)
> [43594.246946] cx18-0:  info: GPIO initial dir: 0000cffe/0000ffff out:
> 00003001/00000000
> [43594.246970] cx18-0:  info: activating i2c...
> [43594.246973] cx18-0:  i2c: i2c init
> [43594.362969] tveeprom 5-0050: Hauppauge model 74041, rev C6B2, serial# 6380357
> [43594.362976] tveeprom 5-0050: MAC address is 00-0D-FE-61-5B-45
> [43594.362981] tveeprom 5-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
> [43594.362987] tveeprom 5-0050: TV standards NTSC(M) (eeprom 0x08)
> [43594.362991] tveeprom 5-0050: audio processor is CX23418 (idx 38)
> [43594.362995] tveeprom 5-0050: decoder processor is CX23418 (idx 31)
> [43594.363000] tveeprom 5-0050: has no radio, has IR receiver, has IR
> transmitter
> [43594.363004] cx18-0: Autodetected Hauppauge HVR-1600
> [43594.363008] cx18-0:  info: NTSC tuner detected
> [43594.363011] cx18-0: Simultaneous Digital and Analog TV capture supported
> [43594.542552] IRQ 10/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
> [43594.551681] tuner 6-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
> [43594.554867] cs5345 5-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
> [43594.557430] tuner-simple 6-0061: creating new instance
> [43594.557436] tuner-simple 6-0061: type set to 50 (TCL 2002N)
> [43594.558186] cx18-0:  info: Allocate encoder MPEG stream: 64 x 32768
> buffers (2048kB total)
> [43594.558268] cx18-0:  info: Allocate TS stream: 32 x 32768 buffers
> (1024kB total)
> [43594.558310] cx18-0:  info: Allocate encoder YUV stream: 16 x 131072
> buffers (2048kB total)
> [43594.558351] cx18-0:  info: Allocate encoder VBI stream: 20 x 51984
> buffers (1015kB total)
> [43594.558389] cx18-0:  info: Allocate encoder PCM audio stream: 256 x
> 4096 buffers (1024kB total)
> [43594.558570] cx18-0:  info: Allocate encoder IDX stream: 32 x 32768
> buffers (1024kB total)
> [43594.558732] cx18-0: Registered device video1 for encoder MPEG (64 x 32 kB)
> [43594.558738] DVB: registering new adapter (cx18)
> [43594.594104] cx18 0000:00:0c.0: firmware: requesting v4l-cx23418-cpu.fw
> [43594.607124] cx18-0: Mismatch at offset 0

OK.  That's bad.  From messages previous to this, we can obviously
access CX23418 registers.  This "Mismatch at offset 0" message indicates
that writes or reads to the memory chip on the HVR-1600 via the PCI bus
and the CX23418 are failing.

Possible causes are:

1. Repeated PCI bus errors when trying to write or write to the CX23418
memory.

2. A new memory chip is is use on the HVR-1600 and the DRR memory
configuration parameters in the HVR-1600 entry in cx18-cards.c are
wrong.

3. Writes to CX23418 registers to configure the DDR memory parameters
failed.

4. Some other device driver or device DMA engine is errantly writing
into CX23418 memory space.


Some things you can you do:

1. Pull *all* your PCI cards out of your machine, blow the dust out of
the PCI slots, reseat all the cards and try again.  This should somewhat
mitigate PCI signal problems due to dust and oxidation.


2. In the file 

	cx18-driver.h

change the value of 

	#define CX18_MAX_MMIO_WR_RETRIES 10

up from 10 to 20 (or whatever) to increase the number of retries when
writing to the CX23418 over the PCI bus.  Recompile and install the cx18
driver and test again.


3. If you still have /dev/video* device nodes after modprobe, even
though the firmware load failed; compile the v4l-dbg in the v4l-dvb tree
and run these commands as root:

# v4l2-dbg -d /dev/video1 -S
host0: cx23418    revision 0x01010000
host1: cx23418_843 revision 0x00008430
i2c 0x4c: cs5345     revision 0x00000000

# v4l2-dbg -d /dev/video1 -c host0 --list-registers=min=0x2c80000,max=0x2c80057
ioctl: VIDIOC_DBG_G_REGISTER

                00       04       08       0C       10       14       18       1C
02c80000: 00000001 00000003 0000030c 44220e82 00000008 00000000 00000000 00000010 
02c80020: 00000000 00000003 00000000 00df1154 000bdef6 00000007 00000000 00000000 
02c80040: 00000000 00000000 00000000 00000000 00000005 00000000 

These are the registers that hold the DRR ram configuration.  These are
the values for my HVR-1600.

Also

# v4l2-dbg -d /dev/video0 -c host0 --list-registers=min=0x0000000,max=0x000005f
ioctl: VIDIOC_DBG_G_REGISTER

                00       04       08       0C       10       14       18       1C
00000000: e59ff018 e59ff018 e59ff018 e59ff018 e59ff018 e1a00000 e59ff014 e59ff014 
00000020: 000173a4 00000040 00000044 00000048 0000004c 00011984 00000050 00020680 
00000040: eafffffe eafffffe eafffffe eafffffe eafffffe e92d4070 e1a04000 e1a00001 

These are the first few words of the DDR ram memory on the HVR-1600
connected to the CX23418 with the CPU firmware image loaded.

You can test trying to wrtie to the CX23418's memory with a command
sequence like this:

# v4l2-dbg -d /dev/video0 -c host0 -g 0x14 
ioctl: VIDIOC_DBG_G_REGISTER
Register 0x00000014 = e1a00000h (3785359360d  11100001 10100000 00000000 00000000b)
# v4l2-dbg -d /dev/video0 -c host0 -s 0x14 0xe1a00001
Register 0x00000014 set to 0xe1a00001
# v4l2-dbg -d /dev/video0 -c host0 -g 0x14 
ioctl: VIDIOC_DBG_G_REGISTER
Register 0x00000014 = e1a00001h (3785359361d  11100001 10100000 00000000 00000001b)

Mucking with the memory word at 0x14 should be safe even when the
CX23418 is in operation. 


4. Please provide the output of 

# lspci -nnvv
# cat /proc/iomem
# grep Vmalloc /proc/mem


> [43594.607137] cx18-0: Retry loading firmware
> [43594.608161] cx18 0000:00:0c.0: firmware: requesting v4l-cx23418-cpu.fw
> [43594.649832] cx18-0: Mismatch at offset 0
> [43594.649848] cx18-0: Failed to initialize on minor 3
> [43594.682215] cx18-0: Failed to initialize on minor 3

I cannot see in the code how you can legitimately get this message on a
simple open() call unless you are out of memory or something about the
struct cx18 instance structure is corrupt/wrong.  You should have at
least seen messages from these debug statements:  
	
	CX18_DEBUG_FILE("open %s\n", s->name);
	CX18_DEBUG_WARN("nomem on v4l2 open\n");

Maybe I'm missing something or perhaps something went
to /var/log/messages but not to dmesg (or vice-versa)?

Regards,
Andy

> [43594.691048] MXL5005S: Attached at address 0x63
> [43594.691063] DVB: registering adapter 0 frontend 0 (Samsung S5H1409
> QAM/8VSB Frontend)...
> [43594.708643] cx18-0: DVB Frontend registered
> [43594.708651] cx18-0: Registered DVB adapter0 for TS (32 x 32 kB)
> [43594.708711] cx18-0: Registered device video33 for encoder YUV (16 x 128 kB)
> [43594.708749] cx18-0: Registered device vbi1 for encoder VBI (20 x 51984 bytes)
> [43594.708785] cx18-0: Registered device video25 for encoder PCM audio
> (256 x 4 kB)
> [43594.708790] cx18-0: Initialized card: Hauppauge HVR-1600
> [43594.708829] cx18:  End initialization
> [43594.716719] cx18-0: Failed to initialize on minor 4
> [43594.723793] cx18-0: Failed to initialize on minor 5
> [43594.726277] cx18-0: Failed to initialize on minor 6
> [43594.736339] cx18-0: Failed to initialize on minor 6
> [43594.757957] cx18-0: Failed to initialize on minor 4
> [43594.784206] cx18-0: Failed to initialize on minor 5
> 
> 
> Thanks,
> 
> John
> -

