Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43199 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab1CNKOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 06:14:15 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LI100FSALRDAL10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Mar 2011 10:14:01 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LI100IB0LRCPU@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Mar 2011 10:14:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [106.116.38.10])
	by linux.samsung.com (Postfix) with ESMTP id 0F4C0270054	for
 <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 11:15:15 +0100 (CET)
Date: Mon, 14 Mar 2011 11:14:00 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [Query] VIDIOC_QBUF and VIDIOC_STREAMON order
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4D7DEA68.2050604@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

As far as I know V4L2 applications are allowed to call VIDIOC_STREAMON before
queuing buffers with VIDIOC_QBUF.

This leads to situation that a H/W is attempted to be enabled by the driver
when it has no any buffer ownership. 

Effectively actual activation of the data pipeline has to be deferred
until first buffer arrived in the driver. Which makes it difficult 
to signal any errors to user during enabling the data pipeline.

Is this allowed to force applications to queue some buffers before calling
STREAMON, by returning an error in vidioc_streamon from the driver, when 
no buffers have been queued at this time?

I suppose this could render some applications to stop working if this kind
of restriction is applied e.g. in camera capture driver.

What the applications really expect?

With the above I refer mostly to a snapshot mode where we have to be careful
not to lose any frame, as there could be only one..


Please share you opinions.


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
