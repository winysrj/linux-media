Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:46744 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1EaHgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 03:36:10 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LM100L4AUFN61G0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 May 2011 16:36:09 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LM10099JUG9EC@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 May 2011 16:36:09 +0900 (KST)
Date: Tue, 31 May 2011 16:35:58 +0900
From: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [PATCH v2 0/4] Fix micellaneous issues for M-5MOLS driver
In-reply-to: <1306501095-28267-1-git-send-email-riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com, sakari.ailus@iki.fi
Message-id: <1306827362-4064-1-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <1306501095-28267-1-git-send-email-riverful.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

This is second verion of patch series to handle some issues about M-5MOLS
driver.

The difference against first patch series is as follows:

1) Add contents for 1/5.
	It should be the contents in the each patches, but I've missed it.
	So, I added the contents in the patch.

2) Discard 4/5 about changing m5mols_capture_error_handler()'s name.
	When I saw the comments about timeout variable, I agreed to Sakari's
	comments, and I would remove this. But, after thiking about that,
	It's better not to remove the timeout, and to add more comments
	about this functions's role for making more clearly.

	But, it occurs more confuseness and looks like inconsistent and
	impolite. If this patch gives confuseness to you, I apologize for
	that. It was not my inttention.

	So, my conclusion is to discard 4/5 patch for keeping the previous one.

Thanks, and any comments welcome.

Regards,
Heungjun Kim

