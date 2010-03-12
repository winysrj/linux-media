Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53712 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab0CLULv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 15:11:51 -0500
Received: by bwz1 with SMTP id 1so1384953bwz.21
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 12:11:50 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 12 Mar 2010 15:11:49 -0500
Message-ID: <829197381003121211l469c30bfjba077cea028bf680@mail.gmail.com>
Subject: Remaining drivers that aren't V4L2?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I know some months ago, there was some discussion about a few drivers
which were stragglers and had not been converted from V4L to V4L2.

Do we have a current list of driver which still haven't been converted?

I started doing some more tvtime work last night, and I would *love*
to drop V4L support (and *only* support V4L2 devices), since it would
make the code much cleaner, more reliable, and easier to test.

If there are only a few obscure webcams remaining, then I'm willing to
tell those users that they have to stick with whatever old version of
tvtime they've been using since the last release four years ago.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
