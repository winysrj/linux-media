Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54780 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0GAOqd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jul 2010 10:46:33 -0400
Date: Thu, 1 Jul 2010 16:46:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Baruch Siach <baruch@tkos.co.il>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv5] mx2_camera: Add soc_camera support for i.MX25/i.MX27
Message-ID: <20100701144622.GG28535@pengutronix.de>
References: <47538fc4c6ffbc6a4c80ba55ecdd03603e67095c.1277981781.git.baruch@tkos.co.il> <20100701122803.GE28535@pengutronix.de> <Pine.LNX.4.64.1007011612580.17489@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.1007011612580.17489@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thu, Jul 01, 2010 at 04:23:23PM +0200, Guennadi Liakhovetski wrote:
> > > +config VIDEO_MX2
> > > +	tristate "i.MX27/i.MX25 Camera Sensor Interface driver"
> > > +	depends on VIDEO_DEV && SOC_CAMERA && (MACH_MX27 || ARCH_MX25)
> > > +	select VIDEOBUF_DMA_CONTIG
> > CONTIG?
> 
> What exactly was your question here?
I thought it to be a mistyped "CONFIG", I was wrong.
 
> > > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > > new file mode 100644
> > > index 0000000..98c93fa
> > > --- /dev/null
> > > +++ b/drivers/media/video/mx2_camera.c
> > > @@ -0,0 +1,1513 @@
> > 
> > [...snip...]
> 
> > > +static struct platform_driver mx2_camera_driver = {
> > > +	.driver 	= {
> > > +		.name	= MX2_CAM_DRV_NAME,
> > I'm always unsure if you need
> > 
> > 		.owner  = THIS_MODULE,
> > 
> > here.
> 
> It is not needed in this case. See the "owner" field in struct 
> soc_camera_host_ops mx2_soc_camera_host_ops.
> 
> But that's not the reason why I'm replying. What I didn't like in these 
> your reviews, was the fact, that this driver has been submitted a number 
> of times to the arm-kernel ML, it has "mx2" in its subject, so, you had 
> enough chances to review it, just like Sascha did. Instead, you review it 
> now, making the author create new versions of his patch. You have been 
> asked for advise, because this patch potentially collided with other your 
> patches, your help in resolving this question is appreciated. But then you 
> suddenly decide to review the whole patch... Several of my patches have 
> been treated similarly in the past, so, I know how annoying it is to have 
> to re-iterate them because at v5 someone suddenly decided to take part in 
> the patch review process too...
OK it might annoying but still I cannot understand why this is a reason to
lament.  I don't necessarily feel part of the intended audience for each
patch on LAKML that contains mx2 in it's subject, still less if the
patch changes very little in arch/arm/{plat-mxc,arch-mx*} as Baruch's
patch does.  Now he cc:d me and I had a look and even took the time to
point out the things that I noticed.  From my POV a late reviewer is
better than getting code in that is less optimal.  And let me point out
that reviewing sequentially is more efficient in the sum---at least for
the reviewers.

So should I ignore patches that are say already > v3?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
