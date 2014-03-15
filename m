Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1265 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbaCONIT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 09:08:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, pawel@osciak.com
Subject: [REVIEW PATCH for v3.15 0/4] v4l2 core sparse error/warning fixes
Date: Sat, 15 Mar 2014 14:07:59 +0100
Message-Id: <1394888883-46850-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These four patches fix sparse errors and warnings coming from the v4l2
core. There are more, but those seem to be problems with sparse itself (see
my posts from today on that topic).

Please take a good look at patch 3/4 in particular: that fixes sparse
errors introduced by my vb2 changes, and required some rework to get it
accepted by sparse without errors or warnings.

The rework required the introduction of more type-specific call_*op macros,
but on the other hand the fail_op macros could be dropped. Sort of one
step backwards, one step forwards.

If someone can think of a smarter solution for this, then please let me
know.

Regards,

	Hans

