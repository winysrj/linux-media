Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:44996 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2GaNjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 09:39:06 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Date: Tue, 31 Jul 2012 16:39:00 +0300
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <201207310833.56566.hverkuil@xs4all.nl> <36319543.mdnBULUSen@avalon>
In-Reply-To: <36319543.mdnBULUSen@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207311639.02693.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 31 juillet 2012 14:56:14 Laurent Pinchart, vous avez écrit :
> > For that matter, wouldn't it be useful to support exporting a userptr
> > buffer at some point in the future?
> 
> Shouldn't USERPTR usage be discouraged once we get dma-buf support ?

USERPTR, where available, is currently the only way to perform zero-copy from 
kernel to userspace. READWRITE does not support zero-copy at all. MMAP only 
supports zero-copy if userspace knows a boundary on the number of concurrent 
buffers *and* the device can deal with that number of buffers; in general, 
MMAP requires memory copying.

I am not sure DMABUF even supports transmitting data efficiently to userspace. 
In my understanding, it's meant for transmitting data between DSP's bypassing 
userspace entirely, in other words the exact opposite of what USERBUF does.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
