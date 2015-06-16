Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:34894 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbbFPPwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 11:52:51 -0400
Received: by qgeu36 with SMTP id u36so6281324qge.2
        for <linux-media@vger.kernel.org>; Tue, 16 Jun 2015 08:52:50 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Jun 2015 21:22:50 +0530
Message-ID: <CAOm0dbQ7ExYH888aQ1hhUC5bfxzkpRrjfsjmGDS+mW8HmqCp_A@mail.gmail.com>
Subject: clarification needed: v4l2/soc-camera order of host/sub-device driver
From: Sherin Sasidharan <sherin.s@gmail.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sort of a basic v4l2/soc-camera question.
First time posting on this mailing list; Let me know if this not the
right forum to post.

I am working on an old platform software based on kernel 3.6;
in my case, I have host driver and an i2c sub device driver (based on 5640)
Both are .ko (loadable kernel modules).

Now, things are working if
 I load sub device driver first, and then host driver.

But, if i load host driver first,and then sub device driver, then
things are not fine.
first while insmod-ing host driver itself, probe of host driver is called,

and soc_camera_host_register() is returning fine; internally within
soc_camera.c it would have failed.

Here: @
Soc_camera_probe()
        if (icl->board_info) {
                ret = soc_camera_init_i2c(icd, icl);  // this would
fail as i2c sub device is not added;
                if (ret < 0)
                {
                        goto eadddev;
                }

Is this expected, ? Or, the probe of host driver itself shoudn't have called?!

Is there any loading order of host/ sub device driver. etc?


Thanks,
Sherin
