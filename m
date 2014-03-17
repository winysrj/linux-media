Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1585 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbaCQMyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 08:54:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, pawel@osciak.com
Subject: [REVIEWv3 PATCH for v3.15 0/5] v4l2 core sparse error/warning fixes
Date: Mon, 17 Mar 2014 13:54:18 +0100
Message-Id: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These five patches fix sparse errors and warnings coming from the v4l2
core. There are more, but those seem to be problems with sparse itself (see
my posts from Saturday on that topic).

Please take a good look at patch 3/5 in particular: that fixes sparse
errors introduced by my vb2 changes, and required some rework to get it
accepted by sparse without errors or warnings.

The rework required the introduction of more type-specific call_*op macros,
but on the other hand the fail_op macros could be dropped. Sort of one
step backwards, one step forwards.

If someone can think of a smarter solution for this, then please let me
know.

Regards,

	Hans

Changes since v1:

- added patch 2/5: the call_ptr_memop function checks for IS_ERR_OR_NULL
  to see if a pointer is valid or not. The __qbuf_dmabuf code only used
  IS_ERR. Made this consistent with both call_ptr_memop and the other
  pointer checks elsewhere in the vb2 core code.

- fixed a small typo in a comment that Pawel remarked upon.

- Rewrote patch 5/5: Laurent wanted to keep the __user annotation with the
  user_ptr. The reason I hadn't done that was that I couldn't make it work,
  but I had an idea that moving the __user annotation before the '**' might
  do the trick, and that helped indeed.

