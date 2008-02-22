Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1JSezX-00007i-8w
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 21:59:35 +0100
Received: by ti-out-0910.google.com with SMTP id y6so429809tia.13
	for <linux-dvb@linuxtv.org>; Fri, 22 Feb 2008 12:59:25 -0800 (PST)
Message-ID: <a3ef07920802221259u3072de1fnf5acbb31587388fa@mail.gmail.com>
Date: Fri, 22 Feb 2008 12:59:23 -0800
From: "VDR User" <user.vdr@gmail.com>
To: "mailing list: linux-dvb" <linux-dvb@linuxtv.org>
In-Reply-To: <a3ef07920801161550g582e1f90o18cf3911413b39e3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <a3ef07920801161550g582e1f90o18cf3911413b39e3@mail.gmail.com>
Subject: Re: [linux-dvb] DST (vp-1020a) driver broken w/explanation
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

Does anyone have any intention of ever fixing this or will we have to
patch the fix in forever?

On Wed, Jan 16, 2008 at 3:50 PM, VDR User <user.vdr@gmail.com> wrote:
> Greetings..  I have tried a DST VisionPlus 1020a dvb-s card today for
>  the first time with a fresh copy of v4l (from today Jan. 16th).  Upon
>  loading the drivers I got the following message in dmesg:
>
>  Linux video capture interface: v2.00
>  bttv: driver version 0.9.17 loaded
>  bttv: using 8 buffers with 2080k (520 pages) each for capture
>  bttv: Bt8xx card found (0).
>  bttv0: Bt878 (rev 17) at 0000:01:09.0, irq: 10, latency: 64, mmio: 0xdcfff000
>  bttv0: using: Twinhan DST + clones [card=113,insmod option]
>  bttv0: gpio: en=00000000, out=00000000 in=00fefffe [init]
>  bttv0: tuner absent
>  bttv0: add subdevice "dvb0"
>  bt878: AUDIO driver version 0.0.0 loaded
>  bt878: Bt878 AUDIO function found (0).
>  ACPI: PCI Interrupt 0000:01:09.1[A] -> Link [LNKB] -> GSI 10 (level,
>  low) -> IRQ 10
>  bt878_probe: card id=[0x0], Unknown card.
>  Exiting..
>  ACPI: PCI interrupt for device 0000:01:09.1 disabled
>  bt878: probe of 0000:01:09.1 failed with error -22
>  dvb_bt8xx: unable to determine DMA core of card 0,
>  dvb_bt8xx: if you have the ALSA bt87x audio driver installed, try removing it.
>  dvb-bt8xx: probe of dvb0 failed with error -14
>
>  The card was known to be working the last time it was in a box so I
>  suspected something other then it meeting death by sitting in an
>  anti-static bag.  After some searching I found a others experiencing
>  the same problem and one of them posted the following:
>
>  "The root cause of the problem seems to be that the DST card does not
>  have PCI subsystem information configured: the bytes are just set to
>  zero in the PCI configuration space. The driver
>  linux/drivers/media/dvb/bt8xx/bt878.c checks for a set of subsystem
>  IDs and only proceeds with the configuration if it finds one from the
>  list."
>
>  I then found the following patch that had been applied to the driver:
>  ==========
>  http://linuxtv.org/hg/v4l-dvb/rev/97edfa0f7c94
>
>  changeset 5513: 97edfa0f7c94
>  parent 5061: d5f262a7b702
>  child 6079: 358a897c1c19
>  manifest: 97edfa0f7c94
>
>  --- a/linux/drivers/media/dvb/bt8xx/bt878.c     Sun Jan 07 20:12:22 2007 -0500
>  +++ b/linux/drivers/media/dvb/bt8xx/bt878.c     Sat Apr 14 10:24:15 2007 -0300
>  @@ -397,9 +397,7 @@ static struct cards card_list[] __devini
>         { 0xdb1118ac, BTTV_BOARD_DVICO_DVBT_LITE,               "Ultraview DVB-T Lite" },
>         { 0xd50018ac, BTTV_BOARD_DVICO_FUSIONHDTV_5_LITE,       "DViCO FusionHDTV 5 Lite" },
>         { 0x20007063, BTTV_BOARD_PC_HDTV,                       "pcHDTV HD-2000 TV" },
>  -       { 0x00261822, BTTV_BOARD_TWINHAN_DST,                   "DNTV Live! Mini" },
>  -
>  -       { 0, -1, NULL }
>  +       { 0x00261822, BTTV_BOARD_TWINHAN_DST,                   "DNTV Live! Mini" }
>   };
>
>
>  ==========
>
>  After re-adding the { 0, -1, NULL }, re-compiling/installing/loading
>  the drivers, I now have a confirmed working card and get the following
>  in dmesg:
>
>  Linux video capture interface: v2.00
>  bttv: driver version 0.9.17 loaded
>  bttv: using 8 buffers with 2080k (520 pages) each for capture
>  bttv: Bt8xx card found (0).
>  ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
>  ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [LNKB] -> GSI 10 (level,
>  low) -> IRQ 10
>  bttv0: Bt878 (rev 17) at 0000:01:09.0, irq: 10, latency: 64, mmio: 0xdcfff000
>  bttv0: using: Twinhan DST + clones [card=113,insmod option]
>  bttv0: gpio: en=00000000, out=00000000 in=00fefffe [init]
>  bttv0: tuner absent
>  bttv0: add subdevice "dvb0"
>  bt878: AUDIO driver version 0.0.0 loaded
>  bt878: Bt878 AUDIO function found (0).
>  ACPI: PCI Interrupt 0000:01:09.1[A] -> Link [LNKB] -> GSI 10 (level,
>  low) -> IRQ 10
>  bt878_probe: card id=[0x0],[ <NULL> ] has DVB functions.
>  bt878(0): Bt878 (rev 17) at 01:09.1, irq: 10, latency: 64, memory: 0xdcffe000
>  DVB: registering new adapter (bttv0)
>  dst(0) dst_get_device_id: Recognise [DST-MOT]
>  DST type flags : 0x4 symdiv 0x8 firmware version = 1
>  dst(0) dst_get_mac: MAC Address=[00:00:00:00:00:00]
>  DVB: registering frontend 0 (DST DVB-S)...
>
>  I have double-checked just to be sure and have confirmed the card only
>  works with { 0, -1, NULL } included.  Was the patch actually tested
>  before it was accepted?  I almost threw the card out because of this
>  so I'm sure glad to discover the problem is in the driver!  Hopefully
>  it can be fixed before other think they have a dead card when they
>  don't.
>
>  Thanks.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
