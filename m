Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:40091 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbZGIPRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2009 11:17:16 -0400
Received: by gxk26 with SMTP id 26so356238gxk.13
        for <linux-media@vger.kernel.org>; Thu, 09 Jul 2009 08:17:15 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Jul 2009 11:17:13 -0400
Message-ID: <bb2708720907090817o45047eedv88a5915ef11a4239@mail.gmail.com>
Subject: Need Help on howto trace down a soft lock when opening a video0
	device
From: John Sarman <johnsarman@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am currently creating a camera driver for an omap3530 processor
based on omap3 camera support.  I have it successfully configuring my
camera and /dev/video0 shows up.  However when I try to open the
device using any program( xawtv , cat, etc.)  The system soft locks.
What I am trying to do is put printk s  everywhere to track down the
source of the lock.  Currently I would like to know where in v4l2
would be a good place to add a printk to see it go farther than the
generic open from fnctrl.h.  Or maybe another technique to track down
where the soft lock is occurring

Thanks
John Sarman
