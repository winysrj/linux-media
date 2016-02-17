Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34843 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238AbcBQR0c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 12:26:32 -0500
Received: by mail-yw0-f182.google.com with SMTP id g127so18763018ywf.2
        for <linux-media@vger.kernel.org>; Wed, 17 Feb 2016 09:26:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56C4A712.4050403@xs4all.nl>
References: <1452533428-12762-1-git-send-email-dianders@chromium.org>
	<1452533428-12762-5-git-send-email-dianders@chromium.org>
	<56C4A712.4050403@xs4all.nl>
Date: Wed, 17 Feb 2016 09:26:31 -0800
Message-ID: <CAD=FV=WQ0rOfzKDLeHQdP9mS_9RMD60DeU+nSr=69U_XVEA4cg@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] videobuf2-dc: Let drivers specify DMA attrs
From: Doug Anderson <dianders@chromium.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, Tomasz Figa <tfiga@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

On Wed, Feb 17, 2016 at 9:00 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Doug,
>
> Is there any reason to think that different planes will need different
> DMA attrs? I ask because this patch series of mine:
>
> http://www.spinics.net/lists/linux-media/msg97522.html
>
> does away with allocating allocation contexts (struct vb2_dc_conf).
>
> For dma_attr this would mean that struct dma_attrs would probably be implemented
> as a struct dma_attrs pointer in the vb2_queue struct once I rebase that patch series
> on top of this patch. In other words, the same dma_attrs struct would be used for all
> planes.
>
> Second question: would specifying dma_attrs also make sense for videobuf2-dma-sg.c?

Those are all probably better questions for someone like Tomasz, who
authored ${SUBJECT} patch.  I mostly ended up touching this codepath
by going down the rabbit hole chasing a bug.  In my particular case I
was seeing that video was eating up all the large chunks in the system
needlessly and starving other memory users.  Using DMA attrs was the
logical way to indicate that we didn't need large chunks, so I used
it.  Other than that I'm totally unfamiliar with the video subsystem.


-Doug
