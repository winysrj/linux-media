Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:38266 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab1HWNWK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Aug 2011 09:22:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH/RFC] media: vb2: change queue initialization order
Date: Tue, 23 Aug 2011 15:22:05 +0200
Cc: linux-media@vger.kernel.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Pawel Osciak'" <pawel@osciak.com>,
	"'Jonathan Corbet'" <corbet@lwn.net>,
	"'Uwe =?iso-8859-2?q?Kleine-K=F6nig=27?="
	<u.kleine-koenig@pengutronix.de>,
	"'Marin Mitov'" <mitov@issp.bas.bg>,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	"'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com> <201108231211.25278.hverkuil@xs4all.nl> <010001cc617d$6a6aeb60$3f40c220$%szyprowski@samsung.com>
In-Reply-To: <010001cc617d$6a6aeb60$3f40c220$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201108231522.05578.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, August 23, 2011 12:14:17 Marek Szyprowski wrote:
> Hello,
> 
> On Tuesday, August 23, 2011 12:11 PM Hans Verkuil wrote:
> 
> > Are you planning a RFCv2 for this?
> > 
> > I've been implementing vb2 in an internal driver and this initialization
> > order of vb2 is a bit of a pain to be honest.
> 
> (snipped)
> 
> Yes, I will post it till the end of the week. I'm sorry for the delay, I was
> a bit busy with updating CMA and dma-mapping patches...

No problem, I just wanted to make sure it wasn't lost...

I've found a few other issues as well, I'll post those separately.

Regards,

	Hans

> 
> Best regards
> -- 
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 
> 
