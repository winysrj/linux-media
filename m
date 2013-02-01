Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1523 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3BAMR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 07:17:28 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id r11CHODG037065
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 1 Feb 2013 13:17:27 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.fritz.box (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 5455E11E00D5
	for <linux-media@vger.kernel.org>; Fri,  1 Feb 2013 13:17:23 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/6] tm6000: v4l2-compliance fixes
Date: Fri,  1 Feb 2013 13:17:15 +0100
Message-Id: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is also based on work I did a few months ago. This fixes
all v4l2-compliance failures except for two:

fail: v4l2-test-formats.cpp(698): Global format mismatch: 56595559/720x480 vs 59565955/720x480

This is due to the fact that the format is stored in the fh struct instead of
globally. Something to work on in a future patch as that's quite a bit more work.
					
fail: v4l2-test-buffers.cpp(109): can_stream && !mmap_valid && !userptr_valid && !dmabuf_valid

This is due to the fact that tm6000 doesn't support vb2. Again, more work than
I have time for now.

All the other fixes have been done, the conversion to the control framework
being the most important.

Regards,

	Hans

