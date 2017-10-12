Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:43143 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdJLAtK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 20:49:10 -0400
Received: by mail-lf0-f54.google.com with SMTP id a16so4183810lfk.0
        for <linux-media@vger.kernel.org>; Wed, 11 Oct 2017 17:49:09 -0700 (PDT)
MIME-Version: 1.0
From: Marian Mihailescu <mihailescu2m@gmail.com>
Date: Thu, 12 Oct 2017 11:19:08 +1030
Message-ID: <CAM3PiRzaj=Vku-rBcroHzP+vMBgdYy_V+6+QBwGYypHanu=gbQ@mail.gmail.com>
Subject: Exynos MFC issues on 4.14-rc4
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been testing 4.14-rc4 on Odroid-XU4, and here's a kernel
complaint when running:

gst-launch-1.0 filesrc location=bunny_trailer_1080p.mov ! parsebin !
v4l2video4dec capture-io-mode=dmabuf ! v4l2video6convert
output-io-mode=dmabuf-import capture-io-mode=dmabuf ! kmssink

http://paste.debian.net/990353/

PS: on kernel 4.9 patched with MFC & GSC updates (almost up to date
with 4.14 I think) there was no "Wrong buffer/video queue type (1)"
message either


Either I've been missing something or nothing has been going on. (K. E. Gordon)
