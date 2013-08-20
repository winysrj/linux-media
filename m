Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:23424 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3HTPbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 11:31:11 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MRU008BX5REN090@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Aug 2013 11:31:09 -0400 (EDT)
Date: Tue, 20 Aug 2013 12:31:02 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
Message-id: <20130820123102.2aa7c54f@samsung.com>
In-reply-to: <1904390.nVVGcVBrVP@avalon>
References: <520E76E7.30201@googlemail.com> <5210B2A9.1030803@googlemail.com>
 <20130818122008.38fac218@samsung.com> <1904390.nVVGcVBrVP@avalon>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 20 Aug 2013 15:38:57 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Sunday 18 August 2013 12:20:08 Mauro Carvalho Chehab wrote:
> > Em Sun, 18 Aug 2013 13:40:25 +0200 Frank Schäfer escreveu:
> > > Am 17.08.2013 12:51, schrieb Guennadi Liakhovetski:
> > > > Hi Frank,
> > > > As I mentioned on the list, I'm currently on a holiday, so, replying
> > > > briefly.
> > >
> > > Sorry, I missed that (can't read all mails on the list).
> > > 
> > > > Since em28xx is a USB device, I conclude, that it's supplying clock to
> > > > its components including the ov2640 sensor. So, yes, I think the driver
> > > > should export a V4L2 clock.
> > >
> > > Ok, so it's mandatory on purpose ?
> > > I'll take a deeper into the v4l2-clk code and the
> > > em28xx/ov2640/soc-camera interaction this week.
> > > Have a nice holiday !
> > 
> > commit 9aea470b399d797e88be08985c489855759c6c60
> > Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Date:   Fri Dec 21 13:01:55 2012 -0300
> > 
> >     [media] soc-camera: switch I2C subdevice drivers to use v4l2-clk
> > 
> >     Instead of centrally enabling and disabling subdevice master clocks in
> >     soc-camera core, let subdevice drivers do that themselves, using the
> >     V4L2 clock API and soc-camera convenience wrappers.
> > 
> >     Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >     Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >     Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > (c/c the ones that acked with this broken changeset)
> > 
> > We need to fix it ASAP or to revert the ov2640 changes, as some em28xx
> > cameras are currently broken on 3.10.
> > 
> > I'll also reject other ports to the async API if the drivers are
> > used outside an embedded driver, as no PC driver currently defines
> > any clock source. The same applies to regulators.
> > 
> > Guennadi,
> > 
> > Next time, please check if the i2c drivers are used outside soc_camera
> > and apply the fixes where needed, as no regressions are allowed.
> 
> We definitely need to check all users of our sensor drivers when making such a 
> change. Mistakes happen, so let's fix them.
> 
> Guennadi is on holidays until the end of this week. Would that be too late to 
> fix the issue (given that 3.10 is already broken) ?

Well, it is simple: we should either revert the patch(es) that broke it or
someone should fix it at em28xx. If nobody could fix it, I'll just revert
the patches that broke it and ask -stable to do the same.

Btw, 3.10 is a long term stable, so, it is not too late for fixes there.

> The fix shouldn't be too 
> complex, registering a dummy V4L2 clock in the em28xx driver should be enough. 
> v4l2-clk.c should provide a helper function to do so as that will be a pretty 
> common operation.

Ok, but this doesn't solve one issue: who would do it and when.

Cheers,
Mauro
