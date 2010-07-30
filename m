Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:55531 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390Ab0G3SuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 14:50:15 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] [PATCH 1/6] SoC Camera: add driver for OMAP1 camera interface
Date: Fri, 30 Jul 2010 20:49:05 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl> <201007180621.13347.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1007291043380.16266@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1007291043380.16266@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201007302049.09085.jkrzyszt@tis.icnet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Friday 30 July 2010 13:07:42 Guennadi Liakhovetski napisał(a):
> Hi Janusz
>
> Thanks once more for the patches, from your patches it is obvious, that
> you've spent quite a bit of time on them and you have not just copy-pasted
> various bits and pieces from other drivers, just filling your hardware
> details, but you also actually understand a lot of what is actually going
> on in there. So, I think, fixing remaining mostly minor issues shouldn't
> be too difficult for you either.

Hi Guennadi,
Thanks for your review time.
I only tried to get the driver really working, not only looking good ;).

> On Sun, 18 Jul 2010, Janusz Krzysztofik wrote:
> > This is a V4L2 driver for TI OMAP1 SoC camera interface.
> >
> > Two versions of the driver are provided, using either videobuf-dma-contig
> > or videobuf-dma-sg. The former uses less processing power, but often
> > fails to allocate contignuous buffer memory. The latter is free of this
> > problem, but generates tens of DMA interrupts per frame.
>
> Hm, would it be difficult to first try contig, and if it fails - fall back
> to sg?

Hmm, let me think about it.

> In its present state buffer management in your driver is pretty difficult
> to follow. At the VERY least you have to extensively document your buffer
> manipulations. Better yet clean it up. AFAIU, your "ready" pointer is
> pretty much unused in the contiguous case. Or you can easily get rid of
> it. 

I was sure the "ready" pointer was essential for both paths. However, things 
tend to change as more and more optimizations / cleanups are applied, so I 
have to verify it again.

> So, I think, a very welcome improvement to the driver would be a 
> cleaner separation between the two cases. Don't try that much to reuse the
> code as much as possible. Would be much better to have clean separation
> between the two implementations - whether dynamically switchable at
> runtime or at config time - would be best to separate the two
> implementations to the point, where each of them becomes understandable
> and maintainable.

You are right. My approach was probably more adequate at development time, 
when I was trying to aviod error-prone code duplication. As soon as both 
paths get stable, they can be split for better readability. I'll take care of 
this.

> So, I will do a pretty formal review this time and wait for v2. And in v2
> I'd like to at the very least see detailed buffer-management
> documentation, or - better yet - a rework with a clean separation.

OK.

...
> > --- linux-2.6.35-rc3.orig/include/media/omap1_camera.h	1970-01-01
> > 01:00:00.000000000 +0100
> > +++ linux-2.6.35-rc3/include/media/omap1_camera.h	2010-07-18
> > 01:31:57.000000000 +0200
> > @@ -0,0 +1,16 @@ 
>
> A copyright / licence header here, please

OK.

> > +#ifndef __MEDIA_OMAP1_CAMERA_H_
> > +#define __MEDIA_OMAP1_CAMERA_H_
> > +
> > +#define OMAP1_CAMERA_IOSIZE		0x1c
> > +
> > +struct omap1_cam_platform_data {
> > +	unsigned long camexclk_khz;
> > +	unsigned long lclk_khz_max;
> > +	unsigned long flags;
> > +};
> > +
> > +#define OMAP1_CAMERA_LCLK_RISING	BIT(0)
> > +#define OMAP1_CAMERA_RST_LOW		BIT(1)
> > +#define OMAP1_CAMERA_RST_HIGH		BIT(2)
>
> Then you need to #include <linux/bitops.h>

OK.
Since I always tend to optimise out redundant includes of header files that 
are otherwise included indirectly, please verify if there are more of them 
that you would prefere included explicitly.

> > +
> > +#endif /* __MEDIA_OMAP1_CAMERA_H_ */
> > --- linux-2.6.35-rc3.orig/drivers/media/video/Kconfig	2010-06-26
> > 15:55:29.000000000 +0200 +++
> > linux-2.6.35-rc3/drivers/media/video/Kconfig	2010-07-02
> > 04:12:02.000000000 +0200 @@ -962,6 +962,20 @@ config VIDEO_SH_MOBILE_CEU
> >  	---help---
> >  	  This is a v4l2 driver for the SuperH Mobile CEU Interface
> >
> > +config VIDEO_OMAP1
> > +	tristate "OMAP1 Camera Interface driver"
> > +	depends on VIDEO_DEV && ARCH_OMAP1 && SOC_CAMERA
> > +	select VIDEOBUF_DMA_CONTIG if !VIDEO_OMAP1_SG
> > +	---help---
> > +	  This is a v4l2 driver for the TI OMAP1 camera interface
> > +
> > +if VIDEO_OMAP1
>
> Don't think you need this "if," the "depends on" below should suffice.

OK.
My intention was to get it indented, and now I see it works like this even if 
not enclosed with if-endif.
Will drop the if-endif if the compile time SG option survives.

> > +config VIDEO_OMAP1_SG
> > +	bool "Scatter-gather mode"
> > +	depends on VIDEO_OMAP1 && EXPERIMENTAL
> > +	select VIDEOBUF_DMA_SG
> > +endif
> > +

...
> > +#ifndef CONFIG_VIDEO_OMAP1_SG
> > +#include <media/videobuf-dma-contig.h>
> > +#else
> > +#include <media/videobuf-dma-sg.h>
> > +#endif
>
> I think, you can just include both headers.

OK.

...
> > +#define CAM_EXCLK_6MHz		 6000000
> > +#define CAM_EXCLK_8MHz		 8000000
> > +#define CAM_EXCLK_9_6MHz	 9600000
> > +#define CAM_EXCLK_12MHz		12000000
> > +#define CAM_EXCLK_24MHz		24000000
>
> Why do you need this? Your platform specifies the EXCLK frequency directly
> in kHz, then you multiplly it by 1000 to get pcdev->camexclk in Hz, then
> you compare it to these macros. Don't think you need them - just use
> numbers directly.

OK.
My only reason for defines here was thees numbers being used more than once.

...
> > +/*
> > + * Structures
> > + */
> > +
> > +/* buffer for one video frame */
> > +struct omap1_cam_buf {
> > +	struct videobuf_buffer		vb;
> > +	enum v4l2_mbus_pixelcode	code;
> > +	int				inwork;
> > +#ifdef CONFIG_VIDEO_OMAP1_SG
> > +	struct scatterlist		*sgbuf;
> > +	int				sgcount;
> > +	int				bytes_left;
> > +	enum videobuf_state		result;
> > +#endif
> > +};
> > +
> > +struct omap1_cam_dev {
> > +	struct soc_camera_host		soc_host;
> > +	struct soc_camera_device	*icd;
> > +	struct clk			*clk;
> > +
> > +	unsigned int			irq;
> > +	void __iomem			*base;
> > +
> > +	int				dma_ch;
> > +
> > +	struct omap1_cam_platform_data	*pdata;
> > +	struct resource			*res;
> > +	unsigned long			pflags;
> > +	unsigned long			camexclk;
> > +
> > +	struct list_head		capture;
> > +
> > +	spinlock_t			lock;
> > +
> > +	/* Pointers to DMA buffers */
> > +	struct omap1_cam_buf		*active;
> > +	struct omap1_cam_buf		*ready;
>
> Well, I must confess, as it stands, you managed to confuse me with your
> "active" and "ready" buffer management. Is the reason for these two
> pointers some hardware feature? Maybe that while one buffer is being
> filled by DMA you can already configure the DMA engine with the next one?

Exactly. Both dma-contig and dma-sg paths relay on this hardware feature, 
making use of this "ready" pointing to a not yet active but already 
dma-preprogrammed videobuf.

> > +
> > +	u32			reg_cache[OMAP1_CAMERA_IOSIZE / sizeof(u32)];
>
> Don't think you'd lose much performance without cache, for that the code
> would become less error-prone.

The reason is my bad experience with my hardware audio interface. For my 
rationale regarding OMAP McBSP register caching, please look at this commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=96fbd74551e9cae8fd5e9cb62a0a19336a3064fa
or the foregoing discussions (links both to my initial and final submitions):
http://thread.gmane.org/gmane.linux.alsa.devel/65675
http://thread.gmane.org/gmane.linux.ports.arm.omap/29708

However, I haven't noticed any similiar flaws in camera interface yet, so if 
you think that caching would not be helpful in any possible future (context 
save/restore) enhancements here, then I can drop it.

> > +};
> > +
> > +
> > +void cam_write(struct omap1_cam_dev *pcdev, u16 reg, u32 val)
>
> static

Sure.

> > +{
> > +	pcdev->reg_cache[reg / sizeof(u32)] = val;
> > +	__raw_writel(val, pcdev->base + reg);
> > +}
> > +
> > +int cam_read(struct omap1_cam_dev *pcdev, u16 reg, bool from_cache)
>
> static u32

OK.

> > +{
> > +	return !from_cache ? __raw_readl(pcdev->base + reg) :
> > +			pcdev->reg_cache[reg / sizeof(u32)];
>
> hmmm.... it's never simple with caches;) Some registers (e.g., CTRLCLOCK)
> you read both from the cache and from the hardware directly. 

I read the CTRLCLOCK from the hardware in omap1_cam_add_device() for one 
reason: the cache is (can be) not initialized (written with the register 
copy) yet, and there are reserved bits that I'm trying to keep untouched.

The read from the hardware in omap1_cam_remove_device() is not intentional and 
should be replaced with cache read if we don't drop register caching.

Other than that, reads from cache are used throughout other functions, I 
believe.

> Don't you have to update the cache on a direct read?

If I do it unconditionally, I'd loose the read error prevention function of 
register caching idea.

> > +}
> > +
> > +#define CAM_READ(pcdev, reg) \
> > +		cam_read(pcdev, REG_##reg, 0)
>
> last parameter is a bool, so, use "false"

Right.

> > +#define CAM_WRITE(pcdev, reg, val) \
> > +		cam_write(pcdev, REG_##reg, val)
> > +#define CAM_READ_CACHE(pcdev, reg) \
> > +		cam_read(pcdev, REG_##reg, 1)
>
> "true"

Of course.

...
> > +static void start_capture(struct omap1_cam_dev *pcdev)
> > +{
> > +	struct omap1_cam_buf *buf = pcdev->active;
> > +	unsigned long ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
> > +	unsigned long mode = CAM_READ_CACHE(pcdev, MODE);
>
> I would make all variables, that are used specifically for various
> registers u32.

OK.

> > +
> > +	if (WARN_ON(!buf))
> > +		return;
> > +
> > +#ifndef CONFIG_VIDEO_OMAP1_SG
> > +	/* don't enable end of frame interrupts before capture autostart */
> > +	mode &= ~EN_V_DOWN;
> > +#endif
> > +	if (WARN_ON(mode & RAZ_FIFO))
> > +		/*  clean up possibly insane reset condition */
> > +		CAM_WRITE(pcdev, MODE, mode &= ~RAZ_FIFO);
>
> It is usually better to avoid assigning variables inside other constructs,
> please split into two lines. 

OK, I'll review and rearrange all similiar constructs.

> Besides, in omap1_cam_probe() you initialise 
> MODE to "THRESHOLD_LEVEL << THRESHOLD_SHIFT," i.e., RAZ_FIFO is cleared.
> So, don't think you need that test at all.

Right. What you think is better, drop it, or replace with BUG_ON(mode & 
RAZ_FIFO)?

...
> > +static void suspend_capture(struct omap1_cam_dev *pcdev)
> > +{
> > +	unsigned long ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
>
> u32

Yes.

> > +
> > +	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
> > +	omap_stop_dma(pcdev->dma_ch);
> > +}
> > +
> > +static void disable_capture(struct omap1_cam_dev *pcdev)
> > +{
> > +	unsigned long mode = CAM_READ_CACHE(pcdev, MODE);
>
> u32 (etc.)

Mmh.

...
> > +	dev_dbg(icd->dev.parent, "%s: capture not active, setup FIFO, start
> > DMA"
> > +			"\n", __func__); 
>
> No need to split "\n" to a new line, don't worry about > 80 characters...

OK, for this one and all similiar cases.

...
> > +static void videobuf_done(struct omap1_cam_dev *pcdev,
> > +		enum videobuf_state result)
> > +{
> > +	struct omap1_cam_buf *buf = pcdev->active;
> > +	struct videobuf_buffer *vb;
> > +	struct device *dev = pcdev->icd->dev.parent;
> > +
> > +	if (WARN_ON(!buf)) {
> > +		suspend_capture(pcdev);
> > +		disable_capture(pcdev);
> > +		return;
> > +	}
> > +
> > +	if (result == VIDEOBUF_ERROR)
> > +		suspend_capture(pcdev);
> > +
> > +	vb = &buf->vb;
> > +	if (waitqueue_active(&vb->done)) {
>
> I'm not sure this is a good idea. Why are you reusing the buffer, if noone
> is waiting for it _now_? It can well be, that the task is doing something
> else atm. Like processing the previous frame. Or it has been preempted by
> another process, before it called poll() or select() on your device?

I've introduced this way of videobuf handling after learning, form the 
Documentation/video4linux/videobuf, what the first step of filling a buffer 
should be:

"- Obtain the next available buffer and make sure that somebody is actually
   waiting for it."

Since I had no idea how I could implement it, I decided to do it a bit 
differently: start filling a buffer unconditionally, then drop its contents 
if not awaited by any user when done.

> > +		if (!pcdev->ready && result != VIDEOBUF_ERROR)
> > +			suspend_capture(pcdev);
> > +		vb->state = result;
> > +		do_gettimeofday(&vb->ts);
> > +		vb->field_count++;
>
> I don't think you're supposed to increment field_count if you've got a
> VIDEOBUF_ERROR.

OK, I'll correct it.

> > +		wake_up(&vb->done);
> > +
> > +		pcdev->active = buf = pcdev->ready;

Self comment: this construct occured to not satisfy "checkpatch --strict". I'm 
going to correct all similiar cases.

> > +		pcdev->ready = NULL;
> > +
> > +		if (!buf) {
> > +			result = VIDEOBUF_ERROR;
> > +			prepare_next_vb(pcdev);
> > +
> > +			pcdev->active = buf = pcdev->ready;
> > +			pcdev->ready = NULL;
> > +		}
> > +	} else if (pcdev->ready) {
> > +		dev_dbg(dev, "%s: nobody waiting on videobuf, swap with next\n",
> > +				__func__);
>
> Not sure this is a wise decision... If there are more buffers in the
> queue, they stay there waiting. Best remove this waitqueue_active() check
> entirely, just complete buffers and wake up the user regardless. If no
> more buffers - go to sleep.

If you think I don't have to follow the above mentioned requirement for not 
servicing a buffer unless someone is waiting for it, then yes, I'll drop 
these overcomplicated bits. Please confirm.

> > +		pcdev->active = pcdev->ready;
> > +#ifdef CONFIG_VIDEO_OMAP1_SG
> > +		buf->sgbuf = NULL;
> > +#endif
> > +		pcdev->ready = buf;
> > +
> > +		buf = pcdev->active;
> > +	} else {
> > +#ifndef CONFIG_VIDEO_OMAP1_SG
> > +		dev_dbg(dev, "%s: nobody waiting on videobuf, reuse it\n",
> > +				__func__);
> > +#else
> > +		if (result != VIDEOBUF_ERROR) {
> > +			suspend_capture(pcdev);
> > +			result = VIDEOBUF_ERROR;
> > +		}
> > +		prepare_next_vb(pcdev);
> > +#endif
> > +	}
> > +
> > +	if (!buf) {
> > +		dev_dbg(dev, "%s: no more videobufs, stop capture\n", __func__);
> > +		disable_capture(pcdev);
> > +		return;
> > +	}
> > +
> > +#ifdef CONFIG_VIDEO_OMAP1_SG
> > +	if (result == VIDEOBUF_ERROR)
> > +		buf->sgbuf = NULL;
> > +
> > +	try_next_sgbuf(pcdev->dma_ch, buf);
> > +#endif
> > +
> > +	if (result == VIDEOBUF_ERROR) {
> > +		dev_dbg(dev, "%s: videobuf error; reset FIFO, restart DMA\n",
> > +				__func__);
> > +		start_capture(pcdev);
> > +	}
>
> This all doesn't look quite right, but I'll wait for documentation, before
> commenting.

In short: in case of any error, I assume not being able to ensure that next 
frame still starts at next videobuf start, that's why I restart capture.

start_capture() doesn't actually start anything, only initializes it. After 
FIFO reset, the hardware stays idle until first frame start (as indicated by 
both VSYNC and HSYNC active), then starts filling its FIFO on LCLK edges 
selected with POLCLK and requesting DMA automatically every THRESHOLD_LEVEL 
words.

> > +
> > +	prepare_next_vb(pcdev);
> > +}
> > +
> > +static void dma_isr(int channel, unsigned short status, void *data)
> > +{
> > +	struct omap1_cam_dev *pcdev = data;
> > +	struct omap1_cam_buf *buf = pcdev->active;
> > +	enum videobuf_state result;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&pcdev->lock, flags);
> > +
> > +	if (WARN_ON(!buf)) {
> > +		suspend_capture(pcdev);
> > +		disable_capture(pcdev);
> > +		goto out;
> > +	}
> > +
> > +#ifndef CONFIG_VIDEO_OMAP1_SG
> > +	/* videobuf complete, disable end of frame interrupt for this frame */
> > +	CAM_WRITE(pcdev, MODE, CAM_READ_CACHE(pcdev, MODE) & ~EN_V_DOWN);
> > +	result = VIDEOBUF_DONE;
> > +#else
> > +	if (buf->sgbuf) {
> > +		/* current sglist not complete yet */
> > +		try_next_sgbuf(pcdev->dma_ch, buf);
> > +		if (buf->sgbuf)
> > +			goto out;
> > +
> > +		if (buf->result != VIDEOBUF_ERROR) {
> > +			buf = prepare_next_vb(pcdev);
> > +			if (!buf)
> > +				goto out;
> > +
> > +			try_next_sgbuf(pcdev->dma_ch, buf);
> > +			goto out;
> > +		}
> > +	}
> > +	/* end of videobuf */
> > +	result = buf->result;
> > +#endif
> > +	videobuf_done(pcdev, result);
> > +out:
> > +	spin_unlock_irqrestore(&pcdev->lock, flags);
> > +}
> > +
> > +static irqreturn_t cam_isr(int irq, void *data)
> > +{
> > +	struct omap1_cam_dev *pcdev = data;
> > +	struct device *dev = pcdev->icd->dev.parent;
> > +	struct omap1_cam_buf *buf = pcdev->active;
> > +	unsigned long it_status;
> > +	unsigned long flags;
> > +
> > +	it_status = CAM_READ(pcdev, IT_STATUS);
> > +	if (!it_status)
> > +		return IRQ_NONE;
> > +
> > +	spin_lock_irqsave(&pcdev->lock, flags);
> > +
> > +	if (WARN_ON(!buf)) {
> > +		suspend_capture(pcdev);
> > +		disable_capture(pcdev);
> > +		goto out;
> > +	}
> > +
> > +	if (unlikely(it_status & FIFO_FULL)) {
> > +		dev_warn(dev, "%s: FIFO overflow\n", __func__);
> > +
> > +	} else if (it_status & V_DOWN) {
> > +#ifdef CONFIG_VIDEO_OMAP1_SG
> > +		/*
> > +		 * if exactly 2 sgbufs of the next sglist has be used,
> > +		 * then we are in sync
> > +		 */
>
> You mean the hardware is supposed to interrupt you after 2 buffers?

No.
This interrupt occures on every frame end. By this moment, DMA, that is set up 
to restart automatically on every DMA block end, should already be waiting 
for first data to put into the first sgbuf area of the next sglist, pointed 
out by the DMA working registers, and the second sgbuf from this list should 
already be entered by the dma_isr() into the DMA programming registers, ready 
for DMA auto restart on current sgbuf (DMA block) end.

> > +		if (buf && buf->sgcount == 2)
> > +			goto out;
> > +#endif
> > +		dev_notice(dev, "%s: unexpected end of video frame\n",
> > +				__func__);
> > +
> > +#ifndef CONFIG_VIDEO_OMAP1_SG
> > +	} else if (it_status & V_UP) {
> > +		unsigned long mode = CAM_READ_CACHE(pcdev, MODE);
> > +
> > +		if (!(mode & EN_V_DOWN)) {
> > +			/* enable end of frame interrupt for current videobuf */
> > +			CAM_WRITE(pcdev, MODE, mode | EN_V_DOWN);
> > +		}
> > +		goto out;
> > +#endif
> > +
> > +	} else {
> > +		dev_warn(pcdev->soc_host.v4l2_dev.dev, "%s: "
> > +				"unhandled camera interrupt, status == 0x%lx\n",
> > +				__func__, it_status);
> > +		goto out;
> > +	}
> > +
> > +	videobuf_done(pcdev, VIDEOBUF_ERROR);
> > +out:
> > +	spin_unlock_irqrestore(&pcdev->lock, flags);
> > +	return IRQ_HANDLED;
> > +}

...
> > +static int omap1_cam_add_device(struct soc_camera_device *icd)
> > +{
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +	struct omap1_cam_dev *pcdev = ici->priv;
> > +	unsigned int ctrlclock;
>
> u32

Sure.

> > +	int ret = 0;
> > +
> > +	if (pcdev->icd) {
> > +		ret = -EBUSY;
> > +		goto ebusy;
> > +	}
> > +
> > +	clk_enable(pcdev->clk);
> > +
> > +	/* setup sensor clock */
> > +	ctrlclock = CAM_READ(pcdev, CTRLCLOCK);
> > +	ctrlclock &= ~(CAMEXCLK_EN | MCLK_EN | DPLL_EN);
> > +	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock);
> > +
> > +	ctrlclock &= ~FOSCMOD_MASK;
> > +	switch (pcdev->camexclk) {
> > +	case CAM_EXCLK_6MHz:
>
> just use constants for these

You mean numbers (6000000 in this case) instead of predifined symbols, don't 
you?

> > +		ctrlclock |= CAMEXCLK_EN | FOSCMOD_6MHz;
> > +		break;
> > +	case CAM_EXCLK_8MHz:
> > +		ctrlclock |= CAMEXCLK_EN | FOSCMOD_8MHz | DPLL_EN;
> > +		break;
> > +	case CAM_EXCLK_9_6MHz:
> > +		ctrlclock |= CAMEXCLK_EN | FOSCMOD_9_6MHz | DPLL_EN;
> > +		break;
> > +	case CAM_EXCLK_12MHz:
> > +		ctrlclock |= CAMEXCLK_EN | FOSCMOD_12MHz;
> > +		break;
> > +	case CAM_EXCLK_24MHz:
> > +		ctrlclock |= CAMEXCLK_EN | FOSCMOD_24MHz | DPLL_EN;
> > +	default:
>
> This is the case of "Not providing sensor clock," do you still have to
> enable the clock at all below (MCLK_EN)?

I'm not absolutely sure, but I think I had already tried without it and it 
looked like FIFO didn't work. Will recheck.

> > +		break;
> > +	}
> > +	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~DPLL_EN);
> > +
> > +	/* enable clock */
> > +	ctrlclock |= MCLK_EN;
> > +	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock);
> > +
> > +	sensor_reset(pcdev, 0);
>
> use "false" for the second parameter

OK.

...
> > +/* Duplicate standard formats based on host capability of byte swapping
> > */
> > +static const struct soc_mbus_pixelfmt omap1_cam_formats[] = { 
> > +	[V4L2_MBUS_FMT_YUYV8_2X8_BE] = {
>
> You'll have to adjust these to the new names. Basically, for all YUYV8 and
> YVYU8 codes, "_LE" just gets dropped, and for "_BE" you swap
> chrominance-luminance pairs, i.e., UYVY8_2X8 instead of YUYV8_2X8_BE and
> VYUY8_2X8 instead of YVYU8_2X8_BE.

OK.

...
> > +static int is_dma_aligned(s32 bytes_per_line, unsigned int height)
>
> make it a bool

OK.

> > +{
> > +	int size = bytes_per_line * height;
> > +
> > +	return IS_ALIGNED(bytes_per_line, DMA_ELEMENT_SIZE) &&
> > +			IS_ALIGNED(size, DMA_FRAME_SIZE * DMA_ELEMENT_SIZE);
> > +}
> > +
> > +static int dma_align(int *width, int *height,
> > +		const struct soc_mbus_pixelfmt *fmt, bool enlarge)
> > +{
> > +	s32 bytes_per_line = soc_mbus_bytes_per_line(*width, fmt);
> > +
> > +	if (bytes_per_line < 0)
> > +		return bytes_per_line;
> > +
> > +	if (!is_dma_aligned(bytes_per_line, *height)) {
> > +		unsigned int pxalign = __fls(bytes_per_line / *width);
> > +		unsigned int salign  =
> > +				DMA_FRAME_SHIFT + DMA_ELEMENT_SHIFT - pxalign;
> > +		unsigned int incr    = enlarge << salign;
> > +
> > +		v4l_bound_align_image(width, DMA_ELEMENT_SIZE >> pxalign,
> > +				*width + incr, DMA_ELEMENT_SHIFT - pxalign,
>
> The above means, that lines must consist of an integer number of DMA
> elements, right? Is this really necessary?

Perhaps not really :). I'll recheck and remove the constraint if not.

> > +				height, 1, *height + incr, 0, salign);
> > +		return 0;
> > +	}
> > +	return 1;
> > +}

...
> > +		dev_dbg(dev, "%s: g_crop() missing, trying cropcap() instead"
> > +				"\n", __func__);
>
> Put "\n" back in the string

OK.

...
> > +	*rect  = crop.c;
>
> superfluous space

Mhm.

...
> > +		dev_dbg(dev, "%s: g_mbus_fmt() missing, trying g_crop() instead"
> > +				"\n", __func__);
>
> Put "\n" back in the string

Yes.

> > +		ret = get_crop(icd, &c);
> > +		if (ret < 0)
> > +			return ret;
> > +		/* REVISIT:
> > +		 * Should cropcap() obtained defrect reflect last s_crop()?
> > +		 * Can we use it here for s_crop() result verification?
> > +		 */
>
> multiline comment style

Could be dropped completely if you know the answer and share it with me :).

> > +		if (ret) {
> > +			*rect = c;	/* use g_crop() result */
> > +		} else {
> > +			dev_warn(dev, "%s: current geometry not available\n",
> > +					__func__);
> > +			return 0;
> > +		}
> > +	} else if (ret < 0) {
> > +		return ret;
> > +	} else if (mf.code != code) {
> > +		return -EINVAL;
> > +	} else {
> > +		rect->width  = mf.width;
> > +		rect->height = mf.height;
> > +	}
> > +	return 1;
> > +}
> > +
> > +#define subdev_call_with_sense(ret, function, args...) \
> > +{ \
> > +	struct soc_camera_sense sense = { \
> > +		.master_clock		= pcdev->camexclk, \
> > +		.pixel_clock_max	= 0, \
> > +	}; \
> > +\
> > +	if (pcdev->pdata) \
> > +		sense.pixel_clock_max = pcdev->pdata->lclk_khz_max * 1000; \
> > +	icd->sense = &sense; \
> > +	*(ret) = v4l2_subdev_call(sd, video, function, ##args); \
> > +	icd->sense = NULL; \
> > +\
> > +	if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) { \
> > +		if (sense.pixel_clock > sense.pixel_clock_max) { \
> > +			dev_err(dev, "%s: " \
> > +				"pixel clock %lu set by the camera too high!" \
> > +				"\n", __func__, sense.pixel_clock); \
>
> "\n" back, please

Sure.

> > +			return -EIO; \
> > +		} \
> > +	} \
> > +}
>
> Ok, I'd prefer to follow some good-style rules here too. (1) please align
> your backslashes with TABs. (2) please, don't use implicitly passed
> variables, in this case "sd," "pcdev," "dev," and "icd." (3) since this is
> a macro, you don't need to pass ret as a pointer. (4) don't "return" from
> a macro - in your case it's enough to "ret = -EIO." Personally, I wouldn't
> worry about adding 4 more parameters to the macro. I would also remove
> "ret" from parameters and "return" it from the macro per
>
> #define subdev_call_with_sense(pcdev, dev, icd, sd, function, args...)	\
> ({									\
> 	int __ret;							\
> 	...								\
> 	__ret = v4l2_subdev_call(sd, video, function, ##args);		\
> 	...								\
> 			__ret = -EINVAL;				\
> 	...								\
> 	__ret;								\
> })

Thanks! :)

> > +
> > +static int omap1_cam_set_crop(struct soc_camera_device *icd,
> > +			       struct v4l2_crop *crop)
> > +{
> > +	struct v4l2_rect *rect = &crop->c;
> > +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +	struct omap1_cam_dev *pcdev = ici->priv;
> > +	struct device *dev = icd->dev.parent;
> > +	s32 bytes_per_line;
> > +	int ret;
> > +
> > +	ret = dma_align(&rect->width, &rect->height,
> > icd->current_fmt->host_fmt,
> > +			false); 
> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: failed to align %ux%u %s with DMA\n",
> > +				__func__, rect->width, rect->height,
> > +				icd->current_fmt->host_fmt->name);
> > +		return ret;
> > +	}
> > +
> > +	subdev_call_with_sense(&ret, s_crop, crop);
> > +	if (ret < 0) {
> > +		dev_warn(dev, "%s: failed to crop to %ux%u@%u:%u\n", __func__,
> > +			 rect->width, rect->height, rect->left, rect->top);
> > +		return ret;
> > +	}
> > +
> > +	ret = get_geometry(icd, rect, icd->current_fmt->code);
> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: get_geometry() failed\n", __func__);
> > +		return ret;
> > +	}
> > +	if (!ret) {
> > +		dev_warn(dev, "%s: unable to verify s_crop() results\n",
> > +				__func__);
> > +	}
>
> Superfluous braces

Yes.

> > +
> > +	bytes_per_line = soc_mbus_bytes_per_line(rect->width,
> > +			icd->current_fmt->host_fmt);
> > +	if (bytes_per_line < 0) {
> > +		dev_err(dev, "%s: soc_mbus_bytes_per_line() failed\n",
> > +				__func__);
> > +		return bytes_per_line;
> > +	}
> > +
> > +	ret = is_dma_aligned(bytes_per_line, rect->height);
> > +	if (ret < 0) {
>
> Doesn't look like this is possible.

It was once :/. I'll correct it.

> > +		dev_err(dev, "%s: is_dma_aligned() failed\n", __func__);
> > +		return ret;
> > +	}
> > +	if (!ret) {
> > +		dev_err(dev, "%s: resulting geometry %dx%d not DMA aligned\n",
> > +				__func__, rect->width, rect->height);
> > +		return -EINVAL;
> > +	}
> > +
> > +	icd->user_width	 = rect->width;
> > +	icd->user_height = rect->height;
>
> No, this is wrong. user_width and user_height are _user_ sizes, i.e., a
> result sensor cropping and scaling and host cropping and scaling. Whereas
> set_crop sets sensor input rectangle.

I'm not sure if I understand what you mean. Should I drop these assignments? 
Or correct them? If yes, how they should be calculated?

In Documentation/video4linux/soc-camera.txt, you say:
"The core updates these fields upon successful completion of a .s_fmt() call, 
but if these fields change elsewhere, e.g., during .s_crop() processing, the 
host driver is responsible for updating them."

I thought this is the case we're dealing with here.

> > +
> > +	return ret;
> > +}
> > +
> > +static int omap1_cam_set_fmt(struct soc_camera_device *icd,
> > +			      struct v4l2_format *f)
> > +{
> > +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > +	const struct soc_camera_format_xlate *xlate;
> > +	struct device *dev = icd->dev.parent;
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +	struct omap1_cam_dev *pcdev = ici->priv;
> > +	struct v4l2_pix_format *pix = &f->fmt.pix;
> > +	struct v4l2_mbus_framefmt mf;
> > +	struct v4l2_crop crop;
> > +	struct v4l2_rect *rect = &crop.c;
> > +	int bytes_per_line;
> > +	int ret;
> > +
> > +	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
> > +	if (!xlate) {
> > +		dev_warn(dev, "%s: format %x not found\n", __func__,
> > +				pix->pixelformat);
> > +		return -EINVAL;
> > +	}
> > +
> > +	bytes_per_line = soc_mbus_bytes_per_line(pix->width, xlate->host_fmt);
> > +	if (bytes_per_line < 0) {
> > +		dev_err(dev, "%s: soc_mbus_bytes_per_line() failed\n",
> > +				__func__);
> > +		return bytes_per_line;
> > +	}
> > +	if (pix->bytesperline && pix->bytesperline != bytes_per_line) {
> > +		dev_err(dev, "%s: bytes per line mismatch\n", __func__);
> > +		return -EINVAL;
> > +	}
> > +	ret = is_dma_aligned(bytes_per_line, pix->height);
> > +	if (ret < 0) {
>
> ditto - that's just a bool.

Sure.

> > +		dev_err(dev, "%s: is_dma_aligned() failed\n", __func__);
> > +		return ret;
> > +	}
> > +	if (!ret) {
> > +		dev_err(dev, "%s: image size %dx%d not DMA aligned\n",
> > +				__func__, pix->width, pix->height);
> > +		return -EINVAL;
> > +	}
> > +
> > +	mf.width	= pix->width;
> > +	mf.height	= pix->height;
> > +	mf.field	= pix->field;
> > +	mf.colorspace	= pix->colorspace;
> > +	mf.code		= xlate->code;
> > +
> > +	subdev_call_with_sense(&ret, s_mbus_fmt, &mf);
> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: failed to set format\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	if (mf.code != xlate->code) {
> > +		dev_err(dev, "%s: unexpected pixel code change\n", __func__);
> > +		return -EINVAL;
> > +	}
> > +	icd->current_fmt = xlate;
> > +
> > +	pix->field	= mf.field;
> > +	pix->colorspace	= mf.colorspace;
> > +
> > +	if (mf.width == pix->width && mf.height == pix->height)
> > +		return 0;
> > +
> > +	dev_notice(dev, "%s: sensor geometry differs, trying to crop to %dx%d"
> > +			"\n", __func__, pix->width, pix->height);
>
> No, you shouldn't do this. It is normal, when S_FMT sets a format
> different from what the user has requested. Just leave it as is, only 
> adjust if you cannot handle it or fail. 

With my, maybe weird, try_fmt() implementation, I think I can be sure here 
that the geometry is not DMA aligned, unless a user can request a different 
geometry than she obtained from try_fmt(), that I assumed should not happen. 
Please see below for more exhausitve explanation.

> > +	crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +	ret = get_crop(icd, rect);
> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: get_crop() failed\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	rect->width  = pix->width;
> > +	rect->height = pix->height;
> > +
> > +	subdev_call_with_sense(&ret, s_crop, &crop);
> > +	if (ret < 0) {
> > +		dev_warn(dev, "%s: failed to crop to %ux%u@%u:%u\n", __func__,
> > +			 rect->width, rect->height, rect->left, rect->top);
> > +		return ret;
> > +	}
> > +
> > +	ret = get_geometry(icd, rect, xlate->code);
> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: get_geometry() failed\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	if (!ret) {
> > +		dev_warn(dev, "%s: s_crop() results not verified\n", __func__);
> > +		return 0;
> > +	}
> > +
> > +	if (pix->width != rect->width || pix->height != rect->height) {
> > +		dev_err(dev, "%s: tried to set %dx%d, got %dx%d\n", __func__,
> > +				pix->width, pix->height,
> > +				rect->width, rect->height);
> > +		return -EINVAL;
> > +	}
>
> No, that's not an error. Just use whatever you managed to configure.

Let me explain and maybe reimplement correctly my try_fmt() first :).

> > +	return 0;
> > +}
> > +
> > +static int omap1_cam_try_fmt(struct soc_camera_device *icd,
> > +			      struct v4l2_format *f)
> > +{
> > +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > +	const struct soc_camera_format_xlate *xlate;
> > +	struct device *dev = icd->dev.parent;
> > +	struct v4l2_pix_format *pix = &f->fmt.pix;
> > +	struct v4l2_mbus_framefmt mf, testmf;
> > +	const struct soc_mbus_pixelfmt *fmt;
> > +	int ret;
> > +
> > +	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
> > +	if (!xlate) {
> > +		dev_warn(dev, "%s: format %x not found\n", __func__,
> > +				pix->pixelformat);
> > +		return -EINVAL;
> > +	}
> > +
> > +	fmt = xlate->host_fmt;
> > +	ret = dma_align(&pix->width, &pix->height, fmt, true);
> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: failed to align %ux%u %s with DMA\n",
> > +				__func__, pix->width, pix->height, fmt->name);
> > +		return ret;
> > +	}
> > +
> > +	mf.width      = pix->width;
> > +	mf.height     = pix->height;
> > +	mf.field      = pix->field;
> > +	mf.colorspace = pix->colorspace;
> > +	mf.code	      = xlate->code;
> > +
> > +	/* limit to sensor capabilities */
> > +	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: try_mbus_fmt() failed\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	pix->field	= mf.field;
> > +	pix->colorspace	= mf.colorspace;
> > +
> > +	if (mf.width == pix->width && mf.height == pix->height &&
> > +			mf.code == xlate->code)
> > +		return 0;
> > +
> > +	dev_dbg(dev, "%s: geometry changed, recheck alignment\n", __func__);
> > +	pix->width	  = mf.width;
> > +	pix->height	  = mf.height;
>
> This is what the sensor has returned, you put it back into the user frmat.

I hope it's OK.

> > +
> > +	fmt = soc_mbus_get_fmtdesc(mf.code);
> > +	ret = dma_align(&pix->width, &pix->height, fmt, false);
>
> And you DMA-align those sizes.

Shouldn't I?

> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: failed to align %ux%u %s with DMA\n",
> > +				__func__, pix->width, pix->height, fmt->name);
> > +		return ret;
> > +	}
> > +	if (ret)
> > +		return 0;

Maybe the above is not clear enough: ret == 1 means that what we got from the 
sensor is already aligned. If not, we keep processing.

> > +
> > +	testmf.width	  = pix->width;
> > +	testmf.height	  = pix->height;
>
> And use them again for try_fmt

Yes.
For rationale, please see my explanation below.

> > +	testmf.field	  = mf.field;
> > +	testmf.colorspace = mf.colorspace;
> > +	testmf.code	  = mf.code;
> > +
> > +	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &testmf);
> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: try_mbus_fmt() failed\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	if (testmf.code != mf.code || testmf.width != mf.width ||
> > +			testmf.height != mf.height) {
> > +		dev_err(dev, "%s: sensor format inconsistency, giving up\n",
> > +				__func__);
> > +		return -EINVAL;
>
> As a general rule, try_fmt shouldn't fail... Only in very weird cases,
> really.

Not being able to negotiate a DMA aligned geometry with the sensor - would it 
be weird enough?

> > +	}
>
> And you verified, the sensor kept them.

The sensor kept previously returend (not aligned) values (stored in mf), not 
those DMA aligned (stored under pix).

> > +	dev_notice(dev, "%s: "
> > +		"sensor frame not DMA aligned, will try to crop from set_fmt()"
>
> Hm? You did align them above? /me confused...

Let me explain how it is all supposed to work:

try_fmt():
1. DMA align a user requested frame geometry.
2. Let the sensor adjust it to its capabilities.
3. If the sensor didn't change the (DMA aligned) geometry, we are done.
4. Otherwise, DMA align it again.
5. If no DMA alignment was necessary on the sensor proposed geometry, we are 
   done as well.
6. Otherwise, check if we still get the same (not aligned) geometry from the 
   sensor if now asking for its DMA alignment result.
7. If the now returned sensor geometry is different from what we got before, 
   we can either restart from 3 (how many iterations?) or fail, I believe.
8. Otherwise, we can accept the sensor geometry that is not DMA aligned, but 
   should return the DMA aligned one, not the sensor provided. We believe to 
   crop the sensor geometry to DMA aligned one during S_FMT.

set_fmt():
1. Since we always return DMA aligned geometry from try_fmt(), expecting it 
   being accepted by a user, we start from checking if what user have 
   requested now is DMA aligned or not.
2. If not DMA aligned, we fail.
   Should we be more polite and try to do our best to accept a geometry that 
   differs from what our try_fmt() could ever return?
3. If DMA aligned, then OK, let the sensor adjust it to its capabilities.
4. If the sensor didn't change the (DMA aligned) geometry, we are done.
5. Otherwise, we assume the sensor returned geometry is not DMA aligned (if it 
   were, we would accept it during try_fmt() before), so it has to be cropped.
   Should we rather retry with S_FMT instead of cropping?
6. If crop gives the geometry requested, we are done.
7. Otherwise, we fail.
   Should we be more cooperative here and accept any valid (ie. DMA aligned) 
   crop result?

> > +		"\n", __func__);
> > +
> > +	return 0;
> > +}

...
> > +	/* apply reset to camera sensor if requested by platform data */
> > +	if (pcdev->pflags & OMAP1_CAMERA_RST_HIGH)
> > +		CAM_WRITE(pcdev, GPIO, 0x1);
> > +	else if (pcdev->pflags & OMAP1_CAMERA_RST_LOW)
> > +		CAM_WRITE(pcdev, GPIO, 0x0);
>
> Why not use sensor_reset()?

Why not... ;)

...
> > +static int __exit omap1_cam_remove(struct platform_device *pdev)
> > +{
> > +	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
> > +	struct omap1_cam_dev *pcdev = container_of(soc_host,
> > +					struct omap1_cam_dev, soc_host);
> > +	struct resource *res;
> > +
> > +	soc_camera_host_unregister(soc_host);
> > +
> > +	free_irq(pcdev->irq, pcdev);
> > +
> > +	omap_free_dma(pcdev->dma_ch);
>
> It is probably safer to first shut down the hardware, and only then
> unconfigure software. So, free_irq and free_dma should go first, I think.

OK.

Thanks,
Janusz
