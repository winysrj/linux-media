Return-path: <mchehab@gaivota>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57834 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab0LXV3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 16:29:39 -0500
Received: by bwz15 with SMTP id 15so8461330bwz.19
        for <linux-media@vger.kernel.org>; Fri, 24 Dec 2010 13:29:37 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 24 Dec 2010 15:29:37 -0600
Message-ID: <AANLkTimMMzxbnXT8nRJYWHmgjX_RJ2goj+j083JB5eLz@mail.gmail.com>
Subject: opinions about non-page-aligned buffers?
From: Rob Clark <robdclark@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi all,

The request has come up on OMAP4 to support non-page-aligned v4l2
buffers.  (This is in context of v4l2 display, but the same reasons
would apply for a camera.)  For most common resolutions, this would
help us get much better memory utilization for a range of memory (or
rather address space) used for YUV buffers.  However it would require
a small change in the client application, since most (all) v4l2 apps
that I have seen are assuming the offsets they are given to mmap are
page aligned.

I am curious if anyone has any suggestions about how to enable this.
Ideally it would be some sort of opt-in feature to avoid breaking apps
that are not aware the the offsets to mmap may not be page aligned.

BR,
-R
