Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4403 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab3A3SFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 13:05:24 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id r0UI5KR5013137
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 30 Jan 2013 19:05:23 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.lan (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id C1C9811E00CB
	for <linux-media@vger.kernel.org>; Wed, 30 Jan 2013 19:05:20 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/2] c-qcam: v4l2-compliance fixes
Date: Wed, 30 Jan 2013 19:05:16 +0100
Message-Id: <1359569118-28009-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Again, old patches I worked on months ago and now have time to post.

These changes make the old c-qcam driver comply with v4l2-compliance.

Tested with my Connectix webcam.

As an aside: I never have been able to get a proper picture out of it.
I suspect that the sensor might be bad. But it works well enough that
I can run v4l2-compliance and get some frames captured (although they
are usually black :-) ).

Regards,

	Hans

