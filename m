Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54283 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab2GaVw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 17:52:28 -0400
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
Date: Tue, 31 Jul 2012 23:52:35 +0200
Message-ID: <1376487.cHbjGZJEZg@avalon>
In-Reply-To: <201207312139.42818.remi@remlab.net>
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <26877422.izWOc7eKQo@avalon> <201207312139.42818.remi@remlab.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi R�mi,

On Tuesday 31 July 2012 21:39:40 R�mi Denis-Courmont wrote:
> Le mardi 31 juillet 2012 19:28:12 Laurent Pinchart, vous avez �crit :
> > On Tuesday 31 July 2012 16:39:00 R�mi Denis-Courmont wrote:
> > > Le mardi 31 juillet 2012 14:56:14 Laurent Pinchart, vous avez �crit :
> > > > > For that matter, wouldn't it be useful to support exporting a
> > > > > userptr
> > > > > buffer at some point in the future?
> > > > 
> > > > Shouldn't USERPTR usage be discouraged once we get dma-buf support ?
> > > 
> > > USERPTR, where available, is currently the only way to perform zero-copy
> > > from kernel to userspace. READWRITE does not support zero-copy at all.
> > > MMAP only supports zero-copy if userspace knows a boundary on the number
> > > of concurrent buffers *and* the device can deal with that number of
> > > buffers; in general, MMAP requires memory copying.
> > 
> > Could you please share your use case(s) with us ?
> 
> I want to receive the video buffers in user space for processing. Typically
> "processing" is software encoding or conversion. That's what virtually any
> V4L application does on the desktop...

But what prevents you from using MMAP ?

-- 
Regards,

Laurent Pinchart

