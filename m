Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2312 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab3FOIw1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jun 2013 04:52:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v11 00/21] V4L2 clock and asynchronous probing
Date: Sat, 15 Jun 2013 10:51:33 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
References: <1371236911-15131-1-git-send-email-g.liakhovetski@gmx.de> <2342425.VllfyDroN8@avalon> <Pine.LNX.4.64.1306142244310.11221@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1306142244310.11221@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306151051.33440.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri June 14 2013 22:45:15 Guennadi Liakhovetski wrote:
> Hi Laurent
> 
> On Fri, 14 Jun 2013, Laurent Pinchart wrote:
> 
> > Hi Guennadi,
> > 
> > Thank you for the patches.
> > 
> > On Friday 14 June 2013 21:08:10 Guennadi Liakhovetski wrote:
> > > v11 of the V4L2 clock helper and asynchronous probing patch set.
> > > Functionally identical to v10, only differences are a couple of comment
> > > lines and one renamed struct field - as requested by respectable
> > > reviewers :)
> > > 
> > > Only patches #15, 16 and 18 changed.
> > 
> > [snip]
> > 
> > >  .../devicetree/bindings/media/sh_mobile_ceu.txt    |   18 +
> > 
> >    Documentation/video4linux/v4l2-framework.txt is missing :-)
> 
> I know. I will add it as soon as these patches are in.

Can you please post a first version earlier? I am hesitant to Ack the series
without knowing that there is at least a first version of the documentation
posted. We have had bad experiences in the past with code being committed and
no documentation.

Regards,

	Hans
