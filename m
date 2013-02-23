Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:59129 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab3BWAa5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Feb 2013 19:30:57 -0500
Received: by mail-bk0-f50.google.com with SMTP id jg9so539635bkc.9
        for <linux-media@vger.kernel.org>; Fri, 22 Feb 2013 16:30:55 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 22 Feb 2013 19:30:55 -0500
Message-ID: <CADzA9okNTohmDwxbQNri4y8Gb-=BksugMSiCNaGMzFQXDyLu7g@mail.gmail.com>
Subject: Firmware for cx23885 in linux-firmware.git is broken
From: Joseph Yasi <joe.yasi@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm not sure the appropriate list to email for this, but the
v4l-cx23885-enc.fw file in the linux-firmware.git tree is incorrect.
It is the wrong size and just a duplicate of the
v4l-cx23885-avcore-01.fw. The correct file can be extracted from the
HVR1800 drivers here: http://steventoth.net/linux/hvr1800/.

Thanks,
Joe Yasi
