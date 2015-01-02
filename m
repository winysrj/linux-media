Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35504 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbABKHK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 05:07:10 -0500
Received: by mail-ig0-f172.google.com with SMTP id a13so4544873igq.5
        for <linux-media@vger.kernel.org>; Fri, 02 Jan 2015 02:07:10 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 2 Jan 2015 11:07:09 +0100
Message-ID: <CAPZSoVsvxcH7aa2WJwaw0jeo7VT=dWYGgB1Lh1DJdVLKM_KUCg@mail.gmail.com>
Subject: Video resolution limited to 32x32 pixels in Skype with Syntek 1135 webcam
From: =?UTF-8?Q?Tibor_Mi=C5=A1uth?= <tibor.misuth@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've installed Ubuntu 14.04 (kernel 3.13.0-43-generic) on an old Asus
F5R laptop recently. It's equipped with an integrated Syntek 1135
webcam for which the gspca_stk1135 module is loaded.

lsusb:
Bus 001 Device 005: ID 174f:6a31 Syntek Web Cam - Asus A8J, F3S, F5R, VX2S, V1S

lsmod (extract):
gspca_stk1135          13318  0
gspca_main             27814  1 gspca_stk1135
videodev              108503  2 gspca_stk1135,gspca_main

The webcam works fine in guvcview and almost fine in cheese
(resolutions are limited to square options, e.g. 1024x1024).

Unfortunately there is an issue with Skype. It can detect the device
/dev/video0 (once
LD_PRELOAD=/usr/lib/i386-linux-gnu/libv4l/v4l2convert.so) but the
resolution is limited to 32x32 pixels which is useless. I tried to set
video size in Skype's config.xml, but then Skype didn't show anything
(just black screen).

I did a test with an external Genius USB webcam (gspca_sonixb module)
that worked fine (resolution was 640x480 that is max for the camera).

Is there any way to debug the driver (gspca_stk1135) and v4l to find
out the root cause of the issue?

Thanks for help.

Best regards,
Tibor Misuth
