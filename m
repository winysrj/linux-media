Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33996 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760540Ab2CPJ0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 05:26:55 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"Taneja, Archit" <archit@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH] omap_vout: Fix "DMA transaction error" issue when
 rotation is enabled
Date: Fri, 16 Mar 2012 09:26:45 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83181B886@DBDE01.ent.ti.com>
References: <1331295117-489-1-git-send-email-hvaibhav@ti.com>
 <2410737.F7OP3MWonz@avalon>
In-Reply-To: <2410737.F7OP3MWonz@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 14, 2012 at 21:00:25, Laurent Pinchart wrote:
> Hi Vaibhav,
> 
> On Friday 09 March 2012 17:41:57 Vaibhav Hiremath wrote:
> > When rotation is enabled and driver is configured in USERPTR
> > buffer exchange mechanism, in specific use-case driver reports
> > an error,
> >    "DMA transaction error with device 0".
> > 
> > In driver _buffer_prepare funtion, we were using
> > "vout->buf_phy_addr[vb->i]" for buffer physical address to
> > configure SDMA channel, but this variable does get updated
> > only during init.
> > And the issue will occur when driver allocates less number
> > of buffers during init and application requests more buffers
> > through REQBUF ioctl; this variable will lead to invalid
> > configuration of SDMA channel leading to DMA transaction error.
> > 
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > ---
> > Archit/Laurent,
> > Can you help me to validate this patch on your platform/usecase?
> 
> I've tested the patch by rotating the omap_vout overlay by 90 degrees and 
> starting a video stream with 4 buffers. There's no crash, but the kernel 
> prints
> 
> [77.877807] omapdss DISPC error: FIFO UNDERFLOW on gfx, disabling the overlay
> [77.928344] omapdss DISPC error: FIFO UNDERFLOW on vid1, disabling the overlay
> 
> The same problem occurs with 3 buffers, which is what the omap_vout driver 
> allocates by default.
> 
> Without your patch applied I get the same behaviour. Is my test procedure 
> wrong ?
> 

Laurent,

Thanks for testing, the procedure looks ok to me. I need to look into this issue (need to debug).

Thanks,
Vaibhav


> >  drivers/media/video/omap/omap_vout_vrfb.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap/omap_vout_vrfb.c
> > b/drivers/media/video/omap/omap_vout_vrfb.c index 4be26ab..240d36d 100644
> > --- a/drivers/media/video/omap/omap_vout_vrfb.c
> > +++ b/drivers/media/video/omap/omap_vout_vrfb.c
> > @@ -225,7 +225,7 @@ int omap_vout_prepare_vrfb(struct omap_vout_device
> > *vout, if (!is_rotation_enabled(vout))
> >  		return 0;
> > 
> > -	dmabuf = vout->buf_phy_addr[vb->i];
> > +	dmabuf = (dma_addr_t) vout->queued_buf_addr[vb->i];
> >  	/* If rotation is enabled, copy input buffer into VRFB
> >  	 * memory space using DMA. We are copying input buffer
> >  	 * into VRFB memory space of desired angle and DSS will
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

