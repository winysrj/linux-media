Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53089 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab3HSOxn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:53:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VBQpx-0000XX-45
	for linux-media@vger.kernel.org; Mon, 19 Aug 2013 16:53:41 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 19 Aug 2013 16:53:41 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 19 Aug 2013 16:53:41 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: Re: OMAP3 ISP DQBUF hangs
Date: Mon, 19 Aug 2013 14:53:23 +0000 (UTC)
Message-ID: <loom.20130819T160758-83@post.gmane.org>
References: <loom.20130815T161444-925@post.gmane.org> <CALxrGmX2aZsTGG_gM6EECLa1Y9vWgWNqEg_TFoXFr=gVmsJnvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Su Jiaquan <jiaquan.lnx <at> gmail.com> writes:

Hello,

> 
> Hi Tom,
> 
> On Thu, Aug 15, 2013 at 10:15 PM, Tom <Bassai_Dai <at> gmx.net> wrote:
> > Hello,
> >
> > I'm working with an OMAP3 DM3730 processor module with a ov3640 camera
> > module attached on parallel interface. I'm using Linux 3.5 and an
> > application which builds the pipeline and grabs an image like the
> > "media-ctl" and the "yavta" tools.
> >
> > I configured the pipeline to:
> >
> > sensor->ccdc->memory
> >
> > When I call ioctl with DQBUF the calling functions are:
> >
> > isp_video_dqbuf -> omap3isp_video_queue_dqbuf -> isp_video_buffer_wait ->
> > wait_event_interruptible
> >
> > The last function waits until the state of the buffer will be reseted
> > somehow. Can someone tell my which function sets the state of the buffer? Am
> > I missing an interrupt?
> >
> > Best Regards, Tom
> >
> 
> I'm not familar with omap3isp, but from the code, the wait queue is
> released by function ccdc_isr_buffer->omap3isp_video_buffer_next.
> You are either missing a interrupt, or running out of buffer, or found
> a buffer under run.
> 
> Jiaquan
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo <at> vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

you are right. it seems that the list of the ccdc has no buffer left,
because the printk("TOM ccdc_isr_buffer ERROR 1 ##########\n"); is shown in
my log. But I don't understand what I need to do to solve the problem.
What I do is:
- configure the pipeline
- open the video device
- do ioctl VIDIOC_REQBUFS (with memory = V4L2_MEMORY_MMAP and type =
V4L2_BUF_TYPE_VIDEO_CAPTURE)
- do ioctl VIDIOC_QUERYBUF
- do ioctl VIDIOC_STREAMON
- do ioctl VIDIOC_QBUF

without fail. and when I do ioctl VIDIOC_DQBUF. I get my problem. 

Does anyone have an idea what I need to do to solve this problem?



static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
{
	printk("TOM ccdc_isr_buffer ##########\n");
	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
	struct isp_device *isp = to_isp_device(ccdc);
	struct isp_buffer *buffer;
	int restart = 0;

	/* The CCDC generates VD0 interrupts even when disabled (the datasheet
	 * doesn't explicitly state if that's supposed to happen or not, so it
	 * can be considered as a hardware bug or as a feature, but we have to
	 * deal with it anyway). Disabling the CCDC when no buffer is available
	 * would thus not be enough, we need to handle the situation explicitly.
	 */
	printk("TOM ccdc_isr_buffer 1 ##########\n");
	if (list_empty(&ccdc->video_out.dmaqueue))
	{
		printk("TOM ccdc_isr_buffer ERROR 1 ##########\n");
		goto done;
	}

	/* We're in continuous mode, and memory writes were disabled due to a
	 * buffer underrun. Reenable them now that we have a buffer. The buffer
	 * address has been set in ccdc_video_queue.
	 */
	printk("TOM ccdc_isr_buffer 2 ##########\n");
	if (ccdc->state == ISP_PIPELINE_STREAM_CONTINUOUS && ccdc->underrun) {
		restart = 1;
		ccdc->underrun = 0;
		printk("TOM ccdc_isr_buffer ERROR 2 ##########\n");
		goto done;
	}

	printk("TOM ccdc_isr_buffer 3 ##########\n");
	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
		printk("TOM ccdc_isr_buffer ERROR 3 ##########\n");
		dev_info(isp->dev, "CCDC won't become idle!\n");
		goto done;
	}

	printk("TOM ccdc_isr_buffer 4 ##########\n");
	buffer = omap3isp_video_buffer_next(&ccdc->video_out);
	if (buffer != NULL) {
		ccdc_set_outaddr(ccdc, buffer->isp_addr);
		restart = 1;
	}
	printk("TOM ccdc_isr_buffer 5 ##########\n");

	pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;

	if (ccdc->state == ISP_PIPELINE_STREAM_SINGLESHOT &&
	    isp_pipeline_ready(pipe))
		omap3isp_pipeline_set_stream(pipe,
					ISP_PIPELINE_STREAM_SINGLESHOT);
	printk("TOM ccdc_isr_buffer DONE ##########\n");
done:
	return restart;
}



Regards, Tom




