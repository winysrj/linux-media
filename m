Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:46220 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752403Ab0JCCmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Oct 2010 22:42:49 -0400
Date: Sun, 3 Oct 2010 04:42:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v3] SoC Camera: add driver for OMAP1 camera interface
In-Reply-To: <201010021445.14567.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1010030439550.15920@axis700.grange>
References: <201009301335.51643.jkrzyszt@tis.icnet.pl>
 <Pine.LNX.4.64.1010020803200.14599@axis700.grange> <201010021445.14567.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2 Oct 2010, Janusz Krzysztofik wrote:

> Saturday 02 October 2010 08:07:28 Guennadi Liakhovetski napisał(a):
> > Same with this one - let's take it as is and address a couple of clean-ups
> > later.
> 
> Guennadi,
> Thanks for taking them both.
> 
> BTW, what are your intentions about the last patch from my series still left 
> not commented, "SoC Camera: add support for g_parm / s_parm operations",
> http://www.spinics.net/lists/linux-media/msg22887.html ?

Yes, taking that one too, thanks. I see it right, that I have to apply 3 
of your patches: omap1 camera driver, ov6650 and default .[gs]_fmt for 
soc_camera, the rest will go via the OMAP / ARM tree, right?

> > On Thu, 30 Sep 2010, Janusz Krzysztofik wrote:
> > > +static void omap1_videobuf_queue(struct videobuf_queue *vq,
> > > +						struct videobuf_buffer *vb)
> > > +{
> > > +	struct soc_camera_device *icd = vq->priv_data;
> > > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > > +	struct omap1_cam_dev *pcdev = ici->priv;
> > > +	struct omap1_cam_buf *buf;
> > > +	u32 mode;
> > > +
> > > +	list_add_tail(&vb->queue, &pcdev->capture);
> > > +	vb->state = VIDEOBUF_QUEUED;
> > > +
> > > +	if (pcdev->active) {
> > > +		/*
> > > +		 * Capture in progress, so don't touch pcdev->ready even if
> > > +		 * empty. Since the transfer of the DMA programming register set
> > > +		 * content to the DMA working register set is done automatically
> > > +		 * by the DMA hardware, this can pretty well happen while we
> > > +		 * are keeping the lock here. Levae fetching it from the queue
> >
> > "Leave"
> 
> Yes, sorry.
> 
> > > +		 * to be done when a next DMA interrupt occures instead.
> > > +		 */
> > > +		return;
> > > +	}
> >
> > superfluous braces
> 
> I was instructed once to do a reverse in a patch against ASoC subtree (see 
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg14863.html), but 
> TBH, I can't find a clear enough requirement specified in the 
> Documentation/CodingStyle, so I probably change my habits, at least for you 
> subtree ;).

Nah, forget it, doesn't matter.

> > > +static void videobuf_done(struct omap1_cam_dev *pcdev,
> > > +		enum videobuf_state result)
> > > +{
> > > +	struct omap1_cam_buf *buf = pcdev->active;
> > > +	struct videobuf_buffer *vb;
> > > +	struct device *dev = pcdev->icd->dev.parent;
> > > +
> > > +	if (WARN_ON(!buf)) {
> > > +		suspend_capture(pcdev);
> > > +		disable_capture(pcdev);
> > > +		return;
> > > +	}
> > > +
> > > +	if (result == VIDEOBUF_ERROR)
> > > +		suspend_capture(pcdev);
> > > +
> > > +	vb = &buf->vb;
> > > +	if (waitqueue_active(&vb->done)) {
> > > +		if (!pcdev->ready && result != VIDEOBUF_ERROR) {
> > > +			/*
> > > +			 * No next buffer has been entered into the DMA
> > > +			 * programming register set on time (could be done only
> > > +			 * while the previous DMA interurpt was processed, not
> > > +			 * later), so the last DMA block, be it a whole buffer
> > > +			 * if in CONTIG or its last sgbuf if in SG mode, is
> > > +			 * about to be reused by the just autoreinitialized DMA
> > > +			 * engine, and overwritten with next frame data. Best we
> > > +			 * can do is stopping the capture as soon as possible,
> > > +			 * hopefully before the next frame start.
> > > +			 */
> > > +			suspend_capture(pcdev);
> > > +		}
> >
> > superfluous braces
> 
> ditto.
> 
> I'll address the issues when ready with my forementioned corner case fixes.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
