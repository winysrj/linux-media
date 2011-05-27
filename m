Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:36900 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1E0M6L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 08:58:11 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LLU0096EUOYJTU0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LLU00DYAUOY16@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Date: Fri, 27 May 2011 21:58:10 +0900
From: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [PATCH 0/5] Fix micellaneous issues for M-5MOLS driver
In-reply-to: <20110525135435.GA3547@valkosipuli.localdomain>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com, sakari.ailus@iki.fi
Message-id: <1306501095-28267-1-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <20110525135435.GA3547@valkosipuli.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series is to handle some issues about M-5MOLS driver.

Except for first patch, most of these issues comes from to Sakari,
And I very appreciate the comments and reviews about this driver. Thanks.

The first change is fixing to read wrong capture image size.

The second change is preventing overwriting part of memory by u32 value
argument of m5mols_read(). So, add exclusive functions according to byte
width of value argument.

The third change is removing using union by reading version information,
and choose reading directly.

The fourth change is renmaing m5mols_capture_error_handler() to proper name -
m5mols_capture_post_work(). This function's object is to proceed all post works
in this function. And, so, I add more comments and rename this function
for preventing to confuse.

The fifth change is missign <, > for the email address.

Thanks, and any comments welcome.

Regards,
Heungjun Kim

