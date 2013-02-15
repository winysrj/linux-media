Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2458 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161366Ab3BOMzY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 07:55:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@linuxtv.org>
Subject: [RFC PATCH 00/10]: au0828: v4l2 compliance fixes
Date: Fri, 15 Feb 2013 13:55:03 +0100
Message-Id: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series converts au0828/au8522 to the control framework
and fixes a variety of v4l2-compliance issues. It's pretty standard
stuff, really.

I still need to check big-endian support and do some more testing.

Regards,

	Hans

