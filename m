Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:58944 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab0JBMpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Oct 2010 08:45:42 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3] SoC Camera: add driver for OMAP1 camera interface
Date: Sat, 2 Oct 2010 14:45:12 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009301335.51643.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1010020803200.14599@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1010020803200.14599@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201010021445.14567.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Saturday 02 October 2010 08:07:28 Guennadi Liakhovetski napisał(a):
> Same with this one - let's take it as is and address a couple of clean-ups
> later.

Guennadi,
Thanks for taking them both.

BTW, what are your intentions about the last patch from my series still left 
not commented, "SoC Camera: add support for g_parm / s_parm operations",
http://www.spinics.net/lists/linux-media/msg22887.html ?

> On Thu, 30 Sep 2010, Janusz Krzysztofik wrote:
> > +static void omap1_videobuf_queue(struct videobuf_queue *vq,
> > +						struct videobuf_buffer *vb)
> > +{
> > +	struct soc_camera_device *icd = vq->priv_data;
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +	struct omap1_cam_dev *pcdev = ici->priv;
> > +	struct omap1_cam_buf *buf;
> > +	u32 mode;
> > +
> > +	list_add_tail(&vb->queue, &pcdev->capture);
> > +	vb->state = VIDEOBUF_QUEUED;
> > +
> > +	if (pcdev->active) {
> > +		/*
> > +		 * Capture in progress, so don't touch pcdev->ready even if
> > +		 * empty. Since the transfer of the DMA programming register set
> > +		 * content to the DMA working register set is done automatically
> > +		 * by the DMA hardware, this can pretty well happen while we
> > +		 * are keeping the lock here. Levae fetching it from the queue
>
> "Leave"

Yes, sorry.

> > +		 * to be done when a next DMA interrupt occures instead.
> > +		 */
> > +		return;
> > +	}
>
> superfluous braces

I was instructed once to do a reverse in a patch against ASoC subtree (see 
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg14863.html), but 
TBH, I can't find a clear enough requirement specified in the 
Documentation/CodingStyle, so I probably change my habits, at least for you 
subtree ;).

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
> > +		if (!pcdev->ready && result != VIDEOBUF_ERROR) {
> > +			/*
> > +			 * No next buffer has been entered into the DMA
> > +			 * programming register set on time (could be done only
> > +			 * while the previous DMA interurpt was processed, not
> > +			 * later), so the last DMA block, be it a whole buffer
> > +			 * if in CONTIG or its last sgbuf if in SG mode, is
> > +			 * about to be reused by the just autoreinitialized DMA
> > +			 * engine, and overwritten with next frame data. Best we
> > +			 * can do is stopping the capture as soon as possible,
> > +			 * hopefully before the next frame start.
> > +			 */
> > +			suspend_capture(pcdev);
> > +		}
>
> superfluous braces

ditto.

I'll address the issues when ready with my forementioned corner case fixes.

Thanks,
Janusz

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


