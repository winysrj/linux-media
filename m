Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2380 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3LMQOB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 11:14:01 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id rBDGDvIU019553
	for <linux-media@vger.kernel.org>; Fri, 13 Dec 2013 17:13:59 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 634982A2224
	for <linux-media@vger.kernel.org>; Fri, 13 Dec 2013 17:13:47 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 0/9] vb2: various cleanups and improvements
Date: Fri, 13 Dec 2013 17:13:37 +0100
Message-Id: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series does some cleanups in the qbuf/prepare_buf handling
(the first three patches). The fourth patch removes the 'fileio = NULL'
hack. That hack no longer works when dealing with asynchronous calls
from a kernel thread so it had to be fixed.

The next three patches implement retrying start_streaming() if there are
not enough buffers queued for the DMA engine to start. I know that there
are more drivers that can be simplified with this feature available in
the core. Those drivers do the retry of start_streaming in the buf_queue
op which frankly defeats the purpose of having a central start_streaming
op. But I leave it to the driver developers to decide whether or not to
cleanup their drivers.

The big advantage is that apps can just call STREAMON first, then start
queuing buffers without having to know the minimum number of buffers that
have to be queued before the DMA engine will kick in. It always annoyed
me that vb2 didn't take care of that for me as it is easy enough to do.

The eighth patch adds a fix based on a patch from Andy that removes the
file I/O emulation assumption that buffers are dequeued in the same
order that they were enqueued.

The final patch makes a slight change to the STREAMON documentation to
bring it in line with reality.

Regards,

        Hans

Changes since RFCv4:

- Replaced ENODATA by ENOBUFS
- Added DocBook fix

