Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:52781 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752065AbdJLAxa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 20:53:30 -0400
Received: by mail-lf0-f53.google.com with SMTP id b190so4187141lfg.9
        for <linux-media@vger.kernel.org>; Wed, 11 Oct 2017 17:53:30 -0700 (PDT)
MIME-Version: 1.0
From: Marian Mihailescu <mihailescu2m@gmail.com>
Date: Thu, 12 Oct 2017 11:23:28 +1030
Message-ID: <CAM3PiRxt2EDQnQeBgNhdVHqL-JRqJNdPQT7UA5NHLP5GpJBpHw@mail.gmail.com>
Subject: MFC encoder: no dmabuf import
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC encoder does not support dmabuf-import.
This is a problem when transcoding using MFC decoder, e.g.:

gst-launch-1.0 filesrc location=bunny_trailer_1080p.mov ! parsebin !
v4l2video4dec capture-io-mode=dmabuf ! v4l2video3h264enc
output-io-mode=dmabuf-import
extra-controls="encode,h264_level=10,h264_profile=4,frame_level_rate_control_enable=1,video_bitrate=8000000"
! h264parse ! matroskamux ! filesink location=transcoded.mkv

won't work.

Are there any plans for dmabuf import on MFC encoder?

---
Either I've been missing something or nothing has been going on. (K. E. Gordon)
