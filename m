Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57466 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0ADQ4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 11:56:32 -0500
Received: by ewy19 with SMTP id 19so7487270ewy.21
        for <linux-media@vger.kernel.org>; Mon, 04 Jan 2010 08:56:31 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 4 Jan 2010 17:56:31 +0100
Message-ID: <c1c0c07e1001040856n1ddb1c31qe2790ed428777612@mail.gmail.com>
Subject: libv4l2: error mmapping buffer 0: Permission denied
From: Niko Lau <niko84embedded@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to get a labtec 2200 usb webcam working on my custom ARM platform.
Since that webcam produces only images in pjpeg, I'm using libv4l2.
I wrote a simple capture application where I want to read a single
image in rgb24.
When the application invokes v4l2_read I get the above error.
The error comes from mmap which is invoked in libv4l2, but I've no
idea whats wrong there.
Can someone give me a hint how to fix this?

Thanks

Niko
