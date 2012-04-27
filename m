Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63619 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2D0Ieu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 04:34:50 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M34005N5QHUS8@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 09:34:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M340099RQHYNJ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 09:34:46 +0100 (BST)
Date: Fri, 27 Apr 2012 10:34:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] V4L: mem2mem: use available list manipulation API
In-reply-to: <Pine.LNX.4.64.1204271008560.31986@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pawel Osciak <p.osciak@samsung.com>
Message-id: <4F9A5A27.20606@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <Pine.LNX.4.64.1204271008560.31986@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/27/2012 10:13 AM, Guennadi Liakhovetski wrote:
> Use an available standard list_first_entry() function instead of 
> open-coding.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-and-tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
