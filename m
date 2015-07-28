Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54650 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbbG1IPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 04:15:20 -0400
Message-ID: <1438071306.3193.9.camel@pengutronix.de>
Subject: Re: [PATCH] [media] v4l2: export videobuf2 trace points
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <kamil@wypas.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Tue, 28 Jul 2015 10:15:06 +0200
In-Reply-To: <55B73724.4040500@xs4all.nl>
References: <1438070104-24084-1-git-send-email-p.zabel@pengutronix.de>
	 <55B73724.4040500@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 28.07.2015, 10:02 +0200 schrieb Hans Verkuil:
> On 07/28/2015 09:55 AM, Philipp Zabel wrote:
> > If videobuf2-core is built as a module, the vb2 trace points must be
> > exported from videodev.o to avoid errors when linking videobuf2-core.
> 
> I'm no tracepoint expert, so I'll just ask: if the tracepoint functionality
> is disabled in the kernel, will this still compile OK?
> 
> That is, will the EXPORT_TRACEPOINT_SYMBOL_GPL() code disappear in that
> case or will it point to absent code/data?

No traces left if CONFIG_TRACEPOINTS not set. include/linux/tracepoint.h
contains:

#ifdef CONFIG_TRACEPOINTS
#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)         \
        EXPORT_SYMBOL_GPL(__tracepoint_##name)
#else /* !CONFIG_TRACEPOINTS */
#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
#endif

regards
Philipp

