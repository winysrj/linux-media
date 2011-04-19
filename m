Return-path: <mchehab@pedra>
Received: from msa104.auone-net.jp ([61.117.18.164]:35086 "EHLO
	msa104.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab1DSMVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 08:21:03 -0400
Date: Tue, 19 Apr 2011 21:21:06 +0900
From: Akira Tsukamoto <akira-t@s9.dion.ne.jp>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: soc_camera with V4L2 driver
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
In-Reply-To: <ebc1f00e7c3dc1e0956e9ffc7aa73bff.squirrel@webmail.xs4all.nl>
References: <Pine.LNX.4.64.1104181803340.27247@axis700.grange> <ebc1f00e7c3dc1e0956e9ffc7aa73bff.squirrel@webmail.xs4all.nl>
Message-Id: <20110419212103.3992.B41FCDD0@s9.dion.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Hans,

> >> The camera module needs to be initialized by writing values to the
> >> registers.
> >> Do I need to write init function at the following?
> >>
> >> static const struct v4l2_subdev_core_ops rj65na20_core_ops = {
> >>          .reset = rj65na20_reset,
> >> [snip]
> >> }
> >
> > AFAICS neither soc_camera.c, nor sh_mobile_ceu_camera.c call the .reset
> > subdevice core method, so, no, at the moment implementing it wouldn't
> > produce any result. Either you have to choose one of the methods, that are
> > currently called, or you have to add a call to .reset() as required.
> 
> I don't really like the use of reset for this. The reset op is a pretty
> poorly defined op. There is a registration op as well these days that
> might be better suited for this (see struct v4l2_subdev_internal_ops).

May I ask to guide me how to implement:

struct v4l2_subdev_internal_ops {
	int (*registered)(struct v4l2_subdev *sd);
	void (*unregistered)(struct v4l2_subdev *sd);
};

for the initializing camera module by writing values 
to the register?

With kind regards,

Akira 
-- 
Akira Tsukamoto

