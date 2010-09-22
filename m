Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:34417 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab0IVSOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 14:14:52 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 1/6] SoC Camera: add driver for OMAP1 camera interface
Date: Wed, 22 Sep 2010 20:13:56 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl> <201009110321.25852.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1009211639410.11896@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1009211639410.11896@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201009222013.58035.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Wednesday 22 September 2010 01:23:22 Guennadi Liakhovetski napisał(a):
> On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:
> > This is a V4L2 driver for TI OMAP1 SoC camera interface.
> >
> > Both videobuf-dma versions are supported, contig and sg, selectable with
> > a module option. The former uses less processing power, but often fails
> > to allocate contignuous buffer memory. The latter is free of this
> > problem, but generates tens of DMA interrupts per frame. If contig memory
> > allocation ever fails, the driver falls back to sg automatically on next
> > open, but still can be switched back to contig manually. Both paths work
> > stable for me, even under heavy load, on my OMAP1510 based Amstrad Delta
> > videophone, that is the oldest, least powerfull OMAP1 implementation.
> >
> > The interface generally works in pass-through mode. Since input data byte
> > endianess can be swapped, it provides up to two v4l2 pixel formats per
> > each of several soc_mbus formats that have their swapped endian
> > counterparts.
> >
> > Boards using this driver can provide it with the followning information:
> > - if and what freqency clock is expected by an on-board camera sensor,
> > - what is the maximum pixel clock that should be accepted from the
> > sensor, - what is the polarity of the sensor provided pixel clock,
> > - if the interface GPIO line is connected to a sensor reset/powerdown
> > input and what is the input polarity.
> >
> > Created and tested against linux-2.6.36-rc3 on Amstrad Delta.
> >
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > ---
> >
> > Friday 30 July 2010 13:07:42 Guennadi Liakhovetski wrote:
> > > So, I think, a very welcome improvement to the driver would be a
> > > cleaner separation between the two cases. Don't try that much to reuse
> > > the code as much as possible. Would be much better to have clean
> > > separation between the two implementations - whether dynamically
> > > switchable at runtime or at config time - would be best to separate the
> > > two
> > > implementations to the point, where each of them becomes understandable
> > > and maintainable.
> >
> > Guennadi,
> > I've tried to rearrange them spearated, as you requested, but finally
> > decided to keep them together, as before, only better documented and
> > cleaned up as much as possible. I'm rather satisfied with the result, but
> > if you think it is still not enough understandable and maintainable, I'll
> > take one more iteration and split both paths.
>
> Well, I think, I'll move a bit towards the "if it breaks - someone gets to
> fix it, or it gets dropped" policy, i.e., I'll give you more freedom
> (don't know what's wrong with me today;))

Hi Guennadi,
Thanks!

...
> > +#define DMA_FRAME_SHIFT(x)	(x ? DMA_FRAME_SHIFT_SG : \
> > +						DMA_FRAME_SHIFT_CONTIG)
>
> Don't you want to compare (x) against CONTIG and you want to put x in
> parenthesis in the DMA_FRAME_SHIFT macro. 

Sure.

> Besides, CONTIG and SG are not 
> good enough names to be defined in a header under include/... Looks like
> you don't need them at all in the header? You only use them in this file,
> so, just move them inside.

Please see my very last comment below.

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
> > +		if (!pcdev->ready && result != VIDEOBUF_ERROR)
> > +			/*
> > +			 * No next buffer has been entered into the DMA
> > +			 * programming register set on time, so best we can do
> > +			 * is stopping the capture before last DMA block,
> > +			 * whether our CONTIG mode whole buffer or its last
> > +			 * sgbuf in SG mode, gets overwritten by next frame.
> > +			 */
>
> Hm, why do you think it's a good idea? This specific buffer completed
> successfully, but you want to fail it just because the next buffer is
> missing? Any specific reason for this? 

Maybe my comment is not clear enough, but the below suspend_capture() doesn't 
indicate any failure on a frame just captured. It only prevents the frame 
from being overwritten by the already autoreinitialized DMA engine, pointing 
back to the same buffer once again.

> Besides, you seem to also be 
> considering the possibility of your ->ready == NULL, but the queue
> non-empty, in which case you just take the next buffer from the queue and
> continue with it. Why error out in this case? 

pcdev->ready == NULL means no buffer was available when it was time to put it 
into the DMA programming register set. As a result, a next DMA transfer has 
just been autoreinitialized with the same buffer parameters as before. To 
protect the buffer from being overwriten unintentionally, we have to stop the 
DMA transfer as soon as possible, hopefully before the sensor starts sending 
out next frame data.

If a new buffer has been queued meanwhile, best we can do is stopping 
everything, programming the DMA with the new buffer, and setting up for a new 
transfer hardware auto startup on nearest frame start, be it the next one if 
we are lucky enough, or one after the next if we are too slow.

> And even if also the queue 
> is empty - still not sure, why.

I hope the above explanation clarifies why.

I'll try to rework the above comment to be more clear, OK? Any hints?

> > +			suspend_capture(pcdev);
> > +		vb->state = result;
> > +		do_gettimeofday(&vb->ts);
> > +		if (result != VIDEOBUF_ERROR)
> > +			vb->field_count++;
> > +		wake_up(&vb->done);
> > +
> > +		/* shift in next buffer */
> > +		buf = pcdev->ready;
> > +		pcdev->active = buf;
> > +		pcdev->ready = NULL;
> > +
> > +		if (!buf) {
> > +			/*
> > +			 * No next buffer was ready on time (see above), so
> > +			 * indicate error condition to force capture restart or
> > +			 * stop, depending on next buffer already queued or not.
> > +			 */
> > +			result = VIDEOBUF_ERROR;
> > +			prepare_next_vb(pcdev);
> > +
> > +			buf = pcdev->ready;
> > +			pcdev->active = buf;
> > +			pcdev->ready = NULL;
> > +		}
> > +	} else if (pcdev->ready) {
> > +		/*
> > +		 * In both CONTIG and SG mode, the DMA engine has (might)
>
> s/might/possibly/

OK

> > +		 * already been autoreinitialized with the preprogrammed
> > +		 * pcdev->ready buffer.  We can either accept this fact
> > +		 * and just swap the buffers, or provoke an error condition
> > +		 * and restart capture.  The former seems less intrusive.
> > +		 */
> > +		dev_dbg(dev, "%s: nobody waiting on videobuf, swap with next\n",
> > +				__func__);
> > +		pcdev->active = pcdev->ready;
> > +
> > +		if (pcdev->vb_mode == SG) {
> > +			/*
> > +			 * In SG mode, we have to make sure that the buffer we
> > +			 * are putting back into the pcdev->ready is marked
> > +			 * fresh.
> > +			 */
> > +			buf->sgbuf = NULL;
> > +		}
> > +		pcdev->ready = buf;
> > +
> > +		buf = pcdev->active;
> > +	} else {
> > +		/*
> > +		 * No next buffer has been entered into
> > +		 * the DMA programming register set on time.
> > +		 */
> > +		if (pcdev->vb_mode == CONTIG) {
> > +			/*
> > +			 * In CONTIG mode, the DMA engine has already been
> > +			 * reinitialized with the current buffer. Best we can do
> > +			 * is not touching it.
> > +			 */
> > +			dev_dbg(dev,
> > +				"%s: nobody waiting on videobuf, reuse it\n",
> > +				__func__);
> > +		} else {
> > +			/*
> > +			 * In SG mode, the DMA engine has just been
> > +			 * autoreinitialized with the last sgbuf from the
> > +			 * current list. Restart capture in order to transfer
> > +			 * next frame start into the first sgbuf, not the last
> > +			 * one.
> > +			 */
> > +			if (result != VIDEOBUF_ERROR) {
> > +				suspend_capture(pcdev);
> > +				result = VIDEOBUF_ERROR;
> > +			}
> > +		}
> > +	}
> > +
> > +	if (!buf) {
> > +		dev_dbg(dev, "%s: no more videobufs, stop capture\n", __func__);
> > +		disable_capture(pcdev);
> > +		return;
> > +	}
> > +
> > +	if (pcdev->vb_mode == CONTIG) {
> > +		/*
> > +		 * In CONTIG mode, the current buffer parameters had already
> > +		 * been entered into the DMA programming register set while the
> > +		 * buffer was fetched with prepare_next_vb(), they may have also
> > +		 * been transfered into the runtime set and already active if
> > +		 * the DMA still running.
> > +		 */
> > +	} else {
> > +		/* In SG mode, extra steps are required */
> > +		if (result == VIDEOBUF_ERROR)
> > +			/* make sure we (re)use sglist from start on error */
> > +			buf->sgbuf = NULL;
> > +
> > +		/*
> > +		 * In any case, enter the next sgbuf parameters into the DMA
> > +		 * programming register set.  They will be used either during
> > +		 * nearest DMA autoreinitialization or, in case of an error,
> > +		 * on DMA startup below.
> > +		 */
> > +		try_next_sgbuf(pcdev->dma_ch, buf);
> > +	}
> > +
> > +	if (result == VIDEOBUF_ERROR) {
> > +		dev_dbg(dev, "%s: videobuf error; reset FIFO, restart DMA\n",
> > +				__func__);
> > +		start_capture(pcdev);
> > +		/*
> > +		 * In SG mode, the above also resulted in the next sgbuf
> > +		 * parameters being entered into the DMA programming register
> > +		 * set, making them ready for next DMA autoreinitialization.
> > +		 */
> > +	}
> > +
> > +	/*
> > +	 * Finally, try fetching next buffer.  In CONTIG mode, it will also
> > +	 * get entered it into the DMA programming register set,
>
> s/get entered/enter/

OK.

> > +	 * making it ready for next DMA autoreinitialization.
> > +	 */
> > +	prepare_next_vb(pcdev);
> > +}
> > +
> > +static void dma_isr(int channel, unsigned short status, void *data)
> > +{
> > +	struct omap1_cam_dev *pcdev = data;
> > +	struct omap1_cam_buf *buf = pcdev->active;
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
> > +	if (pcdev->vb_mode == CONTIG) {
> > +		/*
> > +		 * In CONTIG mode, assume we have just managed to collect the
> > +		 * whole frame, hopefully before our end of frame watchdog is
> > +		 * triggered. Then, all we have to do is disabling the watchdog
> > +		 * for this frame, and calling videobuf_done() with success
> > +		 * indicated.
> > +		 */
> > +		CAM_WRITE(pcdev, MODE,
> > +				CAM_READ_CACHE(pcdev, MODE) & ~EN_V_DOWN);
> > +		videobuf_done(pcdev, VIDEOBUF_DONE);
> > +	} else {
> > +		/*
> > +		 * In SG mode, we have to process every sgbuf from the current
> > +		 * sglist, one after another.
> > +		 */
> > +		if (buf->sgbuf) {
> > +			/*
> > +			 * Current sglist not completed yet, try fetching next
> > +			 * sgbuf, hopefully putting it into the DMA programming
> > +			 * register set, making it ready for next DMA
> > +			 * autoreinitialization.
> > +			 */
> > +			try_next_sgbuf(pcdev->dma_ch, buf);
> > +			if (buf->sgbuf)
> > +				goto out;
> > +
> > +			/* no more sgbufs in the current sglist */
> > +			if (buf->result != VIDEOBUF_ERROR) {
> > +				/*
> > +				 * Video frame collected without errors, we can
> > +				 * prepare for collecting a next one as soon as
> > +				 * DMA gets autoreinitialized after the currennt
> > +				 * (last) sgbuf is completed.
> > +				 */
> > +				buf = prepare_next_vb(pcdev);
> > +				if (!buf)
> > +					goto out;
> > +
> > +				try_next_sgbuf(pcdev->dma_ch, buf);
> > +				goto out;
>
> Uh, sorry, maybe I cannot quite follow the logic here, but it doesn't seem
> quite correct to me. Looks like you do not complete the current
> (successfully completed) buffer, if you failed to prepare the next one?

Looks like there is also some space for improvement in my documentation here.

In short, until the DMA ISR is called with the buf->sgbuf reset back to NULL, 
which should happen while the previous DMA ISR's called try_next_sgbuf() has 
retuned NULL, the frame is still not ready, ie. still being filled with DMA. 
IOW, only the DMA interrupt with buf->sgbuf == NULL means that the last sgbuf 
DMA transfer has just been completed.

Meanwhile, a next sglist could already be put in advanvce into the DMA 
programming register set and just activated (copied to the DMA working 
register set) automatically.

> > +			}
> > +		}
> > +		/* end of videobuf */
> > +		videobuf_done(pcdev, buf->result);
> > +	}
> > +
> > +out:
> > +	spin_unlock_irqrestore(&pcdev->lock, flags);
> > +}

...
> > +				 * If exactly 2 sgbufs from the next sglist has
>
> s/has/have/

Thanks.

...
> > +		dev_warn(dev, "%s: unhandled camera interrupt, status == "
> > +				"0x%0x\n", __func__, it_status);
>
> Please, don't split strings

OK.

...
> > +static int omap1_cam_add_device(struct soc_camera_device *icd)
> > +{
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +	struct omap1_cam_dev *pcdev = ici->priv;
> > +	u32 ctrlclock;
> > +
> > +	if (pcdev->icd)
> > +		return -EBUSY;
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
> > +	case 6000000:
> > +		ctrlclock |= CAMEXCLK_EN | FOSCMOD_6MHz;
> > +		break;
> > +	case 8000000:
> > +		ctrlclock |= CAMEXCLK_EN | FOSCMOD_8MHz | DPLL_EN;
> > +		break;
> > +	case 9600000:
> > +		ctrlclock |= CAMEXCLK_EN | FOSCMOD_9_6MHz | DPLL_EN;
> > +		break;
> > +	case 12000000:
> > +		ctrlclock |= CAMEXCLK_EN | FOSCMOD_12MHz;
> > +		break;
> > +	case 24000000:
> > +		ctrlclock |= CAMEXCLK_EN | FOSCMOD_24MHz | DPLL_EN;
> > +	default:
>
> This default doesn't make much sense here, maybe put it to one of these
> values, that you think is a reasonable fall back. Ah, right, you wanted to
> check, whether this can work...

Sorry, I forgot to answer your previously asked question about the MCLK_EN 
(master clock enable) requirement if not rising the CAMEXCLK_EN (sensor clock 
enable).

The documentation (http://focus.ti.com/lit/ug/spru684/spru684.pdf) says:

	"the MCLK_EN bit must first be set before any camera-interface registers 
	 access"

so the answer is yes, the MCLK is required not only for providing a sensor 
with a clock, but also for the host interface itself to do its job.

The default case above (no CAMEXCLK_EN) is intended to be used on a board 
whith a sensor that is driven from a clock source other than the interface's 
CAM_EXCLK pin, which is keept idle in this case. Am I missing something?

My general assumption was to provide support for all interface hardware 
features which are supported by the existing soc_camera framework, not only 
those required by my board or sensor. Could it be that this approach breaks a 
general rule of not putting any code that is not (yet) used by any consumer?

> > +		break;
> > +	}
> > +	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~DPLL_EN);
> > +
> > +	/* enable internal clock */
> > +	ctrlclock |= MCLK_EN;
> > +	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock);
> > +
> > +	sensor_reset(pcdev, false);
> > +
> > +	pcdev->icd = icd;
> > +
> > +	dev_info(icd->dev.parent, "OMAP1 Camera driver attached to camera
> > %d\n", +			icd->devnum);
> > +	return 0;
> > +}

...
> > +	ret = dma_align(&rect->width, &rect->height,
> > icd->current_fmt->host_fmt, +			false);
> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: failed to align %ux%u %s with DMA\n",
> > +				__func__, rect->width, rect->height,
> > +				icd->current_fmt->host_fmt->name);
> > +		return ret;
> > +	}
> > +
> > +	subdev_call_with_sense(pcdev, dev, icd, sd, s_crop, crop);
>
> Missing "ret = "?

Yes, thanks!

> > +	if (ret < 0) {
> > +		dev_warn(dev, "%s: failed to crop to %ux%u@%u:%u\n", __func__,
> > +			 rect->width, rect->height, rect->left, rect->top);
> > +		return ret;
> > +	}

...
> > +	dev_notice(dev, "%s: sensor geometry not DMA aligned, trying to crop
> > to" +			" %ux%u\n", __func__, pix->width, pix->height);
>
> One line

OK.

> > +	ret = get_crop(icd, rect);
> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: get_crop() failed\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	rect->width  = pix->width;
> > +	rect->height = pix->height;
> > +
> > +	crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +	subdev_call_with_sense(pcdev, dev, icd, sd, s_crop, &crop);
>
> 'ret = '?

Of course.

> > +	if (ret < 0) {
> > +		dev_err(dev, "%s: failed to crop to %ux%u@%u:%u\n", __func__,
> > +			 rect->width, rect->height, rect->left, rect->top);
> > +		return ret;
> > +	}

...
> > +		sg_mode = 1;
>
> "true"

Right.

...
> > +static int omap1_cam_set_bus_param(struct soc_camera_device *icd,
> > +		__u32 pixfmt)
> > +{
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +	struct omap1_cam_dev *pcdev = ici->priv;
> > +	struct device *dev = icd->dev.parent;
> > +	const struct soc_camera_format_xlate *xlate;
> > +	const struct soc_mbus_pixelfmt *fmt;
> > +	unsigned long camera_flags, common_flags;
> > +	u32 ctrlclock, mode;
> > +	int ret;
> > +
> > +	camera_flags = icd->ops->query_bus_param(icd);
> > +
> > +	common_flags = soc_camera_bus_param_compatible(camera_flags,
> > +			SOCAM_BUS_FLAGS);
> > +	if (!common_flags)
> > +		return -EINVAL;
> > +
> > +	/* Make choices, possibly based on platform configuration */
> > +	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
> > +			(common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
> > +		if (!pcdev->pdata ||
> > +				pcdev->pdata->flags & OMAP1_CAMERA_LCLK_RISING)
>
> Out of curiosity - do you need to force a specific clock polarity on your
> platform 

If you mean my board - no, I don't think so.

> or do you know of any, where this is necessary (beyond the 
> natural restriction, coming from the sensor - if any). 

No, neither.

> I.e., I'm not at 
> all sure you need this flag, but if you do - I would apply it earlier - to
> mask the respective bit from SOCAM_BUS_FLAGS.

Maybe my understanding of what is actually going on here is not enough. TBH, 
I've just copy-pasted this piece of code from mx1_camera.c in order to 
provide support for a hardware feature that is available on my platform, 
regardles of any boards actually using it or not. Almost all existing 
soc_camera host drivers, ie. the pxa_camera.c and all of mx?_camera.c, follow 
the same or very similiar pattern, and the only exception, 
sh_mobile_ceu_camera.c, looks for me like just missing this hardware feature. 
Then, having no example implementation to follow and not ehough understanding 
of the matter, I'm not sure if I'm able to make you happy. Please give me 
more details if you think this is important.

> > +			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
> > +		else
> > +			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
> > +	}
> > +
> > +	ret = icd->ops->set_bus_param(icd, common_flags);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ctrlclock = CAM_READ_CACHE(pcdev, CTRLCLOCK);
> > +	if (ctrlclock & LCLK_EN)
> > +		CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
> > +
> > +	if (common_flags & SOCAM_PCLK_SAMPLE_RISING) {
> > +		dev_dbg(dev, "CTRLCLOCK_REG |= POLCLK\n");
> > +		ctrlclock |= POLCLK;
> > +	} else {
> > +		dev_dbg(dev, "CTRLCLOCK_REG &= ~POLCLK\n");
> > +		ctrlclock &= ~POLCLK;
> > +	}
> > +	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~LCLK_EN);
> > +
> > +	if (ctrlclock & LCLK_EN)
> > +		CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock);
> > +
> > +	/* select bus endianess */
> > +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> > +	fmt = xlate->host_fmt;
> > +
> > +	mode = CAM_READ(pcdev, MODE) & ~(RAZ_FIFO | IRQ_MASK | DMA);
> > +	if (fmt->order == SOC_MBUS_ORDER_LE) {
> > +		dev_dbg(dev, "MODE_REG &= ~ORDERCAMD\n");
> > +		CAM_WRITE(pcdev, MODE, mode & ~ORDERCAMD);
> > +	} else {
> > +		dev_dbg(dev, "MODE_REG |= ORDERCAMD\n");
> > +		CAM_WRITE(pcdev, MODE, mode | ORDERCAMD);
> > +	}
> > +
> > +	return 0;
> > +}

...
> > linux-2.6.36-rc3.orig/include/media/omap1_camera.h	2010-09-03
> > 22:34:02.000000000 +0200 +++
> > linux-2.6.36-rc3/include/media/omap1_camera.h	2010-09-08
> > 23:41:12.000000000 +0200 @@ -0,0 +1,35 @@
> > +/*
> > + * Header for V4L2 SoC Camera driver for OMAP1 Camera Interface
> > + *
> > + * Copyright (C) 2010, Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef __MEDIA_OMAP1_CAMERA_H_
> > +#define __MEDIA_OMAP1_CAMERA_H_
> > +
> > +#include <linux/bitops.h>
> > +
> > +#define OMAP1_CAMERA_IOSIZE		0x1c
> > +
> > +enum omap1_cam_vb_mode {
> > +	CONTIG = 0,
> > +	SG,
> > +};
>
> See above - are these needed here?
>
> > +
> > +#define OMAP1_CAMERA_MIN_BUF_COUNT(x)	((x) == CONTIG ? 3 : 2)
>
> ditto

I moved them both over to the header file because I was using the 
OMAP1_CAMERA_MIN_BUF_COUNT(CONTIG) macro once from the platform code in order 
to calculate the buffer size when calling the then NAKed 
dma_preallocate_coherent_memory(). Now I could put them back into the driver 
code, but if we ever get back to the concept of preallocating a contignuos 
piece of memory from the platform init code, we might need them back here, so 
maybe I should rather keep them, only rename the two enum values using a 
distinct name space. What do you think is better for now?

Thanks,
Janusz
