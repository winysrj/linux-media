Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:49904 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2HAIhF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Aug 2012 04:37:05 -0400
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 01 Aug 2012 10:37:02 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	<linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<airlied@redhat.com>, <m.szyprowski@samsung.com>,
	<kyungmin.park@samsung.com>, <sumit.semwal@ti.com>,
	<daeinki@gmail.com>, <daniel.vetter@ffwll.ch>,
	<robdclark@gmail.com>, <pawel@osciak.com>,
	<linaro-mm-sig@lists.linaro.org>, <subashrp@gmail.com>,
	<mchehab@redhat.com>, <g.liakhovetski@gmx.de>
In-Reply-To: <1376487.cHbjGZJEZg@avalon>
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <26877422.izWOc7eKQo@avalon> <201207312139.42818.remi@remlab.net> <1376487.cHbjGZJEZg@avalon>
Message-ID: <60c9f6aa1a35c476f6d3493aa24438ad@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Jul 2012 23:52:35 +0200, Laurent Pinchart

<laurent.pinchart@ideasonboard.com> wrote:

>> I want to receive the video buffers in user space for processing.

>> Typically

>> "processing" is software encoding or conversion. That's what virtually

>> any

>> V4L application does on the desktop...

> 

> But what prevents you from using MMAP ?



As I wrote several times earlier, MMAP uses fixed number of buffers. In

some tightly controlled media pipeline with low latency, it might work.



But in general, the V4L element in the pipeline does not know how fast the

downstream element(s) will consume the buffers. Thus it has to copy from

the MMAP buffers into anonymous user memory pending processing. Then any

dequeued buffer can be requeued as soon as possible. In theory, it might

also be that, even though the latency is known, the number of required

buffers exceeds the maximum MMAP buffers count of the V4L device. Either

way, user space ends up doing memory copy from MMAP to custom buffers.



This problem does not exist with USERBUF - the V4L2 element can simply

allocate a new buffer for each dequeued buffer.



By the way, this was already discussed a few months ago for the exact same

DMABUF patch series...



-- 

Rémi Denis-Courmont

Sent from my collocated server
