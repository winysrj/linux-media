Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54451 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbbIRLVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 07:21:55 -0400
Date: Fri, 18 Sep 2015 13:21:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] media: atmel-isi: parse the DT parameters for
 vsync/hsync/pixclock polarity
In-Reply-To: <55FBF1F7.1090904@atmel.com>
Message-ID: <Pine.LNX.4.64.1509181320050.15589@axis700.grange>
References: <1438681069-16981-1-git-send-email-josh.wu@atmel.com>
 <3317317.RTpCstaHHn@avalon> <55FBD76C.1040303@atmel.com>
 <Pine.LNX.4.64.1509181144170.15589@axis700.grange> <55FBF1F7.1090904@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Fri, 18 Sep 2015, Josh Wu wrote:

> Hi, Guennadi
> 
> On 9/18/2015 5:44 PM, Guennadi Liakhovetski wrote:
> > Hi Nicolas,
> > 
> > Patch handling is on my todo for the coming weekend...
> 
> Beside this patch, Atmel-isi still have server other patches in the patchwork
> for a long time. So some patch may need to rebase.
> 
> Just for your convenience I create a branch here:
> https://github.com/JoshWu/linux-at91/commits/atmel-isi-v4.3,

Thanks, that will help!

> which collected all the Atmel-isi patches that still not merged. You can take
> it as a reference.
> 
> Of cause, if you want I can sent out a pull request for it. thanks.

No need, the branch info above should be enough.

Thanks
Guennadi

> 
> Best Regards,
> Josh Wu
> > 
> > Thanks
> > Guennadi
> > 
> > On Fri, 18 Sep 2015, Nicolas Ferre wrote:
> > 
> > > Le 04/08/2015 13:22, Laurent Pinchart a écrit :
> > > > Hi Josh,
> > > > 
> > > > Thank you for the patch.
> > > > 
> > > > On Tuesday 04 August 2015 17:37:49 Josh Wu wrote:
> > > > > This patch will get the DT parameters of vsync/hsync/pixclock
> > > > > polarity, and
> > > > > pass to driver.
> > > > > 
> > > > > Also add a debug information for test purpose.
> > > > > 
> > > > > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Guennadi, Mauro,
> > > 
> > > I don't see this patch in Linux-next and I'm not so used to
> > > http://git.linuxtv.org but didn't find it either.
> > > 
> > > Well in fact it's just a lengthy version of "ping" ;-)
> > > 
> > > Bye,
> > > 
> > > > > ---
> > > > > 
> > > > > Changes in v3:
> > > > > - add embedded sync dt property support.
> > > > > 
> > > > > Changes in v2:
> > > > > - rewrite the debug message and add pix clock polarity setup thanks to
> > > > >    Laurent.
> > > > > - update the commit log.
> > > > > 
> > > > >   drivers/media/platform/soc_camera/atmel-isi.c | 15 +++++++++++++++
> > > > >   1 file changed, 15 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> > > > > b/drivers/media/platform/soc_camera/atmel-isi.c index fead841..4efc939
> > > > > 100644
> > > > > --- a/drivers/media/platform/soc_camera/atmel-isi.c
> > > > > +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> > > > > @@ -1061,6 +1061,11 @@ static int isi_camera_set_bus_param(struct
> > > > > soc_camera_device *icd) if (common_flags &
> > > > > V4L2_MBUS_PCLK_SAMPLE_FALLING)
> > > > >   		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
> > > > > 
> > > > > +	dev_dbg(icd->parent, "vsync active %s, hsync active %s,
> > > > > sampling on pix
> > > > > clock %s edge\n", +		common_flags &
> > > > > V4L2_MBUS_VSYNC_ACTIVE_LOW ? "low" :
> > > > > "high",
> > > > > +		common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? "low" :
> > > > > "high",
> > > > > +		common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING ?
> > > > > "falling" : "rising");
> > > > > +
> > > > >   	if (isi->pdata.has_emb_sync)
> > > > >   		cfg1 |= ISI_CFG1_EMB_SYNC;
> > > > >   	if (isi->pdata.full_mode)
> > > > > @@ -1148,6 +1153,16 @@ static int atmel_isi_parse_dt(struct atmel_isi
> > > > > *isi,
> > > > >   		return -EINVAL;
> > > > >   	}
> > > > > 
> > > > > +	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> > > > > +		isi->pdata.hsync_act_low = true;
> > > > > +	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
> > > > > +		isi->pdata.vsync_act_low = true;
> > > > > +	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
> > > > > +		isi->pdata.pclk_act_falling = true;
> > > > > +
> > > > > +	if (ep.bus_type == V4L2_MBUS_BT656)
> > > > > +		isi->pdata.has_emb_sync = true;
> > > > > +
> > > > >   	return 0;
> > > > >   }
> > > 
> > > -- 
> > > Nicolas Ferre
> > > 
> 
