Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab2DSUiD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 16:38:03 -0400
Message-ID: <4F907798.3000304@redhat.com>
Date: Thu, 19 Apr 2012 17:37:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com
Subject: Re: [PATCH v4 02/14] Documentation: media: description of DMABUF
 importing in V4L2
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-3-git-send-email-t.stanislaws@samsung.com> <13761406.oTf8ZzmZpQ@avalon> <4F9021FE.2070903@samsung.com>
In-Reply-To: <4F9021FE.2070903@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-04-2012 11:32, Tomasz Stanislawski escreveu:
 
> Hi Laurent,
> 
> One may find similar sentences in MMAP, USERPTR and DMABUF.
> Maybe the common parts like description of STREAMON/OFF,
> QBUF/DQBUF shuffling should be moved to separate section
> like "Streaming" :).
> 
> Maybe it is worth to introduce a separate patch for this change.
> 
> Frankly, I would prefer to keep the Doc in the current form till
> importer support gets merged. Later the Doc could be fixed.
> 
> BTW. What is the sense of merging userptr and dmabuf section
> if userptr is going to dropped in long-term?

I didn't read yet the rest of the thread, so sorry, if I'm making wrong assumptions...
Am I understanding wrong or are you saying that you want to drop userptr
from V4L2 API in long-term? If so, why?

Regards,
Mauro
