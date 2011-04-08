Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51941 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab1DHIOS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 04:14:18 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LJB00I57QVBV9@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Apr 2011 09:14:16 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJB009HNQV9UK@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Apr 2011 09:13:58 +0100 (BST)
Date: Fri, 08 Apr 2011 10:13:45 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFCv1 PATCH 5/9] vb2_poll: don't start DMA,
	leave that to the first read().
In-reply-to: <201104081007.52435.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: 'Hans Verkuil' <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Message-id: <000c01cbf5c4$e1dddd80$a5999880$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
 <aa6ba599252cedcbb977fa151a5af70860384bf1.1301916466.git.hans.verkuil@cisco.com>
 <000601cbf5ba$b499c690$1dcd53b0$%szyprowski@samsung.com>
 <201104081007.52435.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Friday, April 08, 2011 10:08 AM Hans Verkuil wrote:

> On Friday, April 08, 2011 09:00:55 Marek Szyprowski wrote:
> > Hello,
> >
> > On Monday, April 04, 2011 1:52 PM Hans Verkuil wrote:
> >
> > > The vb2_poll function would start read DMA if called without any
> streaming
> > > in progress. This unfortunately does not work if the application just
> wants
> > > to poll for exceptions. This information of what the application is
> polling
> > > for is sadly unavailable in the driver.
> > >
> > > Andy Walls suggested to just return POLLIN | POLLRDNORM and let the
> first
> > > call to read start the DMA. This initial read() call will return EAGAIN
> > > since no actual data is available yet, but it does start the DMA.
> >
> > The current implementation of vb2_read() will just start streaming on
> first
> > call without returning EAGAIN. Do you think this should be changed?
> 
> In the non-blocking case vb2_read will also return EAGAIN. Which is what
> I meant. So nothing needs to be changed.

Right, I got confused again. vb2_read internally calls vb2_dqbuf, which 
in case of nonblocking io returns EAGAIN.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

