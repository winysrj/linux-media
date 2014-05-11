Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:32660 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757631AbaEKLLO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 07:11:14 -0400
Date: 11 May 2014 07:11:13 -0400
Message-ID: <20140511111113.14427.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.hogan@imgtec.com, linux-media@vger.kernel.org,
	m.chehab@samsung.com
Subject: [PATCH 0/10] drivers/media/rc/ati_remote.c tweaks
Cc: linux@horizon.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here are a bunch of cleanups to the ati_remote driver that have been
sitting in my tree since 2011, and I'm hoping to push upstream.  They work
fine on my v1 ATI Remote Wonder.

Patch 4/10 is the nicest in terms of code deletion, but the
others shrink the driver, too.

There are some that I'm not sure if they're wanted:

6/10 is the most questionable code rearrangement.
Cleaner or messier?  Feedback welcome.

Patches 8 and 9 are just prettying up the keymap table.

Patch 10 fixes some of the sillier default key assignments.  I'm pretty
sure this would constitute a kernel regression and is not okay, but it's
another local change I made, and I might as well see what people think.
Feel free to forget about this one.
