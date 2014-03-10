Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4879 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaCJVV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 17:21:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com
Subject: vb2: various small fixes/improvements
Date: Mon, 10 Mar 2014 22:20:47 +0100
Message-Id: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains a list of various vb2 fixes and improvements.

These patches were originally part of this RFC patch series:

http://www.spinics.net/lists/linux-media/msg73391.html

They are now rebased and reordered a bit. It's little stuff for the
most part, although the first patch touches on more drivers since it
changes the return type of stop_streaming to void. The return value was
always ignored by vb2 and you really cannot do anything sensible with it.
In general resource allocations can return an error, but freeing up resources
should not. That should always succeed.

Regards,

	Hans

