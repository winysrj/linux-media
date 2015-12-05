Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38342 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbLEWA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 17:00:27 -0500
Received: by igbxm8 with SMTP id xm8so59912332igb.1
        for <linux-media@vger.kernel.org>; Sat, 05 Dec 2015 14:00:26 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 6 Dec 2015 00:00:26 +0200
Message-ID: <CAJ2oMhKbYfqz1Vy5-ERPTZAkNZt=9+rzr6yNduQiyfAWM_Zfug@mail.gmail.com>
Subject: v4l2 kernel module debugging methods
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I would like to ask a general question regarding methods to debug a
v4l2 device driver.
Since I assume that the kernel driver will probably won't work in
first try after coding everything inside the device driver...

1. Do you think qemu/kgdb debugger is a good method for the device
driver debugging , or is it plain printing ?

2. Is there a simple way to display the image of a YUV-like buffer in memory ?

Any other methods, tips, about validation, testing and developing a
v4l2 device is appreciated.

Best Regards,
Ran
