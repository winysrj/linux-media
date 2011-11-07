Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55264 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab1KGOPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 09:15:04 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LUA00635NL1C9@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Nov 2011 14:15:01 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUA00A83NL0T5@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Nov 2011 14:15:01 +0000 (GMT)
Date: Mon, 07 Nov 2011 15:14:18 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: reset queued list on REQBUFS(0) call
In-reply-to: <4EB7E11D.4060709@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Pawel Osciak' <pawel@osciak.com>
Cc: 'Angela Wan' <angela.j.wan@gmail.com>, linux-media@vger.kernel.org,
	leiwen@marvell.com, ytang5@marvell.com, qingx@marvell.com,
	jwan@marvell.com, 'Kyungmin Park' <kyungmin.park@samsung.com>
Message-id: <012d01cc9d57$89867df0$9c9379d0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com>
 <4EA66C5F.8080202@samsung.com>
 <CAMm-=zBt9HufMLpvcDBfD3qS1vL+zwm77APcfVcPQst1zqEyPw@mail.gmail.com>
 <4EB7E11D.4060709@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, November 07, 2011 2:46 PM Mauro Carvalho Chehab wrote:

> Em 25-10-2011 06:11, Pawel Osciak escreveu:
> > On Tue, Oct 25, 2011 at 00:59, Marek Szyprowski
> > <m.szyprowski@samsung.com> wrote:
> >> Queued list was not reset on REQBUFS(0) call. This caused enqueuing
> >> a freed buffer to the driver.
> >>
> >> Reported-by: Angela Wan <angela.j.wan@gmail.com>
> >> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >>  drivers/media/video/videobuf2-core.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/media/video/videobuf2-core.c
> >> b/drivers/media/video/videobuf2-core.c
> >> index 3015e60..5722b81 100644
> >> --- a/drivers/media/video/videobuf2-core.c
> >> +++ b/drivers/media/video/videobuf2-core.c
> >> @@ -254,6 +254,7 @@ static void __vb2_queue_free(struct vb2_queue *q)
> >>
> >>        q->num_buffers = 0;
> >>        q->memory = 0;
> >> +       INIT_LIST_HEAD(&q->queued_list);
> >>  }
> >>
> >>  /**
> >> --
> >> 1.7.1
> >>
> >>
> >>
> >
> > Acked-by: Pawel Osciak <pawel@osciak.com>
> >
> 
> This patch doesn't apply anymore. Is it still needed? If so, please rebase.

Yes, it is needed. This patch, together with other fixes (all rebased) is waiting in the
pull request I've sent on 4.11.2011 - "[GIT PULL] More Samsung patches for v3.2 (updated)"
thread. Do you want me to resend all of them?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

