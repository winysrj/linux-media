Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2INBAI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 21:00:08 -0400
Message-ID: <5052818B.7090708@redhat.com>
Date: Thu, 13 Sep 2012 21:59:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com> <201208161649.43284.hverkuil@xs4all.nl> <CALzAhNWT3eNUNwNsGG_w+Jbz=ErRxogvv+_3GcKy8xZ+R-uZ=A@mail.gmail.com> <201208162049.35773.hverkuil@xs4all.nl> <CALzAhNXZx1+048S_rVsWH3fMg8sJnawo3o+bS6ygD5KRpjYZ3g@mail.gmail.com> <20120913201958.266fee52@infradead.org> <50526AFE.20003@redhat.com>
In-Reply-To: <50526AFE.20003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Sep 2012 20:23:42 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em 13-09-2012 20:19, Mauro Carvalho Chehab escreveu:
> > Em Sat, 18 Aug 2012 11:48:52 -0400
> > Steven Toth <stoth@kernellabs.com> escreveu:
> > 
> >> Mauro, please read below, a new set of patches I'm submitting for merge.
> >>
> >> On Thu, Aug 16, 2012 at 2:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>> On Thu August 16 2012 19:39:51 Steven Toth wrote:
> >>>>>> So, I've ran v4l2-compliance and it pointed out a few things that I've
> >>>>>> fixed, but it also does a few things that (for some reason) I can't
> >>>>>> seem to catch. One particular test is on (iirc) s_fmt. It attempts to
> >>>>>> set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
> >>>>>> it actually receives 0x0. This feels more like a bug in the test.
> >>>>>> Either way, I have some if (std & ATSC) return -EINVAL, but it still
> >>>>>> appears to fail the test.
> >>>>
> >>>> Oddly enough. If I set tvnorms to something valid, then compliance
> >>>> passes but gstreamer
> >>>> fails to run, looks like some kind of confusion about either the
> >>>> current established
> >>>> norm, or a failure to establish a norm.
> >>>>
> >>>> For the time being I've set tvnorms to 0 (with a comment) and removed
> >>>> current_norm.
> >>>
> >>> Well, this needs to be sorted, because something is clearly amiss.
> >>
> >> Agreed. I just can't see what's wrong. I may need your advise /
> >> eyeballs on this. I'd be willing to provide logs that show gstreamer
> >> accessing the driver and exiting. It needs fixed, I've tried, I just
> >> can't see why gstreamer fails.
> >>
> >> On the main topic of merge.... As promised, I spent quite a bit of
> >> time this week reworking the code based on the feedback. I also
> >> flattened all of these patches into a single patchset and upgraded to
> >> the latest re-org tree.
> >>
> >> The source notes describe in a little more detail the major changes:
> >> http://git.kernellabs.com/?p=stoth/media_tree.git;a=commit;h=f295dd63e2f7027e327daad730eb86f2c17e3b2c
> >>
> >> Mauro, so, I hereby submit for your review/merge again, the updated
> >> patchset. *** Please comment. ***
> > 
> > I'll comment patch by patch. Let's hope the ML will get this email. Not sure,
> > as it tends to discard big emails like that.
> > 
> > This is the comment of patch 1/4.
> > 
> 
> Patch 2 is trivial. It is obviously OK.
> 
> Patch 3 also looked OK on my eyes.

Patch 4 will very likely be discarded by vger server, if everything is
added there. So, I'll drop the parts that weren't commented.

Anyway:

> Subject: [media] vc8x0: Adding support for the ViewCast O820E Capture Card.
> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> A dual channel 1920x1080p60 PCIe x4 capture card, two DVI
> inputs capable of capturing DVI/HDMI, Component, Svideo, Composite
> and some VGA resolutions.
...

> +#include "vc8x0.h"
> +
> +static unsigned int audio_debug;
> +module_param(audio_debug, int, 0644);
> +MODULE_PARM_DESC(audio_debug, "enable debug messages [audio]");
> +
> +static unsigned int audio_alsa_during_irq = 1;
> +module_param(audio_alsa_during_irq, int, 0644);
> +MODULE_PARM_DESC(audio_alsa_during_irq, "feed alsa during the irq handler, not via a dpc [audio]");
> +
> +#define dprintk(level, fmt, arg...)\
> +	do {\
> +		if (audio_debug >= level)\
> +			pr_err("%s/0: " fmt, \
> +				channel->dev->name, ## arg);\
> +	} while (0)
> +
> +#define MIXER_RCA_JACKS 1
> +
> +/* Repack 24 bit audio samples (in 32bit alignment)
> + * into 16bit samples within the same buffer, and
> + * return the new buffer length in bytes.
> + *
> + * Input Sample:
> + * LEFT         RIGHT
> + * 00 B0 B1 B2  00 B1 B1 B2
> +
> + * Output Sample:
> + * LEFT   RIGHT
> + * B1 B2  B1 B2
> + */
> +static int repack_24_to_16(u8 *buf, int len)
> +{
> +	int i;
> +	u8 *dst = buf;
> +	u8 *src = buf + 2;
> +
> +	/* For each 24 bit sample */
> +	for (i = 0; i < (len / 4); i++) {
> +		*(dst) = *(src);
> +		*(dst + 1) = *(src + 1);
> +		dst += 2;
> +		src += 4;
> +	}
> +
> +	return (len / 4) * 2;
> +}

Why is it needed? It would be better to let ALSA userspace to handle
it.

> +	dprintk(3,
> +		"%s() %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
> +		__func__, *(buf->cpu + 0), *(buf->cpu + 1), *(buf->cpu + 2),
> +		*(buf->cpu + 3), *(buf->cpu + 4), *(buf->cpu + 5),
> +		*(buf->cpu + 6), *(buf->cpu + 7), *(buf->cpu + 8),
> +		*(buf->cpu + 9), *(buf->cpu + 10), *(buf->cpu + 11),
> +		*(buf->cpu + 12), *(buf->cpu + 13), *(buf->cpu + 14),
> +		*(buf->cpu + 15)
> +	    );

FYI, there's now a new printk syntax to print buffer dumps like
that, where you pass the buffer and the length, and printk does the
rest.

> +	spin_unlock(&channel->dma_buffers_full_lock);
> +	spin_unlock_irqrestore(&channel->dma_buffers_dpc_lock, flags);
> +
> +	/* BAM! The interrupt handler is now free to move on */
> +	/* BAM! The interrupt handler is now free to move on */
> +	/* BAM! The interrupt handler is now free to move on */
> +	/* BAM! The interrupt handler is now free to move on */

Wow! the above 4 lines won the prize of the weirdest comment I ever seen ;)
Why you need to say the above 4 times? :)

Even saying it once seems overkill to me, as it just repeats what the
 spin_unlock() just said ;)

> +
> +	/* Now let's dequeue the full buffers */
> +	/* For each full buffer, send it to user space */
> +	spin_lock(&channel->dma_buffers_full_lock);

Huh? You just unlocked it... Also, it looks weird that you're using two spin
locks on the above code, and just one here. Using more than one spin lock
like that could cause dead locks.

Btw, this patch is too big! You should break it into some smaller
pieces (one patch per file, for example) making life easier for reviewers and
allowing people at the ML to see/comment the full code, as one of the requirements
is that, before sending a pull request, you should be sending the patches to
the ML.

In the specific case of the -alsa driver, it is mandatory to have it on a
separate patch, as it should be copied also to the alsa ML, to allow alsa
people to comment/review.

So, please split patch 4 into separate patches, doing the Kconfig/Makefile
integration at the end of your series.

> +	buf->used_len = 3840;
> +	buf->used_len = repack_24_to_16(buf->cpu, buf->used_len);

This repack thing looks weird on my eyes.

> +	spin_lock_irqsave(&channel->dma_buffers_busy_lock, flags);
> +
> +	/* Last, put the buffer on the DPC list for our deferred worker
> +	 * to process */
> +	spin_lock_irqsave(&channel->dma_buffers_dpc_lock, flags);

Again, double-locking.

> +static inline void handle_audio_data(struct vc8x0_dma_buffer *buf,
> +	int *period_elapsed)
> +{
> +	struct vc8x0_dma_channel *channel = buf->channel;
> +	struct vc8x0_audio_dev *chip = channel->audio_dev;
> +	struct snd_pcm_runtime *runtime = chip->capture_pcm_substream->runtime;
> +	int stride;
> +	int len, rdb, cpsafe[3];
> +	unsigned char *cp;
> +	unsigned int oldptr;
> +
> +	stride = runtime->frame_bits >> 3;
> +	if (stride == 0) {
> +		pr_err("%s() divbyzero BUG\n", __func__);
> +		stride = 4;
> +	}
> +
> +	len = buf->used_len / stride;

Hmm... that looks weird on my eyes, as other drivers don't have
such check. Why such logic is needed? Rounding it to 4 won't cause
buffer overflows? Maybe a BUG_ON would apply better here.

> +#if ENABLE_ALSA_MIXER

Please use CONFIG_foo instead, it the user may opt to have it or not.

> diff --git a/drivers/media/pci/vc8x0/vc8x0-buffer.c b/drivers/media/pci/vc8x0/vc8x0-buffer.c


> +DMA buffers per channel must be contigious, reside only in 32bit

typo: contiguous.

> +memory.
> +
> +The PCIe bridge (GN4124) supports up to 18 'fifos', essentially
> +discrete DMA channels. The GN4124 uses a DMA Sequencer architecture
> +to control which dma buffers are targets for which channel. The sequencer
> +is a list of program instructions that effictivel handle the data modement

typo: effective

> +
> +void vc8x0_buffer_analyze(u8 *buf, int len)
> +{
> +	int i;
> +	u32 data[256];
> +	memset(data, 0, sizeof(data));
> +
> +	for (i = 0; i < len; i++) {
> +		data[*(buf + i)]++;
> +	}
> +
> +	for (i = 0; i < 256; i++) {
> +		if (data[i]) {
> +			pr_err("%02x %x\n", i, data[i]);
> +		}
> +	}

use print_hex_dump() instead of the loop.

On a big driver, like that, it is hard to see how each module
interacts with the others. Yet, it seemed, on my eyes, that
vc8x0-buffer is doing something close to what vb2-contig is
already doing.

If you need to use contiguous buffer memories for DMA transfers,
I strongly suggest you to use vb2, as vb1 is known to have some
serious issues with contiguous memories.

> diff --git a/drivers/media/pci/vc8x0/vc8x0-channel.c b/drivers/media/pci/vc8x0/vc8x0-channel.c

Again, it is hard to understand what is there at *-channel, in the context
of the entire driver, but it seems part of a videobuf handling code.

> diff --git a/drivers/media/pci/vc8x0/vc8x0-core.c b/drivers/media/pci/vc8x0/vc8x0-core.c

> +
> +/* 1 = Basic device statistics
> + * 2 = PCIe register dump for entire device
> + * 4 = AD9985 register dump
> + * 8 = SIL9013 register dump
> + */
> +unsigned int vc8x0_thread_active = 1;
> +module_param(vc8x0_thread_active, int, 0644);
> +MODULE_PARM_DESC(vc8x0_thread_active, "should keep alive thread run");

Is it really needed? If so, I think you should better describe it as, the
above description doesn't mean anything for me... What Thread? What happens
if the thread doesn't run?

> +static int vc8x0_dev_setup(struct vc8x0_dev *dev)
> +{
> +	int i;
> +
> +	mutex_init(&dev->lock);
> +
> +	atomic_inc(&dev->refcount);
> +
> +	dev->nr = vc8x0_devcount++;
> +	sprintf(dev->name, "vc8x0[%d]", dev->nr);
> +
> +	/* board config */
> +	dev->board = UNSET;
> +	if (card[dev->nr] < vc8x0_bcount)
> +		dev->board = card[dev->nr];
> +	for (i = 0; UNSET == dev->board  &&  i < vc8x0_idcount; i++)
> +		if (dev->pci->subsystem_vendor == vc8x0_subids[i].subvendor &&
> +		    dev->pci->subsystem_device == vc8x0_subids[i].subdevice)
> +			dev->board = vc8x0_subids[i].card;
> +	if (UNSET == dev->board) {
> +		dev->board = VC8X0_BOARD_UNKNOWN;
> +		vc8x0_card_list(dev);
> +	}
> +
> +	/* The keepalive thread needs a mutex */
> +	mutex_init(&dev->kthread_lock);
> +
> +	/* Main Master 0 Bus incl. eeprom */
> +	mutex_init(&dev->i2c_bus.lock);
> +	dev->i2c_bus.nr = 0;
> +	dev->i2c_bus.dev = dev;
> +	dev->i2c_bus.reg_base = 0xd80;
> +
> +	if (get_resources(dev) < 0) {
> +		pr_err(
> +		"CORE %s No more PCIe resources for subsystem: %04x:%04x\n",
> +		       dev->name, dev->pci->subsystem_vendor,
> +		       dev->pci->subsystem_device);
> +
> +		vc8x0_devcount--;
> +		return -ENODEV;
> +	}
> +
> +	/* PCIe stuff */
> +	dev->lmmio032 = ioremap(pci_resource_start(dev->pci, BAR0),
> +			     pci_resource_len(dev->pci, BAR0));
> +	dev->lmmio064 = (u64 *)dev->lmmio032;
> +	dev->bmmio = (u8 *)dev->lmmio032;
> +	dev->lmmio4 = ioremap(pci_resource_start(dev->pci, BAR4),
> +			     pci_resource_len(dev->pci, BAR4));
> +
> +	dev->m_nInterruptMask1 = 0;
> +	dev->m_nInterruptMask2 = 0;
> +
> +	pr_info("CORE %s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
> +	       dev->name, dev->pci->subsystem_vendor,
> +	       dev->pci->subsystem_device, vc8x0_boards[dev->board].name,
> +	       dev->board, card[dev->nr] == dev->board ?
> +	       "insmod option" : "autodetected");
> +
> +	return 0;
> +}

This is driver's author choice, but I would move driver init, register, unregister
logic to be at *-cards.c. That balances a little more the code size on each
.c file. We successfully did it on several drivers, and the end result reduced
the number of exported functions.

> +#if ENABLE_ALSA
...

> +#if ENABLE_MONITOR_REGISTERS
...
> +#if ENABLE_AUDIO_KEEPALIVE && ENABLE_ALSA
...

Why do you need those defines? If they're needed, please use CONFIG_foo.

If they're for debug purposes, please convert them on if (debug == FOO).

> +#if ENABLE_ALSA && ENABLE_AUDIO_KEEPALIVE
> +		/* The PCM audio subsystem throws this messages:
> +		 * ALSA sound/core/pcm_lib.c:1765: capture write error
> +		 * (DMA or IRQ trouble?) when no audio is delivered for 10
> +		 * seconds. It basically means it's worker thread didn't
> +		 * receive a notification with 10 seconds. The message is poor.
> +		 * In terms of the vc8x0 driver this message will appear by
> +		 * default if the HDMI cable is disconnected for > 10 seconds,
> +		 * and it will appear every 10 seconds. If you don't want
> +		 * this IRQ message to appear then set ENABLE_AUDIO_KEEPLIVE=1

How to set it? It is not on Kconfig, nor it is a modprobe option.

> +		/* Other parts of the driver need to guarantee that
> +		 * various 'keep alives' aren't happening. We'll
> +		 * prevent race conditions by allowing the
> +		 * rest of the driver to dictate when
> +		 * this keepalives can occur.
> +		 */
> +		mutex_lock(&dev->kthread_lock);
> +
> +		mutex_unlock(&dev->kthread_lock);

Huh???? Lock/unlock here, without any code inside? That looks odd.

> +#if ENABLE_BAD_READS

Yet another define stuff, without a Kconfig item.

> diff --git a/drivers/media/pci/vc8x0/vc8x0-display.c b/drivers/media/pci/vc8x0/vc8x0-display.c

> +struct letter_t {
> +	u8 *ptr;
> +	u8 data[8];
> +} charset[] = {
> + /* ' ' */ [0x20] = { 0, { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, },
> + /* 00000000 */
> + /* 00000000 */
> + /* 00000000 */
> + /* 00000000 */
> + /* 00000000 */
> + /* 00000000 */
> + /* 00000000 */
> + /* 00000000 */
> + /* '!' */ [0x21] = { 0, { 0x04, 0x04, 0x04, 0x04, 0x00, 0x00, 0x04, 0x00 }, },
> + /* 00000100 */
> + /* 00000100 */
> + /* 00000100 */
> + /* 00000100 */
> + /* 00000000 */
> + /* 00000000 */
> + /* 00000100 */
> + /* 00000000 */

Charset???? No, please! If you really need a charset, take a look at the
vivi driver. It uses an already-existent Kernel charset. See:

	static int __init vivi_init(void)
	{
		const struct font_desc *font = find_font("VGA8x16");

Not sure about the rest of the code here at vc8x0-display.c, but maybe you'll
find a similar code to it already coded. Where do you use it?

> diff --git a/drivers/media/pci/vc8x0/vc8x0-dma.c b/drivers/media/pci/vc8x0/vc8x0-dma.c

> +/* DMA SEQUENCER PROGRAM */
> +
> +static u32 vc8x0_FlexDMAProgram[] = {
> +/*	0x0000	*/	VDMA_LOAD_RA(VD_1_STREAM_DISABLED),
...
> +/*	0x02DA	*/	VDMA_JMP(VDMA_ALWAYS, 0, MAIN),
> +};
> +

Firmware? It is likely better to put it elsewhere, maybe at linux-firmware.
There are some GPL'd firmwares there.

I'll comment the remaining files of patch 4 on a separate email
(editing a 11.000 lines email is very hard... my emailer crashed a few
 times).

Regards,
Mauro


