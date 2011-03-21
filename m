Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:43541 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1CUIAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 04:00:10 -0400
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIE009A9E7BN630@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Mar 2011 16:59:35 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIE00HHZE7BZP@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Mar 2011 16:59:35 +0900 (KST)
Date: Mon, 21 Mar 2011 16:59:35 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: referencing other control values in the clustered control
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Reply-to: riverful.kim@samsung.com
Message-id: <4D870567.7060208@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

I have a question about referencing control values.

For example:

1) "A" control and "B" control is clustered, and each is defined v4l2_ctrl a, b.
2) These two control is relevant, and start to make one process by real control "A".
3) The b->val is should be referenced for process in the "A" control function, even though
in which is the "A".

And, in this case, 3) is right?
I mean, if the ctrl value clustered with another ctrl can be referenced in the another
ctrl function, or not.

Regards,
Heungjun Kim
