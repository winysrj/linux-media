Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1916 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1KVMDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 07:03:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ian Armstrong <mail01@iarmst.co.uk>
Subject: [RFCv2 PATCH 0/2] Clarify usage of V4L2_FBUF_FLAG_OVERLAY
Date: Tue, 22 Nov 2011 13:03:19 +0100
Message-Id: <1321963402-1259-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second RFC regarding the usage of V4L2_FBUF_FLAG_OVERLAY.

The first is here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg38769.html

I didn't get many comments, so I decided to go ahead and update the spec
as I think it should be.

Note that this patch series build on this pull request:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/40691

The first patch clarifies the usage of the flag, the other patches make sure
all drivers comply to the definition.

Comments are welcome,

	Hans

