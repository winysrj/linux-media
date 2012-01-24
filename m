Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:41031 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938Ab2AXALI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 19:11:08 -0500
Received: by mail-tul01m020-f176.google.com with SMTP id wp18so4185013obc.7
        for <linux-media@vger.kernel.org>; Mon, 23 Jan 2012 16:11:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F1D918D.7070005@redhat.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
	<1327326675-8431-6-git-send-email-t.stanislaws@samsung.com>
	<4F1D6F88.5080202@redhat.com>
	<4F1D71EA.2060402@samsung.com>
	<4F1D7705.3080601@redhat.com>
	<4F1D8324.5000709@samsung.com>
	<4F1D8E05.4060109@redhat.com>
	<4F1D918D.7070005@redhat.com>
Date: Mon, 23 Jan 2012 18:11:06 -0600
Message-ID: <CAO8GWqnTOD5YvRypohOw1nSu3vnx4bvfOm3KUu+A6-R4auW=3A@mail.gmail.com>
Subject: Re: V4L2 Overlay mode replacement by dma-buf - was: Re: [PATCH 05/10]
 v4l: add buffer exporting via dmabuf
From: "Clark, Rob" <rob@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, daniel@ffwll.ch,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 23, 2012 at 10:57 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
>>> 2) The userspace API changes to properly support for dma buffers.
>>>
>>> If you're not ready to discuss (2), that's ok, but I'd like to follow
>>> the discussions for it with care, not only for reviewing the actual
>>> patches, but also since I want to be sure that it will address the
>>> needs for xawtv and for the Xorg v4l driver.
>>>
>>
>> The support of dmabuf could be easily added to framebuffer API.
>> I expect that it would not be difficult to add it to Xv.

You might want to have a look at my dri2video proposal a while back.
I plan some minor changes to make the api for multi-planar formats
look a bit more like how addfb2 ended up (ie. array of handles,
offsets, and pitches), but you could get the basic idea from:

http://patchwork.freedesktop.org/patch/7939/

> A texture based API is likely needed, at least for it to work with
> modern PC GPU's.

I suspect we will end up w/ an eglImage extension to go dmabuf fd <->
eglImage, and perhaps handle barriers and userspace mappings.  That
should, I think, be the best approach to best hide/abstract all the
GPU crazy games from the rest of the world.

BR,
-R
