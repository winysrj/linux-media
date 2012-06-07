Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:43736 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792Ab2FGLZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 07:25:24 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>
Subject: RE: [PATCH v2 01/13] davinci: vpif: add check for genuine
 interrupts in the isr
Date: Thu, 7 Jun 2012 11:25:13 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753E9308C7@DBDE01.ent.ti.com>
References: <1334652791-15833-1-git-send-email-manjunath.hadli@ti.com>
 <3282000.92FtfC8Du0@avalon>
 <E99FAA59F8D8D34D8A118DD37F7C8F753E927D78@DBDE01.ent.ti.com>
 <1390817.t9BWAtM4KH@avalon>
In-Reply-To: <1390817.t9BWAtM4KH@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, May 14, 2012 at 13:19:40, Laurent Pinchart wrote:
> Hi Manjunath,
> 
> On Friday 11 May 2012 05:32:13 Hadli, Manjunath wrote:
> > On Tue, Apr 17, 2012 at 15:36:16, Laurent Pinchart wrote:
> > > On Tuesday 17 April 2012 14:22:59 Manjunath Hadli wrote:
> > > > As the same interrupt is shared between capture and display devices,
> > > > sometimes we get isr calls where the interrupt might not genuinely
> > > > belong to capture or display. Hence, add a condition in the isr to
> > > > check for interrupt ownership and channel number to make sure we do
> > > > not service wrong interrupts.
> > > > 
> > > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > > ---
> > > > 
> > > >  drivers/media/video/davinci/vpif_capture.c |    5 +++++
> > > >  drivers/media/video/davinci/vpif_display.c |    5 +++++
> > > >  include/media/davinci/vpif_types.h         |    2 ++
> > > >  3 files changed, 12 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/video/davinci/vpif_capture.c
> > > > b/drivers/media/video/davinci/vpif_capture.c index 6504e40..33d865d
> > > > 100644
> > > > --- a/drivers/media/video/davinci/vpif_capture.c
> > > > +++ b/drivers/media/video/davinci/vpif_capture.c
> > > > @@ -333,6 +333,7 @@ static void vpif_schedule_next_buffer(struct
> > > > common_obj
> > > > *common) */
> > > > 
> > > >  static irqreturn_t vpif_channel_isr(int irq, void *dev_id)  {
> > > > 
> > > > +	struct vpif_capture_config *config = vpif_dev->platform_data;
> > > > 
> > > >  	struct vpif_device *dev = &vpif_obj;
> > > >  	struct common_obj *common;
> > > >  	struct channel_obj *ch;
> > > > 
> > > > @@ -341,6 +342,10 @@ static irqreturn_t vpif_channel_isr(int irq, void
> > > > *dev_id) int fid = -1, i;
> > > > 
> > > >  	channel_id = *(int *)(dev_id);
> > > > 
> > > > +	if (!config->intr_status ||
> > > > +			!config->intr_status(vpif_base, channel_id))
> > > > +		return IRQ_NONE;
> > > > +
> > > 
> > > I don't think this is the right way to handle the situation. You should
> > > instead read the interrupt source register for the VPIF capture device,
> > > and return IRQ_NONE if you find that no interrupt source has been flagged
> > > (and similarly for the display device below).
> >
> > Agreed, and this is what is being done in intr_status() function, which
> > is implemented in the board file. This function checks the interrupt source
> > register for VPIF capture and display devices the way you mentioned.
> 
> Why do you need to do that in board code ? You can just check whether the VPIF 
> capture hardware has generated an interrupt here exactly the same way as you 
> do in your board code, and return IRQ_NONE if it hasn't. There's no need for 
> the VPIF capture driver to be aware of the VPIF display driver (and vice 
> versa).
> 
 Ok I'll add this in the driver itself.

Thx,
--Manju

> > > >  	ch = dev->dev[channel_id];
> > > >  	
> > > >  	field = ch->common[VPIF_VIDEO_INDEX].fmt.fmt.pix.field;
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

