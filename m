Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbZFKAbF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 20:31:05 -0400
Date: Wed, 10 Jun 2009 21:31:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera: status, roadmap
Message-ID: <20090610213101.1eec7e17@pedra.chehab.org>
In-Reply-To: <200906102209.08535.hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.0906101802450.4817@axis700.grange>
	<200906102209.08535.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Jun 2009 22:09:07 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > 1.4. this is the actual conversion to v4l2-subdev. It depends on some
> > bits and pieces in the v4l2-subdev framework, which are still in progress
> > (e.g. v4l2_i2c_new_subdev_board), I believe (Hans, am I right? or what's
> > the outcome of Mauro's last reply to you in the "[PULL]
> > http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-subdev" thread?), so, it
> > becomes practically impossible to also pull it for 2.6.31.
> 
> I haven't seen a reaction yet from Mauro regarding my latest pull request: I 
> think it addresses all his concerns regarding existing functionality so I 
> actually hope this can be merged. It would help a lot with this and similar 
> efforts.

As Guennadi pointed, it seems that those patches were not yet properly
discussed at the ML.

Since they touch at the core of the subsystem, could you please submit they as
RFC, at linux-media? 

Let's give people some time to review the newly added functions. After that,
you can send me V3 of your pull request.



Cheers,
Mauro
