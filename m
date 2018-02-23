Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34734 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752228AbeBWTas (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 14:30:48 -0500
Received: by mail-lf0-f41.google.com with SMTP id l191so13891856lfe.1
        for <linux-media@vger.kernel.org>; Fri, 23 Feb 2018 11:30:47 -0800 (PST)
MIME-Version: 1.0
From: Federico Allegretti <allegfede@gmail.com>
Date: Fri, 23 Feb 2018 20:30:25 +0100
Message-ID: <CAGUPqz7AX0t6M0U6ZKNtqjyW3_5Aj7PsOHVTERTGX1tApVCWbQ@mail.gmail.com>
Subject: pinnacle 300i driver crashed after first device access
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i noticed that my pinnacle 300i could accept full resolution settings:
v4l2-ctl --set-fmt-video=width=720,height=576

only the first time the command is fired.

after that, evey time i try to set that resolution with the same
command, i get instead only the half vertical resolution:
v4l2-ctl --get-fmt-video
Format Video Capture:
    Width/Height      : 720/288
    Pixel Format      : 'YU12'
    Field             : Bottom
    Bytes per Line    : 720
    Size Image        : 311040
    Colorspace        : SMPTE 170M
    Transfer Function : Default
    YCbCr/HSV Encoding: Default
    Quantization      : Default
    Flags             :

I noticed that behaviour when streaming with ffmpeg:

ffmpeg -re -f video4linux2 -i /dev/video0 -f pulse -ar 44100  -strict
experimental -acodec aac -ab 56k -vcodec libx264 -vb 452k -profile:v
high -level 40 -g 100 -f flv
"rtmp://vps222134.ovh.net:8081/publish/first?passsegretapervideostreaming"

first time i get audio and video full frame and no problems.
second time instead ffmpeg drops a lot of frames and fires warnings:

" ... Thread message queue blocking; consider raising the
thread_queue_size option (current value: 8) ..."
-- 
Open TV Architecture project: http://sourceforge.net/projects/otva/

Messagenet VOIP: 5338759

YouTube Channel: v1p3r's lab

VIMEO HD videos: http://www.vimeo.com/user1912745/videos
