Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1045 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0EINz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 09:55:28 -0400
Message-Id: <cover.1273413060.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 15:56:58 +0200
Subject: [PATCH 0/6] [RFC] tvp514x fixes
To: linux-media@vger.kernel.org
Cc: hvaibhav@ti.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vaibhav,

While working on the *_fmt to *_mbus_fmt video op conversion I noticed that
tvp514x is confusing the current select TV standard with the detected TV
standard leading to horrible side-effects where called TRY_FMT can actually
magically change the TV standard.

I fixed this and I also simplified the format handling in general. Basically
removing the format list table and realizing that since there is only one
supported format, you can just return that format directly.

This will also make the next step much easier where enum/try/s/g_fmt is
replaced by enum/try/s/g_mbus_fmt.

However, I have no way of testing this. Can you review this code and let
me know if it is OK?

Regards,

	Hans

Hans Verkuil (6):
  tvp514x: do NOT change the std as a side effect
  tvp514x: make std_list const
  tvp514x: there is only one supported format, so simplify the code
  tvp514x: add missing newlines
  tvp514x: remove obsolete fmt_list
  tvp514x: simplify try/g/s_fmt handling

 drivers/media/video/tvp514x.c |  223 ++++++++---------------------------------
 1 files changed, 40 insertions(+), 183 deletions(-)

