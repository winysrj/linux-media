Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1779 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216AbaFLLy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi
Subject: [REVIEWv4 PATCH 00/34] Add support for compound controls, use in solo/go7007
Date: Thu, 12 Jun 2014 13:52:32 +0200
Message-Id: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for compound controls and up to 8-dimensional
arrays to the control framework and uses it in the solo6x10 and go7007
drivers for the motion detection implementation.

This patch series supersedes http://www.spinics.net/lists/linux-media/msg73118.html.

It incorporates all of Mauro's comments of the v3 patch series with two
exceptions:

- The v4l2_ctrl_new() prototype still has too many arguments. I do want
  to clean this up, but when I tried it I quickly discovered that that
  would cause quite a bit of code churn so I much rather do that after
  this patch series is merged.

- The number of maximum dimensions for multi-dimensional arrays is set at
  8. I'm not allowing for more than 8 dimensions as was suggested. Based on
  the feedback Sakari gave me and my own feelings on this topic I did not
  want to replace the dims[V4L2_CTRL_MAX_DIMS] array with a dims pointer.
  If changing to a u32 *dims is the only way to get this in, then I will
  do so but I am not ready to give up on this. We're dealing with video
  hardware, not with 11-dimensional string theory.

I have added support for getting/setting multidimensional arrays to
v4l2-ctl here:

http://git.linuxtv.org/cgit.cgi/hverkuil/v4l-utils.git/log/?h=compound

I've also tested this with the solo and go7007 driver.

This patch series is available in the propapi-part4 branch of my git
repo: git://linuxtv.org/hverkuil/media_tree.git.

Regards,

        Hans

