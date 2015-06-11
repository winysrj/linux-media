Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61461 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbbFKTJP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 15:09:15 -0400
Date: Thu, 11 Jun 2015 21:08:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/3] media: atmel-isi: rework on the clock part and
 add runtime pm support
In-Reply-To: <557904CC.2090106@atmel.com>
Message-ID: <Pine.LNX.4.64.1506112106300.18734@axis700.grange>
References: <1432634087-3356-1-git-send-email-josh.wu@atmel.com>
 <557904CC.2090106@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Thu, 11 Jun 2015, Josh Wu wrote:

> Hi, Guennadi
> 
> Any feedback for this patch series?

Sorry, I haven't found the time to look at patches from you and William 
Towle, they are at the top of my todo list now - after all the compulsory 
things, of course. I'll handle them as soon as I find time. Sorry for the 
delay.

Thanks
Guennadi

> Best Regards,
> Josh Wu
> 
> On 5/26/2015 5:54 PM, Josh Wu wrote:
> > This patch series fix the peripheral clock code and enable runtime support.
> > Also it clean up the code which is for the compatiblity of mck.
> > 
> > Changes in v5:
> > - add new patch to fix the condition that codec request still in work.
> > - fix the error path in start_streaming() thanks to Laurent.
> > 
> > Changes in v4:
> > - need to call pm_runtime_disable() in atmel_isi_remove().
> > - merged the patch which remove isi disable code in atmel_isi_probe() as
> >    isi peripherial clock is not enabled in this moment.
> > - refine the commit log
> > 
> > Changes in v3:
> > - remove useless definition: ISI_DEFAULT_MCLK_FREQ
> > 
> > Changes in v2:
> > - merged v1 two patch into one.
> > - use runtime_pm_put() instead of runtime_pm_put_sync()
> > - enable peripheral clock before access ISI registers.
> > - totally remove clock_start()/clock_stop() as they are optional.
> > 
> > Josh Wu (3):
> >    media: atmel-isi: disable ISI even it has codec request in
> >      stop_streaming()
> >    media: atmel-isi: add runtime pm support
> >    media: atmel-isi: remove mck back compatiable code as it's not need
> > 
> >   drivers/media/platform/soc_camera/atmel-isi.c | 105
> > ++++++++++++--------------
> >   1 file changed, 48 insertions(+), 57 deletions(-)
> > 
> 
