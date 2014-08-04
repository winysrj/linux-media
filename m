Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4443 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaHDK1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 06:27:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH for v3.17 0/2] vb2 fixes
Date: Mon,  4 Aug 2014 12:27:10 +0200
Message-Id: <1407148032-41607-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I saw this post http://www.mail-archive.com/linux-media@vger.kernel.org/msg77864.html
and decided to quickly fix the pwc videobuf2-core.c warning. While doing that
I encountered two more vb2 bugs: one very confusing typo in a comment and one
regression from an earlier patch that needs to be applied from 3.15 and up.

Both are corner cases relating to what should be done when start_streaming fails.

Regards,

	Hans

