Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43944 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab2GaMqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 08:46:45 -0400
Received: by vbbff1 with SMTP id ff1so5686116vbb.19
        for <linux-media@vger.kernel.org>; Tue, 31 Jul 2012 05:46:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207311411.06974.hverkuil@xs4all.nl>
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
	<201207310833.56566.hverkuil@xs4all.nl>
	<36319543.mdnBULUSen@avalon>
	<201207311411.06974.hverkuil@xs4all.nl>
Date: Tue, 31 Jul 2012 07:46:44 -0500
Message-ID: <CAF6AEGurTWo2AtG=+QkHA2ARVV6OwL7maDpdCyOLEs3QyFKhCA@mail.gmail.com>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
From: Rob Clark <robdclark@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 31, 2012 at 7:11 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > For that matter, wouldn't it be useful to support exporting a userptr buffer
>> > at some point in the future?
>>
>> Shouldn't USERPTR usage be discouraged once we get dma-buf support ?
>
> Why? It's perfectly fine to use it and it's not going away.
>
> I'm not saying that we should support exporting a userptr buffer as a dmabuf fd,
> but I'm just wondering if that is possible at all and how difficult it would be.

it seems not terribly safe, since you don't really have much control
over where the memory comes from w/ userptr.  I'm more in favor of
discouraging usage of userptr

BR,
-R
