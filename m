Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:27551 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab0JTHka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 03:40:30 -0400
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0LAK009FRVZG6570@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 16:40:28 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LAK0079OVZCVM@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Oct 2010 16:40:28 +0900 (KST)
Date: Wed, 20 Oct 2010 09:40:23 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH/RFC v3 0/7] Videobuf2 framework
In-reply-to: <201010200914.32868.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	kyungmin.park@samsung.com
Message-id: <004901cb702a$10a69100$31f3b300$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
 <201010200914.32868.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, October 20, 2010 9:15 AM wrote:

> On Wednesday, October 20, 2010 08:41:06 Marek Szyprowski wrote:
> > Hello,
> >
> > As I promissed I continue the development of the VideoBuf2 at Samsung
> > until Pawel finds some spare time to help us. This is a third version of
> > the framework. Besides the minor bugfixes here and there I've added a
> > complete read() callback emulator. This emulator provides 2 types of
> > read() operation - 'streaming' and 'one shot'. It is suitable to replace
> > both videobuf_read_stream() and videobuf_read_one() methods from the old
> > videobuf.
> 
> One thing I never understood: what is the point of supporting 'one shot' read
> mode? Why not support just streaming? Does anyone know?

I can imagine that some simple cameras that capture pure JPG frames might want
to use 'one shot' mode. This enables easier scripting and things like 
'cat /dev/video >capture.jpg' working. If you think that 'one shot' mode should
be removed - let me know.

> Another question: how hard is it to support write mode as well? I think
> vb2 should support both. I suspect that once we have a read emulator it isn't
> difficult to make a write emulator too.

Well, that's possible. If you really think that write() emulator is also
required, I can implement both. This shouldn't be much work.

> A last remark: the locking has changed recently in videobuf due to the work
> done on eliminating the BKL.  It's probably a good idea to incorporate those
> changes as well in vb2.

Yes, I noticed that there are a lot of changes in for-2.6.37 staging tree, I
will try to get through them and update relevant parts of vb2. The current
version the vb2 patches is based on 2.6.36-rc8. Kernel tree with vb2 patches
(and the required multiplane patches) will be available in a few hours on:

http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/v4l/vb2

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

