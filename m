Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30580 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1HaFQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 01:16:29 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQS00ADH1BE6180@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 06:16:26 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQS00MSR1BEDD@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 06:16:26 +0100 (BST)
Date: Wed, 31 Aug 2011 07:12:44 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: videobuf2 user pointer vma release seqeuence
In-reply-to: <CAOQL7V-Jp7KX71-nrzBnHObfZd8MZr2=9oK1vWskuxiJ-+U8DA@mail.gmail.com>
To: "'Tang, Yu'" <ytang5@gmail.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	g.liakhovetski@gmx.de
Message-id: <010e01cc679c$9f68b3e0$de3a1ba0$%szyprowski@samsung.com>
Content-language: pl
References: <CAOQL7V_6bjnsG9QwhwA7+DNOfq3ugSH47ybiHg=jKw0mB__TUw@mail.gmail.com>
 <00c901cc66d5$07692420$163b6c60$%szyprowski@samsung.com>
 <CAOQL7V-Jp7KX71-nrzBnHObfZd8MZr2=9oK1vWskuxiJ-+U8DA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, August 30, 2011 5:38 PM Tang, Yu wrote:
 
> Marek,
> 
> Thanks for the quick response and confirmation!  Will submit the patch tomorrow.

I've already extracted it from your mail. It is available on my vb2 fixes branch which I want to
send for merging soon:

http://git.infradead.org/users/kmpark/linux-2.6-samsung/commit/f55e3591f3a607d580ad8b6ff8979b7aae432
b95

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center




