Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45225 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1JSGHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 02:07:42 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LTA00BHEUCSI8@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 19 Oct 2011 07:07:40 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LTA00JMEUCS60@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 19 Oct 2011 07:07:40 +0100 (BST)
Date: Wed, 19 Oct 2011 08:07:39 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: add a check for uninitialized buffer
In-reply-to: <CAMm-=zAYq7xMWORXA4GrkXZA=isXjXEmAqNrkw_SZJyei1Qmbg@mail.gmail.com>
To: 'Pawel Osciak' <pawel@osciak.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>
Message-id: <020901cc8e25$68132100$38396300$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
References: <1318435964-9986-1-git-send-email-m.szyprowski@samsung.com>
 <CAMm-=zAYq7xMWORXA4GrkXZA=isXjXEmAqNrkw_SZJyei1Qmbg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, October 19, 2011 8:03 AM Pawel Osciak wrote:

> Hi Marek,
> I think there is a typo in this patch:
> 
> On Wed, Oct 12, 2011 at 09:12, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> > __buffer_in_use() might be called for empty/uninitialized buffer in the
> > following scenario: REQBUF(n, USER_PTR), QUERYBUF(). This patch fixes
> > kernel ops in such case.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > CC: Pawel Osciak <pawel@osciak.com>
> >
> > ---
> >  drivers/media/video/videobuf2-core.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> > index d8affb8..cdbbab7 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -284,14 +284,14 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer
> *vb)
> >  {
> >        unsigned int plane;
> >        for (plane = 0; plane < vb->num_planes; ++plane) {
> > +               void mem_priv = vb->planes[plane].mem_priv;
> 
> Shouldn't this be void * instead of just void?

Yes, it should be. It looks that I've posted an older version. In the pull 
request there is a correct version.

> >                /*
> >                 * If num_users() has not been provided, call_memop
> >                 * will return 0, apparently nobody cares about this
> >                 * case anyway. If num_users() returns more than 1,
> >                 * we are not the only user of the plane's memory.
> >                 */
> > -               if (call_memop(q, plane, num_users,
> > -                               vb->planes[plane].mem_priv) > 1)
> > +               if (mem_priv && call_memop(q, plane, num_users, mem_priv) > 1)
> >                        return true;
> >        }
> >        return false;
> > --
> > 1.7.1.569.g6f426

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

