Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2139 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3CKVBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>
Subject: [REVIEW PATCH 00/15] au0828: v4l2-compliance cleanups
Date: Mon, 11 Mar 2013 22:00:31 +0100
Message-Id: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series converts the au0828/au8522 drivers to the latest frameworks,
except for vb2 as usual.

Tested with a WinTV aero generously donated by Hauppauge some time ago.

I also did a lot of fixes in the disconnect handling and setting up the
right routing/std information at the right time.

It is now working correctly as far as I can tell: if I stick it in my PC
and run qv4l2 it actually picks up the tuner signal right away (if I set
it to the correct frequency of course).

If someone has additional hardware, then that would be nice if that can be
tested as well.

My git branch is here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/au0828

Regards,

	Hans

