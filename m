Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:56023 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932727AbdKGSki (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Nov 2017 13:40:38 -0500
Received: by mail-wm0-f43.google.com with SMTP id y83so5927701wmc.4
        for <linux-media@vger.kernel.org>; Tue, 07 Nov 2017 10:40:38 -0800 (PST)
MIME-Version: 1.0
From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 7 Nov 2017 10:40:36 -0800
Message-ID: <CAJ+vNU3=GCFUgo0DYufyeisHYFuRwsY1qUeuQ29Y9J+mdjR57g@mail.gmail.com>
Subject: HDMI field order
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings,

I'm trying to understand the various field orders supported by v4l2
[1]. Do HDMI sources always use V4L2_FIELD_INTERLACED or can they
support alternate modes as well?

Regards,

Tim

[1] - https://www.linuxtv.org/downloads/legacy/video4linux/API/V4L2_API/spec/ch03s06.html
