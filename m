Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48026 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1IZKEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 06:04:01 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LS400E06JYMO920@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 Sep 2011 11:03:58 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LS400JFOJYM3D@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 Sep 2011 11:03:58 +0100 (BST)
Date: Mon, 26 Sep 2011 12:03:53 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [GIT PULL] Selection API and fixes for v3.2
In-reply-to: <4E7D5561.6080303@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Message-id: <010b01cc7c33$98a99a50$c9fccef0$%szyprowski@samsung.com>
Content-language: pl
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com>
 <4E7D5561.6080303@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Ok, I agree that s5p-tv patches need some more work. What about
the other patches, especially these two:
"vb2: add vb2_get_unmapped_area in vb2 core"
"v4l: mem2mem: add wait_{prepare,finish} ops to m2m_testdev"? 

I cannot find them in your staging/for_v3.2 branch yet - should
I include them in the next pull request?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



