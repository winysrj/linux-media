Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4K1SgY3013461
	for <video4linux-list@redhat.com>; Mon, 19 May 2008 21:28:43 -0400
Received: from exprod8og107.obsmtp.com (exprod8og107.obsmtp.com [64.18.3.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4K1SU6I029857
	for <video4linux-list@redhat.com>; Mon, 19 May 2008 21:28:31 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Date: Mon, 19 May 2008 18:11:09 -0700
Message-ID: <A0E1B902C85838448AEA276170BCB5A509742CF1@NEVAEH.startrac.com>
From: "Dan Taylor" <dtaylor@startrac.com>
To: <video4linux-list@redhat.com>
Content-Transfer-Encoding: 8bit
Subject: memory leak with CX88 ALSA audio
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I have been using MPlayer-1.0rc2, with the recommended patches through
February 2008.

I am running Ubuntu 8.04, and have also built and tested a custom kernel
with the drivers/media components from 2.6.26-rc2.

I have tried this with two different cards, a pcHDTV-5500 (cx88) and an
AverMEDIA A16D (saa7134), and get the symptom only with the cx88.  If I
use the ALSA PCI streaming audio and memory leaks badly enough to run
the system out of free memory within a few hours.  This does NOT happen
if I use the analog audio out of the '5500, and my pcHDTV-3000 does not
(yet) have the PCI audio output.

Here's the config line for the '5500:

tv=driver=v4l2:chanlist=us-cable:norm=NTSC-M:alsa=1:adevice=hw.1,0:immed
iatemode=0:audiorate=48000:forceaudio=1:outfmt=yuy2

When started mplayer uses about 2.1% of 1 GiByte system memory (reported
by "top"); 20 minutes later it is 10.7 and continues to rise.

I don't mind trying to find the problem myself, but I need some idea
where to start.  I did notice a suspicious bit of code in cx88-alsa.c,
but changing it doesn't seem to help.

from cx88-alsa.c: if both AUD_INT_DN_SYNC and AUD_INT_DN_RISCI1 are
asserted, as my log shows, then AUD_INT_DN_RISCI1 is not serviced due to
the "return" marked "???" in the AUD_INT_DN_SYNC case.

static void cx8801_aud_irq(snd_cx88_card_t *chip)
{
	struct cx88_core *core = chip->core;
	u32 status, mask;

	status = cx_read(MO_AUD_INTSTAT);
	mask   = cx_read(MO_AUD_INTMSK);
	if (0 == (status & mask))
		return;
	cx_write(MO_AUD_INTSTAT, status);
	if (debug > 1  ||  (status & mask & ~0xff))
		cx88_print_irqbits(core->name, "irq aud",
				   cx88_aud_irqs,
ARRAY_SIZE(cx88_aud_irqs),
				   status, mask);
	/* risc op code error */
	if (status & AUD_INT_OPC_ERR) {
		printk(KERN_WARNING "%s/1: Audio risc op code
error\n",core->name);
		cx_clear(MO_AUD_DMACNTRL, 0x11);
		cx88_sram_channel_dump(core,
&cx88_sram_channels[SRAM_CH25]);
	}
	if (status & AUD_INT_DN_SYNC) {
#if 0
		timestamp();
#endif
		dprintk(1, "Downstream sync error\n");
		cx_write(MO_AUDD_GPCNTRL, GP_COUNT_CONTROL_RESET);
		return; /* ??? */
	}
	/* risc1 downstream */
	if (status & AUD_INT_DN_RISCI1) {
#if 0
		timestamp();
#endif
		atomic_set(&chip->count, cx_read(MO_AUDD_GPCNT));
		snd_pcm_period_elapsed(chip->substream);
	}
	/* FIXME: Any other status should deserve a special handling? */
}

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
