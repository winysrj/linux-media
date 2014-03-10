Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1098 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaCJMU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 08:20:56 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id s2ACKq7x090936
	for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 13:20:54 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 59A062A1889
	for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 13:20:51 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: REVIEW PATCH 0/3] saa7134: convert to vb2
Date: Mon, 10 Mar 2014 13:20:46 +0100
Message-Id: <1394454049-12879-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds videobuf2-dvb support to vb2 (this was missing
until now) and converts saa7134 to vb2.

The first two patches have been posted before as part of this patch
series:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/71396

They are unchanged except for being rebased to the latest master branch.

Regards,

        Hans

