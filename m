Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab2INCJy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 22:09:54 -0400
Message-ID: <505291E6.9020606@redhat.com>
Date: Thu, 13 Sep 2012 23:09:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com> <201208161649.43284.hverkuil@xs4all.nl> <CALzAhNWT3eNUNwNsGG_w+Jbz=ErRxogvv+_3GcKy8xZ+R-uZ=A@mail.gmail.com> <201208162049.35773.hverkuil@xs4all.nl> <CALzAhNXZx1+048S_rVsWH3fMg8sJnawo3o+bS6ygD5KRpjYZ3g@mail.gmail.com> <20120913201958.266fee52@infradead.org> <50526AFE.20003@redhat.com> <5052818B.7090708@redhat.com>
In-Reply-To: <5052818B.7090708@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-09-2012 21:59, Mauro Carvalho Chehab escreveu:
> Em Thu, 13 Sep 2012 20:23:42 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> 
>> Em 13-09-2012 20:19, Mauro Carvalho Chehab escreveu:
>>> Em Sat, 18 Aug 2012 11:48:52 -0400
>>> Steven Toth <stoth@kernellabs.com> escreveu:
>>>
>>>> Mauro, please read below, a new set of patches I'm submitting for merge.
>>>>
>>>> On Thu, Aug 16, 2012 at 2:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>> On Thu August 16 2012 19:39:51 Steven Toth wrote:
>>>>>>>> So, I've ran v4l2-compliance and it pointed out a few things that I've
>>>>>>>> fixed, but it also does a few things that (for some reason) I can't
>>>>>>>> seem to catch. One particular test is on (iirc) s_fmt. It attempts to
>>>>>>>> set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
>>>>>>>> it actually receives 0x0. This feels more like a bug in the test.
>>>>>>>> Either way, I have some if (std & ATSC) return -EINVAL, but it still
>>>>>>>> appears to fail the test.
>>>>>>
>>>>>> Oddly enough. If I set tvnorms to something valid, then compliance
>>>>>> passes but gstreamer
>>>>>> fails to run, looks like some kind of confusion about either the
>>>>>> current established
>>>>>> norm, or a failure to establish a norm.
>>>>>>
>>>>>> For the time being I've set tvnorms to 0 (with a comment) and removed
>>>>>> current_norm.
>>>>>
>>>>> Well, this needs to be sorted, because something is clearly amiss.
>>>>
>>>> Agreed. I just can't see what's wrong. I may need your advise /
>>>> eyeballs on this. I'd be willing to provide logs that show gstreamer
>>>> accessing the driver and exiting. It needs fixed, I've tried, I just
>>>> can't see why gstreamer fails.
>>>>
>>>> On the main topic of merge.... As promised, I spent quite a bit of
>>>> time this week reworking the code based on the feedback. I also
>>>> flattened all of these patches into a single patchset and upgraded to
>>>> the latest re-org tree.
>>>>
>>>> The source notes describe in a little more detail the major changes:
>>>> http://git.kernellabs.com/?p=stoth/media_tree.git;a=commit;h=f295dd63e2f7027e327daad730eb86f2c17e3b2c
>>>>
>>>> Mauro, so, I hereby submit for your review/merge again, the updated
>>>> patchset. *** Please comment. ***
>>>
>>> I'll comment patch by patch. Let's hope the ML will get this email. Not sure,
>>> as it tends to discard big emails like that.
>>>
>>> This is the comment of patch 1/4.
>>>
>>
>> Patch 2 is trivial. It is obviously OK.
>>
>> Patch 3 also looked OK on my eyes.
> 
> Patch 4 will very likely be discarded by vger server, if everything is
> added there. So, I'll drop the parts that weren't commented.
> 
> Anyway:
> 
>> Subject: [media] vc8x0: Adding support for the ViewCast O820E Capture Card.
>> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
>>
>> A dual channel 1920x1080p60 PCIe x4 capture card, two DVI
>> inputs capable of capturing DVI/HDMI, Component, Svideo, Composite
>> and some VGA resolutions.
> ...
> 
>> +#include "vc8x0.h"
>> +
>> +static unsigned int audio_debug;
>> +module_param(audio_debug, int, 0644);
>> +MODULE_PARM_DESC(audio_debug, "enable debug messages [audio]");
>> +
>> +static unsigned int audio_alsa_during_irq = 1;
>> +module_param(audio_alsa_during_irq, int, 0644);
>> +MODULE_PARM_DESC(audio_alsa_during_irq, "feed alsa during the irq handler, not via a dpc [audio]");
>> +
>> +#define dprintk(level, fmt, arg...)\
>> +	do {\
>> +		if (audio_debug >= level)\
>> +			pr_err("%s/0: " fmt, \
>> +				channel->dev->name, ## arg);\
>> +	} while (0)
>> +
>> +#define MIXER_RCA_JACKS 1
>> +
>> +/* Repack 24 bit audio samples (in 32bit alignment)
>> + * into 16bit samples within the same buffer, and
>> + * return the new buffer length in bytes.
>> + *
>> + * Input Sample:
>> + * LEFT         RIGHT
>> + * 00 B0 B1 B2  00 B1 B1 B2
>> +
>> + * Output Sample:
>> + * LEFT   RIGHT
>> + * B1 B2  B1 B2
>> + */
>> +static int repack_24_to_16(u8 *buf, int len)
>> +{
>> +	int i;
>> +	u8 *dst = buf;
>> +	u8 *src = buf + 2;
>> +
>> +	/* For each 24 bit sample */
>> +	for (i = 0; i < (len / 4); i++) {
>> +		*(dst) = *(src);
>> +		*(dst + 1) = *(src + 1);
>> +		dst += 2;
>> +		src += 4;
>> +	}
>> +
>> +	return (len / 4) * 2;
>> +}
> 
> Why is it needed? It would be better to let ALSA userspace to handle
> it.
> 
>> +	dprintk(3,
>> +		"%s() %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
>> +		__func__, *(buf->cpu + 0), *(buf->cpu + 1), *(buf->cpu + 2),
>> +		*(buf->cpu + 3), *(buf->cpu + 4), *(buf->cpu + 5),
>> +		*(buf->cpu + 6), *(buf->cpu + 7), *(buf->cpu + 8),
>> +		*(buf->cpu + 9), *(buf->cpu + 10), *(buf->cpu + 11),
>> +		*(buf->cpu + 12), *(buf->cpu + 13), *(buf->cpu + 14),
>> +		*(buf->cpu + 15)
>> +	    );
> 
> FYI, there's now a new printk syntax to print buffer dumps like
> that, where you pass the buffer and the length, and printk does the
> rest.
> 
>> +	spin_unlock(&channel->dma_buffers_full_lock);
>> +	spin_unlock_irqrestore(&channel->dma_buffers_dpc_lock, flags);
>> +
>> +	/* BAM! The interrupt handler is now free to move on */
>> +	/* BAM! The interrupt handler is now free to move on */
>> +	/* BAM! The interrupt handler is now free to move on */
>> +	/* BAM! The interrupt handler is now free to move on */
> 
> Wow! the above 4 lines won the prize of the weirdest comment I ever seen ;)
> Why you need to say the above 4 times? :)
> 
> Even saying it once seems overkill to me, as it just repeats what the
>  spin_unlock() just said ;)
> 
>> +
>> +	/* Now let's dequeue the full buffers */
>> +	/* For each full buffer, send it to user space */
>> +	spin_lock(&channel->dma_buffers_full_lock);
> 
> Huh? You just unlocked it... Also, it looks weird that you're using two spin
> locks on the above code, and just one here. Using more than one spin lock
> like that could cause dead locks.
> 
> Btw, this patch is too big! You should break it into some smaller
> pieces (one patch per file, for example) making life easier for reviewers and
> allowing people at the ML to see/comment the full code, as one of the requirements
> is that, before sending a pull request, you should be sending the patches to
> the ML.
> 
> In the specific case of the -alsa driver, it is mandatory to have it on a
> separate patch, as it should be copied also to the alsa ML, to allow alsa
> people to comment/review.
> 
> So, please split patch 4 into separate patches, doing the Kconfig/Makefile
> integration at the end of your series.
> 
>> +	buf->used_len = 3840;
>> +	buf->used_len = repack_24_to_16(buf->cpu, buf->used_len);
> 
> This repack thing looks weird on my eyes.
> 
>> +	spin_lock_irqsave(&channel->dma_buffers_busy_lock, flags);
>> +
>> +	/* Last, put the buffer on the DPC list for our deferred worker
>> +	 * to process */
>> +	spin_lock_irqsave(&channel->dma_buffers_dpc_lock, flags);
> 
> Again, double-locking.
> 
>> +static inline void handle_audio_data(struct vc8x0_dma_buffer *buf,
>> +	int *period_elapsed)
>> +{
>> +	struct vc8x0_dma_channel *channel = buf->channel;
>> +	struct vc8x0_audio_dev *chip = channel->audio_dev;
>> +	struct snd_pcm_runtime *runtime = chip->capture_pcm_substream->runtime;
>> +	int stride;
>> +	int len, rdb, cpsafe[3];
>> +	unsigned char *cp;
>> +	unsigned int oldptr;
>> +
>> +	stride = runtime->frame_bits >> 3;
>> +	if (stride == 0) {
>> +		pr_err("%s() divbyzero BUG\n", __func__);
>> +		stride = 4;
>> +	}
>> +
>> +	len = buf->used_len / stride;
> 
> Hmm... that looks weird on my eyes, as other drivers don't have
> such check. Why such logic is needed? Rounding it to 4 won't cause
> buffer overflows? Maybe a BUG_ON would apply better here.
> 
>> +#if ENABLE_ALSA_MIXER
> 
> Please use CONFIG_foo instead, it the user may opt to have it or not.
> 
>> diff --git a/drivers/media/pci/vc8x0/vc8x0-buffer.c b/drivers/media/pci/vc8x0/vc8x0-buffer.c
> 
> 
>> +DMA buffers per channel must be contigious, reside only in 32bit
> 
> typo: contiguous.
> 
>> +memory.
>> +
>> +The PCIe bridge (GN4124) supports up to 18 'fifos', essentially
>> +discrete DMA channels. The GN4124 uses a DMA Sequencer architecture
>> +to control which dma buffers are targets for which channel. The sequencer
>> +is a list of program instructions that effictivel handle the data modement
> 
> typo: effective
> 
>> +
>> +void vc8x0_buffer_analyze(u8 *buf, int len)
>> +{
>> +	int i;
>> +	u32 data[256];
>> +	memset(data, 0, sizeof(data));
>> +
>> +	for (i = 0; i < len; i++) {
>> +		data[*(buf + i)]++;
>> +	}
>> +
>> +	for (i = 0; i < 256; i++) {
>> +		if (data[i]) {
>> +			pr_err("%02x %x\n", i, data[i]);
>> +		}
>> +	}
> 
> use print_hex_dump() instead of the loop.
> 
> On a big driver, like that, it is hard to see how each module
> interacts with the others. Yet, it seemed, on my eyes, that
> vc8x0-buffer is doing something close to what vb2-contig is
> already doing.
> 
> If you need to use contiguous buffer memories for DMA transfers,
> I strongly suggest you to use vb2, as vb1 is known to have some
> serious issues with contiguous memories.
> 
>> diff --git a/drivers/media/pci/vc8x0/vc8x0-channel.c b/drivers/media/pci/vc8x0/vc8x0-channel.c
> 
> Again, it is hard to understand what is there at *-channel, in the context
> of the entire driver, but it seems part of a videobuf handling code.
> 
>> diff --git a/drivers/media/pci/vc8x0/vc8x0-core.c b/drivers/media/pci/vc8x0/vc8x0-core.c
> 
>> +
>> +/* 1 = Basic device statistics
>> + * 2 = PCIe register dump for entire device
>> + * 4 = AD9985 register dump
>> + * 8 = SIL9013 register dump
>> + */
>> +unsigned int vc8x0_thread_active = 1;
>> +module_param(vc8x0_thread_active, int, 0644);
>> +MODULE_PARM_DESC(vc8x0_thread_active, "should keep alive thread run");
> 
> Is it really needed? If so, I think you should better describe it as, the
> above description doesn't mean anything for me... What Thread? What happens
> if the thread doesn't run?
> 
>> +static int vc8x0_dev_setup(struct vc8x0_dev *dev)
>> +{
>> +	int i;
>> +
>> +	mutex_init(&dev->lock);
>> +
>> +	atomic_inc(&dev->refcount);
>> +
>> +	dev->nr = vc8x0_devcount++;
>> +	sprintf(dev->name, "vc8x0[%d]", dev->nr);
>> +
>> +	/* board config */
>> +	dev->board = UNSET;
>> +	if (card[dev->nr] < vc8x0_bcount)
>> +		dev->board = card[dev->nr];
>> +	for (i = 0; UNSET == dev->board  &&  i < vc8x0_idcount; i++)
>> +		if (dev->pci->subsystem_vendor == vc8x0_subids[i].subvendor &&
>> +		    dev->pci->subsystem_device == vc8x0_subids[i].subdevice)
>> +			dev->board = vc8x0_subids[i].card;
>> +	if (UNSET == dev->board) {
>> +		dev->board = VC8X0_BOARD_UNKNOWN;
>> +		vc8x0_card_list(dev);
>> +	}
>> +
>> +	/* The keepalive thread needs a mutex */
>> +	mutex_init(&dev->kthread_lock);
>> +
>> +	/* Main Master 0 Bus incl. eeprom */
>> +	mutex_init(&dev->i2c_bus.lock);
>> +	dev->i2c_bus.nr = 0;
>> +	dev->i2c_bus.dev = dev;
>> +	dev->i2c_bus.reg_base = 0xd80;
>> +
>> +	if (get_resources(dev) < 0) {
>> +		pr_err(
>> +		"CORE %s No more PCIe resources for subsystem: %04x:%04x\n",
>> +		       dev->name, dev->pci->subsystem_vendor,
>> +		       dev->pci->subsystem_device);
>> +
>> +		vc8x0_devcount--;
>> +		return -ENODEV;
>> +	}
>> +
>> +	/* PCIe stuff */
>> +	dev->lmmio032 = ioremap(pci_resource_start(dev->pci, BAR0),
>> +			     pci_resource_len(dev->pci, BAR0));
>> +	dev->lmmio064 = (u64 *)dev->lmmio032;
>> +	dev->bmmio = (u8 *)dev->lmmio032;
>> +	dev->lmmio4 = ioremap(pci_resource_start(dev->pci, BAR4),
>> +			     pci_resource_len(dev->pci, BAR4));
>> +
>> +	dev->m_nInterruptMask1 = 0;
>> +	dev->m_nInterruptMask2 = 0;
>> +
>> +	pr_info("CORE %s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
>> +	       dev->name, dev->pci->subsystem_vendor,
>> +	       dev->pci->subsystem_device, vc8x0_boards[dev->board].name,
>> +	       dev->board, card[dev->nr] == dev->board ?
>> +	       "insmod option" : "autodetected");
>> +
>> +	return 0;
>> +}
> 
> This is driver's author choice, but I would move driver init, register, unregister
> logic to be at *-cards.c. That balances a little more the code size on each
> .c file. We successfully did it on several drivers, and the end result reduced
> the number of exported functions.
> 
>> +#if ENABLE_ALSA
> ...
> 
>> +#if ENABLE_MONITOR_REGISTERS
> ...
>> +#if ENABLE_AUDIO_KEEPALIVE && ENABLE_ALSA
> ...
> 
> Why do you need those defines? If they're needed, please use CONFIG_foo.
> 
> If they're for debug purposes, please convert them on if (debug == FOO).
> 
>> +#if ENABLE_ALSA && ENABLE_AUDIO_KEEPALIVE
>> +		/* The PCM audio subsystem throws this messages:
>> +		 * ALSA sound/core/pcm_lib.c:1765: capture write error
>> +		 * (DMA or IRQ trouble?) when no audio is delivered for 10
>> +		 * seconds. It basically means it's worker thread didn't
>> +		 * receive a notification with 10 seconds. The message is poor.
>> +		 * In terms of the vc8x0 driver this message will appear by
>> +		 * default if the HDMI cable is disconnected for > 10 seconds,
>> +		 * and it will appear every 10 seconds. If you don't want
>> +		 * this IRQ message to appear then set ENABLE_AUDIO_KEEPLIVE=1
> 
> How to set it? It is not on Kconfig, nor it is a modprobe option.
> 
>> +		/* Other parts of the driver need to guarantee that
>> +		 * various 'keep alives' aren't happening. We'll
>> +		 * prevent race conditions by allowing the
>> +		 * rest of the driver to dictate when
>> +		 * this keepalives can occur.
>> +		 */
>> +		mutex_lock(&dev->kthread_lock);
>> +
>> +		mutex_unlock(&dev->kthread_lock);
> 
> Huh???? Lock/unlock here, without any code inside? That looks odd.
> 
>> +#if ENABLE_BAD_READS
> 
> Yet another define stuff, without a Kconfig item.
> 
>> diff --git a/drivers/media/pci/vc8x0/vc8x0-display.c b/drivers/media/pci/vc8x0/vc8x0-display.c
> 
>> +struct letter_t {
>> +	u8 *ptr;
>> +	u8 data[8];
>> +} charset[] = {
>> + /* ' ' */ [0x20] = { 0, { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, },
>> + /* 00000000 */
>> + /* 00000000 */
>> + /* 00000000 */
>> + /* 00000000 */
>> + /* 00000000 */
>> + /* 00000000 */
>> + /* 00000000 */
>> + /* 00000000 */
>> + /* '!' */ [0x21] = { 0, { 0x04, 0x04, 0x04, 0x04, 0x00, 0x00, 0x04, 0x00 }, },
>> + /* 00000100 */
>> + /* 00000100 */
>> + /* 00000100 */
>> + /* 00000100 */
>> + /* 00000000 */
>> + /* 00000000 */
>> + /* 00000100 */
>> + /* 00000000 */
> 
> Charset???? No, please! If you really need a charset, take a look at the
> vivi driver. It uses an already-existent Kernel charset. See:
> 
> 	static int __init vivi_init(void)
> 	{
> 		const struct font_desc *font = find_font("VGA8x16");
> 
> Not sure about the rest of the code here at vc8x0-display.c, but maybe you'll
> find a similar code to it already coded. Where do you use it?
> 
>> diff --git a/drivers/media/pci/vc8x0/vc8x0-dma.c b/drivers/media/pci/vc8x0/vc8x0-dma.c
> 
>> +/* DMA SEQUENCER PROGRAM */
>> +
>> +static u32 vc8x0_FlexDMAProgram[] = {
>> +/*	0x0000	*/	VDMA_LOAD_RA(VD_1_STREAM_DISABLED),
> ...
>> +/*	0x02DA	*/	VDMA_JMP(VDMA_ALWAYS, 0, MAIN),
>> +};
>> +
> 
> Firmware? It is likely better to put it elsewhere, maybe at linux-firmware.
> There are some GPL'd firmwares there.
> 
> I'll comment the remaining files of patch 4 on a separate email
> (editing a 11.000 lines email is very hard... my emailer crashed a few
>  times).

> diff --git a/drivers/media/pci/vc8x0/vc8x0-video.c b/drivers/media/pci/vc8x0/vc8x0-video.c

> +static unsigned int video_1080p = 1;
> +module_param(video_1080p, int, 0644);
> +MODULE_PARM_DESC(video_1080p, "enable 1080i50/60 (0) or 1080p50/60 (1) handling [default 1, 1080p]");

DV timings API allows selecting each time. No need for modprobe
parameters.

> +
> +static struct vc8x0_format formats[] = {
> +	{
> +		.name     = "422packed,YUYV,640x480p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 640,
> +		.height   = 480,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_640x480p60,

Again, please use the public standards at DV API. You'll only
need adv7441a-specific ID's it it supports non-standard timings.

> +static int vc8x0_video_generate_osd(struct vc8x0_dma_channel *channel, u8 *dst)
> +{
> +#if 1
> +	return 0;
> +#else
> +	/* Do some text rendering */
> +	struct vc8x0_format *fmt = channel->ad7441_ctx.detected_fmt;
> +	unsigned char tmp[256];
> +	int ret;
> +
> +	ret = vc8x0_display_render_reset(&channel->display_ctx, dst,
> +		channel->fmt->width);
> +	if (ret < 0)
> +		return ret;

Hmm... Are you using the *-display.c code for OSD? Not sure if it is
a good idea to handle it like that.

Hans,

What do you think?

Yet, the code here is commented, but there's a hole driver there in order
to implement OSD display, just bloating the driver's code... 
...

> +void vc8x0_video_timeout(unsigned long data)
> +{
> +	struct vc8x0_dma_channel *channel = (struct vc8x0_dma_channel *)data;
> +	struct vc8x0_buffer *buf;
> +	u8 *dst;
> +	unsigned long flags;
> +
> +	dprintk(1, "%s()\n", __func__);
> +
> +	if (channel->state != STATE_RUNNING) {
> +		/* Return without processing the buffer or restarting
> +		 * the timer
> +		 */
> +		pr_err("%s() channel stopped, aborting\n", __func__);
> +		return;
> +	}
> +
> +	/* Return all of the buffers in error state, so the vbi/vid inode
> +	 * can return from blocking.
> +	 */
> +	spin_lock_irqsave(&channel->v4l2_capture_lock, flags);
> +	while (!list_empty(&channel->v4l2_capture)) {
> +		buf = list_entry(channel->v4l2_capture.next,
> +			struct vc8x0_buffer, vb.queue);
> +
> +		/* See the notes in the video dequeue section related to
> +		 * generating colorbars */
> +		dst = videobuf_to_vmalloc(&buf->vb);

Double-buffering? Doesn't it be giving you some performance issues?

I suspect that converting it to VB2 will allow you to avoid the
memcpy you're likely doing with VB1.

> +
> +/* Linux VBI handling wants lines 5-21 in a single videobuf buffer in YUY2
> + * format. We'll skip the first 4 lines of the FPGA buffer, convert to 422
> + * and place the resulting pixeldata into a short VBI buffer. Unlikely
> + * video, once the single field of VBI data is processed, we'll hand it off
> + * to the user sometime after this function has created the content.
> + */

Hmm... doesn't it support sliced VBI? If so, I think the implementation will
be cleaner... there are lots of "magic stuff" on the code below.

> +void vc8x0_process_vbi_field(u8 *py, struct vc8x0_buffer *vb_buf, int nr,
> +	struct vc8x0_format *fmt)
> +{
> +	u8 *dst = 0;
> +	u8 *y;
> +	int i;
> +
> +	dst = videobuf_to_vmalloc(&vb_buf->vb);
> +
> +	/* VBI collected buy the PGA starts at line 2, so we need to put
> +	 * this in line 2 in the dest buffer.
> +	 */
> +	if (nr == 1) {
> +		dst += (vb_buf->vb.width);
> +		dst += (vb_buf->vb.width) * 21;
> +	}
> +
> +	y  = (py + ((fmt->width * (fmt->height / 2)) * nr));
> +	if (nr == 1)
> +		y += (fmt->width * fmt->vbi_field0_lines);
> +
> +	/* We're going to deinterlace in dwords */
> +	/* We're going to deinterlace 4 dwords at a time, 8 pixels per cycle */
> +
> +	/* Process a single field of vbi data, 17 lines max */
> +	for (i = 0; i < 22; i++)
> +		memcpy(dst + (i * 1440), y + (i * fmt->width), 720);
> +}
> +
> +void vc8x0_process_video_field(u8 *py, u8 *pu, u8 *pv,
> +	struct vc8x0_buffer *vb_buf, int nr,
> +	u32 vbi_enabled, struct vc8x0_format *fmt)
> +{
> +	u32 px[4];
> +	u32 yp, up, vp;
> +	u8 *dst = 0;
> +	u32 *ddst = 0;
> +	u32 *y, *u, *v;
> +	u32 ymax;
> +	int i, pixelcount;
> +
> +	dst = videobuf_to_vmalloc(&vb_buf->vb);
> +	dst += ((vb_buf->vb.width * 2) * nr);
> +	ddst = (u32 *)dst;
> +
> +	y  = (u32 *)(py + ((vb_buf->vb.width * (vb_buf->vb.height / 2)) * nr));
> +	u  = (u32 *)(pu + (((vb_buf->vb.width / 2) *
> +		(vb_buf->vb.height / 2)) * nr));
> +	v  = (u32 *)(pv + (((vb_buf->vb.width / 2) *
> +		(vb_buf->vb.height / 2)) * nr));
> +
> +	if (vbi_enabled) {
> +		/* VBI */
> +		if (nr == 0) {
> +			y += ((fmt->width * fmt->vbi_field0_lines) /
> +				sizeof(u32));
> +			u += (((fmt->width / 2) * fmt->vbi_field0_lines) /
> +				sizeof(u32));
> +			v += (((fmt->width / 2) * fmt->vbi_field0_lines) /
> +				sizeof(u32));
> +		} else {
> +			y += ((fmt->width * fmt->vbi_field0_lines) /
> +				sizeof(u32));
> +			u += (((fmt->width / 2) * fmt->vbi_field0_lines) /
> +				sizeof(u32));
> +			v += (((fmt->width / 2) * fmt->vbi_field0_lines) /
> +				sizeof(u32));
> +
> +			y += ((fmt->width * fmt->vbi_field1_lines) /
> +				sizeof(u32));
> +			u += (((fmt->width / 2) * fmt->vbi_field1_lines) /
> +				sizeof(u32));
> +			v += (((fmt->width / 2) * fmt->vbi_field1_lines) /
> +				sizeof(u32));
> +		}
> +	}
> +
> +	/* We're going to deinterlace in dwords */
> +	/* We're going to deinterlace 4 dwords at a time, 8 pixels per cycle */
> +
> +	/* Process a single field (height / 2) of width ant 8 pixels per time */
> +	ymax = ((vb_buf->vb.height / 2) * vb_buf->vb.width) / 8;
> +	for (i = 0, pixelcount = 0; i < ymax; i++, pixelcount += 8) {
> +
> +		if (pixelcount == (vb_buf->vb.width)) {
> +			ddst += (vb_buf->vb.width / 2);
> +			pixelcount = 0;
> +		}
> +
> +		/* highly optimized for intel i686 little endian, which is
> +		 * what the SOW calls for. */
> +		/* Input data in ram looks like:
> +		 * y_plane: Y0 Y1 Y2 Y3 Y4 Y5 Y6 Y7 Y8
> +		 * u_plane: U0 U1 U2 U3
> +		 * v_plane: V0 V1 V2 V3
> +		 *
> +		 * We shuffle these bytes into dwords ...
> +		 * px[0] = 0xV0Y1U0Y0
> +		 * px[1] = 0xV1Y3U1Y2
> +		 * px[2] = 0xV2Y5U2Y4
> +		 * px[3] = 0xV3Y7U3Y6
> +		 *
> +		 * and the dwords in little ending are stored back into a
> +		 * byte buffer,
> +		 * which then looks like:
> +		 * bytes 0 - 15 ->
> +		 * Y0 U0 Y1 V0  Y2 U1 Y3 V1  Y3 U2 Y4 V2  Y5 U3 Y6 V3
> +		 *
> +		 */
> +
> +		yp = *(y++);
> +		up = *(u++);
> +		vp = *(v++);
> +
> +		/* Pixels 1, 2 */
> +		/* Y0 xx Y1 xx */
> +		px[0] = (yp & 0x000000ff) | ((yp & 0x0000ff00) << 8);
> +
> +		/* xx U0 xx xx */
> +		px[0] |= ((up & 0x000000ff) << 8);
> +
> +		/* xx xx xx V0 */
> +		px[0] |= ((vp & 0x000000ff) << 24);
> +
> +		/* Pixels 3, 4 */
> +		/* Y0 xx Y1 xx */
> +		px[1] = ((yp & 0x00ff0000) >> 16) | ((yp & 0xff000000) >> 8);
> +
> +		/* xx U0 xx xx */
> +		px[1] |= (up & 0x0000ff00);
> +
> +		/* xx xx xx V0 */
> +		px[1] |= ((vp & 0x0000ff00) << 16);
> +
> +
> +		yp = *(y++);
> +
> +		/* Pixels 5, 6 */
> +		/* Y0 xx Y1 xx */
> +		px[2] = (yp & 0x000000ff) | ((yp & 0x0000ff00) << 8);
> +
> +		/* xx U0 xx xx */
> +		px[2] |= ((up & 0x00ff0000) >> 8);
> +
> +		/* xx xx xx V0 */
> +		px[2] |= ((vp & 0x00ff0000) << 8);
> +
> +
> +		/* Pixels 7, 8 */
> +		/* Y0 xx Y1 xx */
> +		px[3] = ((yp & 0x00ff0000) >> 16) | ((yp & 0xff000000) >> 8);
> +
> +		/* xx U0 xx xx */
> +		px[3] |= ((up & 0xff000000) >> 16);
> +
> +		/* xx xx xx V0 */
> +		px[3] |= (vp & 0xff000000);
> +
> +		/* clk the 8 pixels (4 dwords) into the videobuf image, now
> +		 * as YUYV422 */
> +
> +		*(ddst++) = px[0];
> +		*(ddst++) = px[1];
> +		*(ddst++) = px[2];
> +		*(ddst++) = px[3];
> +	}
> +}
> +

The above are format conversions!!! It should be at libv4l, and not on
Kernelspace.

> +			if (fmt->flags == ADV7441A_FORMAT_INTERLACED) {
> +
> +				vc8x0_process_video_field(
> +					buf->cpu_y_plane,
> +					buf->cpu_u_plane,
> +					buf->cpu_v_plane,
> +					vb_buf,
> +					0,
> +					channel->vbi_enabled,
> +					fmt);
> +				vc8x0_process_video_field(
> +					buf->cpu_y_plane,
> +					buf->cpu_u_plane,
> +					buf->cpu_v_plane,
> +					vb_buf,
> +					1,
> +					channel->vbi_enabled,
> +					fmt);

Those in-kernel software format changing logic is not allowed.
Instead, add it video formats parsing into libv4l and output 
the format here as provided by the hardware.

> +
> +				if (channel->vbi_enabled) {
> +					spin_lock(&channel->vbi_capture_lock);
> +					do {
> +						if (list_empty(&channel->vbi_capture)) {
> +							break;
> +						}
> +
> +						vbi_buf = list_entry(channel->vbi_capture.next,
> +							struct vc8x0_buffer, vb.queue);
> +						dst = videobuf_to_vmalloc(&vbi_buf->vb);
> +						if (!dst)
> +							break;
> +						vc8x0_process_vbi_field(buf->cpu_y_plane, vbi_buf, 0, fmt);
> +						vc8x0_process_vbi_field(buf->cpu_y_plane, vbi_buf, 1, fmt);

libv4l doesn't handle weird vbi formats, so, while this is ugly,
we might accept it if there isn't any other clean way of doing it.

> +
> +						do_gettimeofday(&vbi_buf->vb.ts);

We're not using gettimeofday() anymore, as the time is not
monotonic (e. g. it is affected by TZ). See the KS/2012 notes.

> +						list_del(&vbi_buf->vb.queue);
> +
> +						vbi_buf->vb.state = VIDEOBUF_DONE;
> +						wake_up(&vbi_buf->vb.done);
> +
> +						/* re-set the buffer timeout */
> +						mod_timer(&channel->vbi_timeout,
> +							jiffies + (HZ / 2));
> +
> +					} while (0);
> +					spin_unlock(&channel->vbi_capture_lock);
> +				}
> +
> +			} else
> +			if (fmt->flags == ADV7441A_FORMAT_PROGRESSIVE) {
> +				for (i = 0, j = 0; i < (vb_buf->vb.height *
> +					vb_buf->vb.width); i++, j += 2) {
> +					crc += *(buf->cpu_y_plane + i);
> +					*(pdst + j + 0) =
> +						*(buf->cpu_y_plane + i);
> +				}
> +				for (i = 0, j = 1; i < ((vb_buf->vb.height *
> +					vb_buf->vb.width) / 2); i++, j += 4) {
> +					*(pdst + j + 0) =
> +						*(buf->cpu_u_plane + i);
> +					*(pdst + j + 2) =
> +						*(buf->cpu_v_plane + i);
> +				}

> +	spin_unlock_irqrestore(&channel->dma_buffers_dpc_lock, flags);
> +
> +	/* BAM! The interrupt handler is now free to move on */
> +	/* BAM! The interrupt handler is now free to move on */
> +	/* BAM! The interrupt handler is now free to move on */
> +	/* BAM! The interrupt handler is now free to move on */
> +
> +	/* Now let's dequeue the full buffers */
> +	/* For each full buffer, send it to user space */
> +	spin_lock(&channel->dma_buffers_full_lock);

Oh: That bambambambam comments again.... Looks weird, and I bet it will
cause dead locks as well.

> +	list_for_each_safe(p, q, &channel->dma_buffers_full) {
> +
> +		buf = list_entry(p, struct vc8x0_dma_buffer, list);
> +
> +		vc8x0_video_buffer_dequeue(buf);
> +
> +		spin_lock_irqsave(&channel->dma_buffers_busy_lock, flags);
> +		buf->state = STATE_BUSY;
> +		list_move_tail(&buf->list, &channel->dma_buffers_busy);
> +		spin_unlock_irqrestore(&channel->dma_buffers_busy_lock, flags);
> +
> +	}
> +	spin_unlock(&channel->dma_buffers_full_lock);
> +}
> +
> +int vc8x0_video_irqhandler(struct vc8x0_dma_channel *channel)
> +{
> +	struct vc8x0_dev *dev = channel->dev;
> +	struct vc8x0_dma_buffer *buf, *ts_buf;
> +	int handled = 0;
> +
> +	u32 lastidx = 0, vid_pciaddr = 0, ts_pciaddr = 0;
> +	u32 buflen, reg;
> +	unsigned long flags;
> +
> +	/* Process the interrupt */
> +
> +	channel->buffers_processed++;
> +	buflen = channel->fmt->width * channel->fmt->height * 2;
> +	if (buflen > MAX_USER_VIDEO_BUFFER_SIZE) {
> +		pr_err("%s() buffer length is corrupt (%x).\n",
> +			__func__, buflen);
> +		goto badaddr;
> +	}
> +
> +	/* Find the finished frame and locate it's pci address */
> +	lastidx = vc_read32(channel->regs.m_nLastFrameIndex);
> +	if ((lastidx < 1) || (lastidx > MAX_USER_VIDEO_BUFFERS)) {
> +		pr_err("%s() lastidx out of range, critical (%x).\n",
> +			__func__, lastidx);
> +		goto badaddr;
> +	}
> +
> +	if (channel->lastidx == lastidx) {
> +		/* We've already processed this frame, skip it,
> +		 * duplicate interrupt.
> +		 */
> +		goto out;
> +	}
> +	channel->lastidx = lastidx;
> +
> +	if (lastidx == 9)
> +		lastidx = 1;
> +	else
> +		lastidx++;
> +
> +	lastidx--;
> +
> +	reg = channel->regs.m_nYDmaAddrL + (lastidx * 6 * sizeof(u32));
> +	vid_pciaddr = vc_read32(reg);
> +
> +	reg = channel->regs.m_nYTSDmaAddrL + (lastidx * 2 * sizeof(u32));
> +	ts_pciaddr = vc_read32(reg);
> +
> +	dprintk(2, "%s() buf completed, reg=%x, vid_physical 0x%x\n",
> +		__func__, reg, vid_pciaddr);
> +	dprintk(2, "%s() ts_physical 0x%x, lastidx=%d\n",
> +		__func__, ts_pciaddr, lastidx);
> +
> +	/* Find the video buffer by address */
> +	buf = vc8x0_buffer_busy_get_by_address(channel,
> +		vid_pciaddr, TYPE_VIDEO);
> +	if (buf == 0) {
> +		dprintk(1, "%s() No busy video dma buffer for address 0x%x\n",
> +			__func__, vid_pciaddr);
> +		channel->buffers_bad_address++;
> +		goto badaddr;
> +	}
> +	buf->used_len = buflen;
> +
> +	/* Find the timestamp buffer by address */
> +	ts_buf = vc8x0_buffer_busy_get_by_address(channel,
> +		ts_pciaddr, TYPE_TIMESTAMP);
> +	if (ts_buf == 0) {
> +		dprintk(1,
> +		"%s() No busy timestamp dma buffer for address 0x%x\n",
> +			__func__, ts_pciaddr);
> +		channel->buffers_bad_address++;
> +		goto badaddr;
> +	}
> +	ts_buf->used_len = 0;
> +	dprintk(2, "%s() bufs completed vid %p nr=%d, ts %p nr=%d\n",
> +		__func__, buf, buf->nr, ts_buf, ts_buf->nr);
> +
> +	vc8x0_timestamp_validate(ts_buf, lastidx);
> +
> +	/* Put the buffer on the DPC list. This list is spinlock held very
> +	 * briefly so we're not going to be held up.
> +	 * The only person that holds the DPC spinlock is the deferred work
> +	 * queue. The only person that holds the busy spinlock is the
> +	 * interrupt handler.
> +	 * These spinlocks are also held briefly for reporting purposes in other
> +	 * parts of the driver but they are very timely.
> +	 */
> +	spin_lock_irqsave(&channel->dma_buffers_busy_lock, flags);
> +
> +	/* Last, put the buffer on the DPC list for our deferred
> +	 * worker to process */
> +	spin_lock_irqsave(&channel->dma_buffers_dpc_lock, flags);

How many locks are you using on those IRQ code? 3 locks? more?

I would try to rewrite the entire code to use just one, as otherwise,
you'll get dead locks.

> +	buf->state = STATE_DPC;
> +	list_move_tail(&buf->list, &channel->dma_buffers_dpc);
> +	spin_unlock_irqrestore(&channel->dma_buffers_dpc_lock, flags);
> +
> +	spin_unlock_irqrestore(&channel->dma_buffers_busy_lock, flags);
> +
> +	handled++;
> +badaddr:
> +	if (handled) {
> +		if (video_during_irq == 1) {
> +			/* Process video now, zero latency */
> +			vc8x0_video_work_handler(&channel->workhandler);
> +		} else {
> +			/* Process video via a deferred queue, with
> +			 * possible latencies */
> +			schedule_work(&channel->workhandler);
> +		}
> +	}
> +out:
> +	return handled;
> +}
> +


> +
> +static const struct v4l2_queryctrl no_ctl = {
> +	.name  = "42",
> +	.flags = V4L2_CTRL_FLAG_DISABLED,
> +};
> +
> +static struct vc8x0_ctrl vc8x0_ctls[] = {
> +	{
> +		.v = {
> +			.id            = V4L2_CID_BRIGHTNESS,
> +			.name          = "Brightness",
> +			.minimum       = -127,
> +			.maximum       = 128,
> +			.step          = 1,
> +			.default_value = 128,
> +			.type          = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}, {
> +		.v = {
> +			.id            = V4L2_CID_CONTRAST,
> +			.name          = "Contrast",
> +			.minimum       = 0,
> +			.maximum       = 255,
> +			.step          = 1,
> +			.default_value = 128,
> +			.type          = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}, {
> +		.v = {
> +			.id            = V4L2_CID_SATURATION,
> +			.name          = "Saturation",
> +			.minimum       = 0,
> +			.maximum       = 255,
> +			.step          = 1,
> +			.default_value = 128,
> +			.type          = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}, {
> +		.v = {
> +			.id            = V4L2_CID_HUE,
> +			.name          = "Hue",
> +			.minimum       = 0,
> +			.maximum       = 255,
> +			.step          = 1,
> +			.default_value = 0,
> +			.type          = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}, {
> +		.v = {
> +			.id            = V4L2_CID_AUDIO_MUTE,
> +			.name          = "Mute",
> +			.minimum       = 0,
> +			.maximum       = 1,
> +			.step          = 1,
> +			.default_value = 0,
> +			.type          = V4L2_CTRL_TYPE_BOOLEAN,
> +		},
> +	}, {
> +		.v = {
> +			.id            = V4L2_CID_AUDIO_VOLUME,
> +			.name          = "Volume",
> +			.minimum       = -4,
> +			.maximum       = 20,
> +			.step          = 1,
> +			.default_value = 5,
> +			.type          = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}
> +};
> +static const int VC8X0_CTLS = ARRAY_SIZE(vc8x0_ctls);
> +
> +/* Must be sorted from low to high control ID! */
> +static const u32 vc8x0_user_ctrls[] = {
> +	V4L2_CID_USER_CLASS,
> +	V4L2_CID_BRIGHTNESS,
> +	V4L2_CID_CONTRAST,
> +	V4L2_CID_SATURATION,
> +	V4L2_CID_HUE,
> +	V4L2_CID_AUDIO_VOLUME,
> +	V4L2_CID_AUDIO_MUTE,
> +	0
> +};
> +
> +static const u32 *ctrl_classes[] = {
> +	vc8x0_user_ctrls,
> +	NULL
> +};
> +
> +static int vc8x0_set_tvnorm(struct vc8x0_dma_channel *channel, v4l2_std_id norm)
> +{
> +	dprintk(1, "%s(norm = 0x%08x) name: [%s]\n",
> +		__func__,
> +		(unsigned int)norm,
> +		v4l2_norm_to_name(norm));
> +
> +	if (norm & V4L2_STD_ATSC)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +

> +static int vc8x0_ctrl_query(struct v4l2_queryctrl *qctrl)
> +{
> +	int i;
> +
> +	if (qctrl->id < V4L2_CID_BASE ||
> +	    qctrl->id >= V4L2_CID_LASTP1)
> +		return -EINVAL;
> +	for (i = 0; i < VC8X0_CTLS; i++)
> +		if (vc8x0_ctls[i].v.id == qctrl->id)
> +			break;
> +	if (i == VC8X0_CTLS) {
> +		*qctrl = no_ctl;
> +		return 0;
> +	}
> +	*qctrl = vc8x0_ctls[i].v;
> +	return 0;
> +}
> +




> +static int vidioc_enum_frameintervals(struct file *file, void *priv,
> +	struct v4l2_frmivalenum *f)
> +{
> +	struct vc8x0_fh *fh = priv;
> +	struct vc8x0_dma_channel *channel  = fh->channel;
> +	int framerates[4] = { 25, 30, 50, 60 };

You'll need to add some logic here to handle 60Hz and 59.97Hz difference.

> +
> +	dprintk(1, "%s(index=%d)\n", __func__, f->index);
> +
> +	if ((f->index < 0) || (f->index >= 4))
> +		return -EINVAL;
> +
> +	f->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +	f->discrete.numerator = 1;
> +	f->discrete.denominator = framerates[f->index];
> +
> +	dprintk(1, "%s(index=%d) rate = %d/%d\n", __func__, f->index,
> +		f->discrete.numerator, f->discrete.denominator);
> +
> +	return 0;
> +}
> +


> +
> +static int vc8x0_querymenu(struct file *file, void *priv,
> +	struct v4l2_querymenu *m)
> +{
> +	return -EINVAL;

I think v4l2-compliance will not like it. Had you validate this driver
with the compliance tool? Could you please post the results?

> +}
> +
> +static int vc8x0_g_priority(struct file *file, void *priv,
> +	enum v4l2_priority *p)
> +{
> +	return -EINVAL;

Priority is handled by the V4L framework. Please implement it.

> +}
> +
> +static int vc8x0_log_status(struct file *file, void *priv)
> +{
> +	struct vc8x0_dma_channel *channel = ((struct vc8x0_fh *)priv)->channel;
> +	struct vc8x0_dev *dev = channel->dev;
> +
> +	v4l2_subdev_call(channel->sd_adv7441a, core, log_status);
> +	v4l2_subdev_call(dev->dma_channel[DMA_CHANNEL9].sd_pcm3052,
> +		core, log_status);
> +
> +	return 0;
> +}

I think this is only available with advanced debug.

> +
> +static const struct v4l2_file_operations video_fops = {
> +	.owner	       = THIS_MODULE,
> +	.open	       = vc8x0_video_open,
> +	.release       = vc8x0_video_close,
> +	.read	       = vc8x0_video_read,
> +	.poll          = vc8x0_video_poll,
> +	.mmap	       = vc8x0_video_mmap,
> +	.unlocked_ioctl = video_ioctl2,
> +};
> +
> +static const struct v4l2_ioctl_ops video_ioctl_ops = {
> +	.vidioc_querycap      = vidioc_querycap,
> +	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid_cap,
> +	.vidioc_enum_frameintervals  = vidioc_enum_frameintervals,
> +	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap   = vc8x0_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
> +	.vidioc_reqbufs       = vidioc_reqbufs,
> +	.vidioc_querybuf      = vidioc_querybuf,
> +	.vidioc_qbuf          = vidioc_qbuf,
> +	.vidioc_dqbuf         = vidioc_dqbuf,
> +	.vidioc_s_std         = vc8x0_s_std,
> +	.vidioc_enum_input    = vidioc_enum_input,
> +	.vidioc_g_input       = vidioc_g_input,
> +	.vidioc_s_input       = vidioc_s_input,
> +	.vidioc_queryctrl     = vidioc_queryctrl,
> +	.vidioc_g_ctrl        = vidioc_g_ctrl,
> +	.vidioc_s_ctrl        = vidioc_s_ctrl,
> +	.vidioc_streamon      = vidioc_streamon,
> +	.vidioc_streamoff     = vidioc_streamoff,
> +	.vidioc_s_parm        = vc8x0_video_s_parm,
> +	.vidioc_g_parm        = vc8x0_video_g_parm,
> +/* Need this for VBI */
> +	.vidioc_g_fmt_vbi_cap   = vidioc_g_fmt_vbi_cap,
> +	.vidioc_g_std           = vc8x0_g_std,
> +	.vidioc_enumaudio	= vc8x0_g_audio,
> +	.vidioc_g_audio		= vc8x0_g_audio,
> +	.vidioc_s_audio		= vc8x0_s_audio,
> +	.vidioc_querymenu	= vc8x0_querymenu,
> +	.vidioc_g_priority	= vc8x0_g_priority,
> +	.vidioc_log_status	= vc8x0_log_status,

DV timings ioctl's are missing.

> +};
> +
> +static struct video_device vc8x0_vbi_template;
> +static struct video_device vc8x0_video_template = {
> +	.name		= "vc8x0-video",
> +	.fops		= &video_fops,
> +	.ioctl_ops	= &video_ioctl_ops,
> +#if 0
> +	/* If I set this to something valid then gstreamer fails
> +	 * to negotiate a reasonable std/fmt, but it fixes
> +	 * the v4l2 ATSC compliance test.
> +	 */
> +	.tvnorms	= V4L2_STD_NTSC_M,
> +#else
> +	/* We'll fail the ATSC compliance test but gstreamer will work. */
> +	.tvnorms	= 0,
> +#endif

That looks really weird. Ok, when HDMI is used, "NTSC" doesn't
make sense, but for the other inputs, it should be accepting it.


> +/* Enable this to enable bad register reads and verification */
> +#define ENABLE_BAD_READS 0
> +
> +/* Read 12 registers from the FPGA during interrupt handling */
> +#define ENABLE_MONITOR_REGISTERS 1
> +
> +/* ALSA adjustments */
> +#define ENABLE_ALSA 1
> +#define ENABLE_AUDIO_KEEPALIVE 1
> +#define ENABLE_AUDIO_DMA 1
> +#define ENABLE_ALSA_MIXER 1
> +#define ENABLE_ALSA_WORKAROUNDS 1

Oh... that defines appeared, finally! The best is to convert the
ones that actually make sense into CONFIG_foo, and maybe discarding
the others or convert them into debug stuff.

With that, I finished the review.

Please, next time you submit it, make sure to break the patch series
into something that makes easier for us to review. A big patch like
that is _really_ hard for review as, on the next step, I'll need to
re-read everything.

Thanks,
Mauro
