Return-path: <mchehab@gaivota>
Received: from mailout4.samsung.com ([203.254.224.34]:35620 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab0LWLT7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 06:19:59 -0500
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LDV00D34OTAP220@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Dec 2010 20:19:58 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LDV00F8XOT4JW@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Dec 2010 20:19:58 +0900 (KST)
Date: Thu, 23 Dec 2010 12:19:51 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 02/13] v4l: Add multi-planar ioctl handling code
In-reply-to: <201012222138.43382.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Pawel Osciak' <pawel@osciak.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <00eb01cba293$550711d0$ff153570$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <201012221601.37554.hverkuil@xs4all.nl>
 <1293037826-13420-1-git-send-email-pawel@osciak.com>
 <201012222138.43382.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

On Wednesday, December 22, 2010 9:39 PM Hans Verkuil wrote:

> On Wednesday, December 22, 2010 18:10:26 Pawel Osciak wrote:
> > From: Pawel Osciak <p.osciak@samsung.com>
> >
> > Add multi-planar API core ioctl handling and conversion functions.
> >
> > Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/media/video/v4l2-ioctl.c |  453 ++++++++++++++++++++++++++++++++++----
> >  include/media/v4l2-ioctl.h       |   16 ++
> >  2 files changed, 425 insertions(+), 44 deletions(-)
> >
> > diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> > index 8516669..e2f6abb 100644
> > --- a/drivers/media/video/v4l2-ioctl.c
> > +++ b/drivers/media/video/v4l2-ioctl.c
> 
> <snip>
> 
> OK, looks good.
> 
> Marek, this patch + the other patches from your v8 patch series are good to
> go as far as I am concerned. So you can add my tag to the whole series:
> 
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> The only note I want to make is that the V4L2 DocBook spec needs to be updated
> for the multiplanar API. But in my opinion that patch can be done in January.

Thanks for your review and help! I've uploaded a new version with your tag to:
git://git.infradead.org/users/kmpark/linux-2.6-samsung vb2 branch.
You can quickly access it here:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2
(it should be available in a few hours).

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

