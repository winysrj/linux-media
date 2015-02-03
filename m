Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:36980 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbbBCNri (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 08:47:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: isely@isely.net
Subject: [PATCH 0/2] Drop g/s_priority ioctl ops
Date: Tue,  3 Feb 2015 14:46:54 +0100
Message-Id: <1422971216-47871-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only pvrusb2 is still using the vidioc_g/s_priority ioctl ops.
Add struct v4l2_fh support to pvrusb2, allowing us to drop those
ioctl ops altogether.

This patch series sits on top of the earlier 5 part patch series
"Remove .ioctl from v4l2_file_operations", but it is probably
independent of that one.

Note: this is not yet tested. If Mike can't get around to that this
week, then I'll give it a spin on Monday.

Regards,

	Hans

