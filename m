Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33106 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbbG0LNQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 07:13:16 -0400
Message-ID: <1437995577.3239.20.camel@pengutronix.de>
Subject: Re: [PATCH v3 3/3] [media] videobuf2: add trace events
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>, linux-media@vger.kernel.org,
	kernel@pengutronix.de
Date: Mon, 27 Jul 2015 13:12:57 +0200
In-Reply-To: <55B4C1FD.80201@xs4all.nl>
References: <1436536166-3307-1-git-send-email-p.zabel@pengutronix.de>
	 <1436536166-3307-3-git-send-email-p.zabel@pengutronix.de>
	 <55B4C1FD.80201@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am Sonntag, den 26.07.2015, 13:18 +0200 schrieb Hans Verkuil:
> Hi Philipp,
[...]
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> > index 93b3154..b866a6b 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -30,6 +30,8 @@
> >  #include <media/v4l2-common.h>
> >  #include <media/videobuf2-core.h>
> > 
> 
> Shouldn't there be a #define CREATE_TRACE_POINTS added before the include? That's
> what is done in v4l2-ioctl.c as well.

Documentation/trace/tracepoints.txt says
   "if you use the header in multiple source files,
    #define CREATE_TRACE_POINTS should appear only in one source file."

> I updated my kernel on my laptop to the latest media master and without this line it
> gives me link errors:
> 
> ERROR: "__tracepoint_vb2_qbuf" [drivers/media/v4l2-core/videobuf2-core.ko] undefined!
> ERROR: "__tracepoint_vb2_buf_done" [drivers/media/v4l2-core/videobuf2-core.ko] undefined!
> ERROR: "__tracepoint_vb2_buf_queue" [drivers/media/v4l2-core/videobuf2-core.ko] undefined!
> ERROR: "__tracepoint_vb2_dqbuf" [drivers/media/v4l2-core/videobuf2-core.ko] undefined!
> scripts/Makefile.modpost:90: recipe for target '__modpost' failed

Since drivers/media/v4l2-core/v4l2-ioctl.c is built with the trace
points whenever CONFIG_VIDEO_V4L2 is enabled, the symbols will currently
end up in drivers/media/v4l2-core/v4l2-ioctl.o, but they are not
exported.

> I'm not sure why I didn't see this anywhere else, but can you take a look at this?

I didn't notice because I hadn't built kernels with VIDEO_V4L2 and
VIDEOBUF2_CORE as modules on x86. I'm not sure why I don't get these
errors on ARM, but I suppose this issue is a reason to split the vb2
tracepoints out of include/trace/event/v4l2.h into their own header
anyway. The vb2 tracepoint implementation should reside in the
videobuf2-core module.

regards
Philipp

