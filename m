Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4466 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZBMMrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 07:47:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: v4l2_driver.c status
Date: Fri, 13 Feb 2009 13:47:10 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131347.11272.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

What is the status of the v4l2_driver.c in v4l2util? (formerly known as 
libv4l2, see my pull request).

While the original v4l2util just contained frequency tables (not much can go 
wrong there), adding the v4l2_driver.c code in that library makes me 
uncomfortable because: 1) it is undocumented, 2) it is unreviewed (and I 
certainly do not agree with several of the choices made here!).

I propose that v4l2_driver.c is moved to a new library (v4l2driver?) with a 
README clarifying that this is experimental.

I'm also willing to do a review of v4l2_driver.c for you.

When a better and documented API is made, then it can be moved to v4l2util 
and released officially.

Documentation should probably go to the V4L2 spec in a separate chapter.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
