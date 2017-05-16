Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35047 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdEPOca (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 10:32:30 -0400
Received: by mail-oi0-f67.google.com with SMTP id m17so3639427oik.2
        for <linux-media@vger.kernel.org>; Tue, 16 May 2017 07:32:30 -0700 (PDT)
MIME-Version: 1.0
From: Patrick Doyle <wpdster@gmail.com>
Date: Tue, 16 May 2017 10:31:59 -0400
Message-ID: <CAF_dkJBOf16Xz=wx6KT4FLqU_X+Ok+0ZbsV=JfRGs_tN+YKHeQ@mail.gmail.com>
Subject: v4l2_subdev_queryctrl and friends
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a statement in the v4l2-controls.txt in my 4.4.55 kernel that
v4l2_subdev_queryctrl and friends will be removed "Once all the V4L2
drivers that depend on subdev drivers are converted to the control
framework".

How would I be able to tell if my driver (isc-atmel.c) has been
converted to the control framework?  I would have expected that to be
the case, given that I have backported the driver (from linux-media in
the last week or two), but I am not seeing controls that I create in
my subdev.

As long as I am backporting the driver, I may as well do it right.
Unless there is some reason why the control framework is known to be
broken in 4.4.

Any thoughts?

--wpd
