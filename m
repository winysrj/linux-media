Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35743 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbbFZJDK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 05:03:10 -0400
Message-ID: <1435309372.3761.70.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] [media] v4l2-mem2mem: set the queue owner field
 just as vb2_ioctl_reqbufs does
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Hans Verkuil <hans.verkuil@cisco.com>, kamil@wypas.org,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Fri, 26 Jun 2015 11:02:52 +0200
In-Reply-To: <558D0D29.7060104@samsung.com>
References: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
	 <558BFDED.1090006@samsung.com> <1435245167.3761.53.camel@pengutronix.de>
	 <558D0D29.7060104@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 26.06.2015, 10:28 +0200 schrieb Sylwester Nawrocki:
[...]
> >> How about modifying v4l2_m2m_ioctl_reqbufs() instead ?
> > 
> > The coda, gsc-m2m, m2m-deinterlace, mx2_emmaprp, and sh_veu drivers all
> > have their own implementation of vidioc_reqbufs that call
> > v4l2_m2m_reqbufs directly.
> > Maybe this should be moved into v4l2_m2m_ioctl_reqbufs after all drivers
> > are updated to use it instead of v4l2_m2m_reqbufs.
> 
> In case of some of the above listed drivers it shouldn't be difficult
> and would be nice to convert to the generic v4l2_m2m_ioctl* callbacks.
> 
> Anyway, I guess your code change makes sense, just the comment might
> be a little bit misleading. vq->owner will always be one and the same
> file handle, unless I'm missing something.

True. Since the m2m_ctx containing the vb2_queue is attached to the file
handle, this will only ever get called with the same file handle for a
given queue. s/we have a new owner/we have an owner/ ?

[...]
> > Having the queue owner's device minor in the trace output is very useful
> > when tracing a single stream across multiple devices. To discern events
> > from multiple simultaneous contexts I have added the context id to the
> > coda driver specific trace events.
> 
> OK, I understand now, you are just using this stored file handle for traces.

I should mention this in the patch description.

regards
Philipp

