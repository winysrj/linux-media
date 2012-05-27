Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36836 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2E0V1F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 17:27:05 -0400
Received: by weyu7 with SMTP id u7so1592115wey.19
        for <linux-media@vger.kernel.org>; Sun, 27 May 2012 14:27:04 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Subject: em28xx: Remote control support for another board
Date: Sun, 27 May 2012 23:26:51 +0200
Message-Id: <1338154013-5124-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

some days ago I purchased a "TerraTec Cinergy HTC Stick HD".
Unfortunately the remote control (which came bundled) did not
work.

I found out that there's no remote control support for that
stick/board in the em28xx driver.

Thus I wrote two patches:
The first one adds remote control support for my USB
DVB-[T,C] stick.
The second patch (is optional and) adds a small printk
which lets the user know that he doesn't have to search
in userspace if his remote control does not work.

PS: I could re-use the existing keymap for the TerraTec
Cinergy XS because it uses the same remote control as
my Cinergy HTC Stick HD.

Regards,
Martin

