Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48598 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab2HALe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 07:34:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Date: Wed, 01 Aug 2012 13:35:03 +0200
Message-ID: <1390726.ZQ58TDe5fq@avalon>
In-Reply-To: <60c9f6aa1a35c476f6d3493aa24438ad@chewa.net>
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <1376487.cHbjGZJEZg@avalon> <60c9f6aa1a35c476f6d3493aa24438ad@chewa.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rémi,

On Wednesday 01 August 2012 10:37:02 Rémi Denis-Courmont wrote:
> On Tue, 31 Jul 2012 23:52:35 +0200, Laurent Pinchart wrote:
> >> I want to receive the video buffers in user space for processing.
> >> Typically "processing" is software encoding or conversion. That's what
> >> virtually any V4L application does on the desktop...
> > 
> > But what prevents you from using MMAP ?
> 
> As I wrote several times earlier, MMAP uses fixed number of buffers. In
> some tightly controlled media pipeline with low latency, it might work.

Sorry about making you repeat.

> But in general, the V4L element in the pipeline does not know how fast the
> downstream element(s) will consume the buffers. Thus it has to copy from
> the MMAP buffers into anonymous user memory pending processing. Then any
> dequeued buffer can be requeued as soon as possible. In theory, it might
> also be that, even though the latency is known, the number of required
> buffers exceeds the maximum MMAP buffers count of the V4L device. Either
> way, user space ends up doing memory copy from MMAP to custom buffers.
> 
> This problem does not exist with USERBUF - the V4L2 element can simply
> allocate a new buffer for each dequeued buffer.

What about using the CREATE_BUFS ioctl to add new MMAP buffers at runtime ?

> By the way, this was already discussed a few months ago for the exact same
> DMABUF patch series...

-- 
Regards,

Laurent Pinchart

