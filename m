Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3118 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab1I2Hoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 03:44:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [RFCv4 PATCH 0/6]: add poll_requested_events() function
Date: Thu, 29 Sep 2011 09:44:06 +0200
Message-Id: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the fourth version of this patch series, incorporating the comments
from Andrew Morton: I've split up the multiple-assignment line and added a
comment explaining the purpose of the new function in poll.h.

It's also rebased to the current staging/for_v3.2 branch of the linux-media
tree.

There are no other changes compared to the RFCv3 patches.

I'd very much like to get an Acked-by (or additional comments) from Al or
Andrew! This patch series really should go into v3.2 which is getting close.

Normally I would have posted this v4 3 weeks ago, but due to Real Life
interference in the past few weeks I was unable to. But I'm back, and this is
currently the highest priority for me.

Regards,

	Hans

