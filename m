Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34165 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbbFZJgD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 05:36:03 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQJ00B6KPC1LX20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Jun 2015 10:36:01 +0100 (BST)
Message-id: <558D1CF3.9030808@samsung.com>
Date: Fri, 26 Jun 2015 11:35:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Hans Verkuil <hans.verkuil@cisco.com>, kamil@wypas.org,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/2] [media] v4l2-mem2mem: set the queue owner field just
 as vb2_ioctl_reqbufs does
References: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
 <558BFDED.1090006@samsung.com> <1435245167.3761.53.camel@pengutronix.de>
 <558D0D29.7060104@samsung.com> <1435309372.3761.70.camel@pengutronix.de>
In-reply-to: <1435309372.3761.70.camel@pengutronix.de>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/06/15 11:02, Philipp Zabel wrote:
> Am Freitag, den 26.06.2015, 10:28 +0200 schrieb Sylwester Nawrocki:
> [...]
>>>> > >> How about modifying v4l2_m2m_ioctl_reqbufs() instead ?
>>> > > 
>>> > > The coda, gsc-m2m, m2m-deinterlace, mx2_emmaprp, and sh_veu drivers all
>>> > > have their own implementation of vidioc_reqbufs that call
>>> > > v4l2_m2m_reqbufs directly.
>>> > > Maybe this should be moved into v4l2_m2m_ioctl_reqbufs after all drivers
>>> > > are updated to use it instead of v4l2_m2m_reqbufs.
>> > 
>> > In case of some of the above listed drivers it shouldn't be difficult
>> > and would be nice to convert to the generic v4l2_m2m_ioctl* callbacks.
>> > 
>> > Anyway, I guess your code change makes sense, just the comment might
>> > be a little bit misleading. vq->owner will always be one and the same
>> > file handle, unless I'm missing something.
>
> True. Since the m2m_ctx containing the vb2_queue is attached to the file
> handle, this will only ever get called with the same file handle for a
> given queue. s/we have a new owner/we have an owner/ ?

Sounds good enough to me.

