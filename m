Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52247 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3BGQQI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 11:16:08 -0500
Received: by mail-ie0-f177.google.com with SMTP id 16so3748495iea.36
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 08:16:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKScGbiChUeL1t+yckeRsxFjkqjzNmMipP7zxACmzxfy_NEZLw@mail.gmail.com>
References: <CAKScGbiChUeL1t+yckeRsxFjkqjzNmMipP7zxACmzxfy_NEZLw@mail.gmail.com>
Date: Thu, 7 Feb 2013 08:16:07 -0800
Message-ID: <CAKScGbiLmeUV8V3io1EcJB=_8QdQBATx3H5WQ2Gko97LprgC8A@mail.gmail.com>
Subject: Fwd: V4l driver issue /dev/video0 device or resource busy
From: abhishek jain <intelccdodemo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am trying to make external UVC web camera with Android device, made
v4l configuration enabling in kernel 3.0.31 for galaxy nexus phone and
verified in log uvc driver gets loaded also changed in
uevent.<board>.rc permission for video0 node : /dev/video0 0666 root
system . Permission and creation of /dev/video0 node i verified
programmatically. But problem is i always get EBUSY error that is
error no 16 device or resource busy. Any suggestion or pointer to
debug this and find out root cause. I am trying all this on root
android phone with custom kernel module that loads v4l driver.

I am experimenting with logitech c270 web camera and debugged _init
and register function returning 0 and picking up nr =0.


Thanks
Himanshu
