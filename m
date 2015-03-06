Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49420 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbbCFU0M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2015 15:26:12 -0500
Date: Fri, 6 Mar 2015 21:25:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] media: atmel-isi: remove mck back compatiable code
 as we don't need it
In-Reply-To: <54F97DDF.7010403@atmel.com>
Message-ID: <Pine.LNX.4.64.1503062124450.20271@axis700.grange>
References: <1425531661-20040-1-git-send-email-josh.wu@atmel.com>
 <1425531661-20040-4-git-send-email-josh.wu@atmel.com> <3743731.I7IKcDRdB6@avalon>
 <54F97DDF.7010403@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh, Laurent,

On Fri, 6 Mar 2015, Josh Wu wrote:

> On 3/5/2015 6:41 PM, Laurent Pinchart wrote:
> > Hi Josh,
> > 
> > Thank you for the patch.
> > 
> > On Thursday 05 March 2015 13:01:01 Josh Wu wrote:
> > > The master clock should handled by sensor itself.
> > I like that :-)
> > 
> > > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > > ---
> > > 
> > >   drivers/media/platform/soc_camera/atmel-isi.c | 32
> > > ------------------------
> > >   1 file changed, 32 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> > > b/drivers/media/platform/soc_camera/atmel-isi.c index 4a384f1..50375ce
> > > 100644
> > > --- a/drivers/media/platform/soc_camera/atmel-isi.c
> > > +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> > > @@ -83,8 +83,6 @@ struct atmel_isi {
> > >   	struct completion		complete;
> > >   	/* ISI peripherial clock */
> > >   	struct clk			*pclk;
> > > -	/* ISI_MCK, feed to camera sensor to generate pixel clock */
> > > -	struct clk			*mck;
> > >   	unsigned int			irq;
> > > 
> > >   	struct isi_platform_data	pdata;
> > > @@ -725,26 +723,12 @@ static void isi_camera_remove_device(struct
> > > soc_camera_device *icd) /* Called with .host_lock held */
> > >   static int isi_camera_clock_start(struct soc_camera_host *ici)
> > >   {
> > > -	struct atmel_isi *isi = ici->priv;
> > > -	int ret;
> > > -
> > > -	if (!IS_ERR(isi->mck)) {
> > > -		ret = clk_prepare_enable(isi->mck);
> > > -		if (ret) {
> > > -			return ret;
> > > -		}
> > > -	}
> > > -
> > >   	return 0;
> > Would it make sense to make the clock_start and clock_stop operations
> > optional
> > in the soc-camera core ?
> I agree. For those camera host which don't provide master clock for sensor,
> clock_start and clock_stop should be optional.
> 
> Hi, Guennadi
> 
> Do you agree with this?

Yes, sure, we can do this. Would anyone like to prepare a patch?

Thanks
Guennadi
