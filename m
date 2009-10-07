Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:60606 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758800AbZJGI0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Oct 2009 04:26:30 -0400
Received: from epmmp2 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KR400IB2Y34NQ@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Oct 2009 17:25:52 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KR400AS0Y2X3D@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Oct 2009 17:25:52 +0900 (KST)
Date: Wed, 07 Oct 2009 10:24:16 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Mem2Mem V4L2 devices [RFC]
In-reply-to: <19F8576C6E063C45BE387C64729E73940436CF9278@dbde02.ent.ti.com>
To: "'Hiremath, Vaibhav'" <hvaibhav@ti.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <004a01ca4727$93b43d40$bb1cb7c0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <19F8576C6E063C45BE387C64729E73940436CF8DCB@dbde02.ent.ti.com>
 <001801ca45c3$a14826c0$e3d87440$%szyprowski@samsung.com>
 <19F8576C6E063C45BE387C64729E73940436CF8FE8@dbde02.ent.ti.com>
 <001d01ca464d$825316f0$86f944d0$%szyprowski@samsung.com>
 <19F8576C6E063C45BE387C64729E73940436CF9278@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, October 06, 2009 6:12 PM Hiremath, Vaibhav wrote:

> > On Monday, October 05, 2009 8:27 PM Hiremath, Vaibhav wrote:
> >
> > > > > [Hiremath, Vaibhav] IMO, this implementation is not streaming
> > > > model, we are trying to fit mem-to-mem
> > > > > forcefully to streaming.
> > > >
> > > > Why this does not fit streaming? I see no problems with
> > streaming
> > > > over mem2mem device with only one video node. You just queue
> > input
> > > > and output buffers (they are distinguished by 'type' parameter)
> > on
> > > > the same video node.
> > > >
> > > [Hiremath, Vaibhav] Do we create separate queue of buffers based
> > on type? I think we don't.
> >
> > Why not? I really see no problems implementing such driver,
> > especially if this heavily increases the number of use cases where
> > such
> > device can be used.
> >
> [Hiremath, Vaibhav] I thought of it and you are correct, it should be possible. I was kind of biased
> and thinking in only one direction. Now I don't see any reason why we should go for 2 device node
> approach. Earlier I was thinking of 2 device nodes for 2 queues, if it is possible with one device
> node then I think we should align to single device node approach.
> 
> Do you see any issues with it?

Currently, it looks that all issues are resolved. However, something might
arise during the implementation. If so, I will post it here of course.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

