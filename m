Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:62439 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1BHKJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 05:09:10 -0500
Date: Tue, 08 Feb 2011 11:08:55 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH/RFC 0/5] HDMI driver for Samsung S5PV310 platform
In-reply-to: <201102081047.17840.hansverk@cisco.com>
To: 'Hans Verkuil' <hansverk@cisco.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <002201cbc778$3483ffe0$9d8bffa0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1297157427-14560-1-git-send-email-t.stanislaws@samsung.com>
 <201102081047.17840.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Tuesday, February 08, 2011 10:47 AM Hans Verkuil wrote:

> Just two quick notes. I'll try to do a full review this weekend.

Thanks! Please focus only on the "PATCH 4/5", which contains the driver itself.
The other patches are mostly platform prerequisites for the driver and will be
rewritten to fit better some extensions to Samsung platform API.

> On Tuesday, February 08, 2011 10:30:22 Tomasz Stanislawski wrote:
> > ==============
> >  Introduction
> > ==============
> >
> > The purpose of this RFC is to discuss the driver for a TV output interface
> > available in upcoming Samsung SoC. The HW is able to generate digital and
> > analog signals. Current version of the driver supports only digital output.
> >
> > Internally the driver uses videobuf2 framework, and CMA memory allocator.
> Not
> > all of them are merged by now, but I decided to post the sources to start
> > discussion driver's design.

> [snip]

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



