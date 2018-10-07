Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vs1-f51.google.com ([209.85.217.51]:44998 "EHLO
        mail-vs1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbeJGPto (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2018 11:49:44 -0400
Received: by mail-vs1-f51.google.com with SMTP id v18-v6so9773944vsl.11
        for <linux-media@vger.kernel.org>; Sun, 07 Oct 2018 01:43:11 -0700 (PDT)
MIME-Version: 1.0
From: Dafna Hirschfeld <dafna3@gmail.com>
Date: Sun, 7 Oct 2018 11:42:59 +0300
Message-ID: <CAJ1myNQVJG6w1Q59iy8ndFNxVZ1UEKYYWKKJTc=YyqZzY2H1xQ@mail.gmail.com>
Subject: Problem with example program from https://gitlab.collabora.com/koike/v4l2-codec.git
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: helen.koike@collabora.com, hverkuil@xs4all.nl
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
As part of applying to the outreachy program,
I compiled the code in https://gitlab.collabora.com/koike/v4l2-codec.git
I get errors running it.
When I install vicodec.ko I see in the kernel log:

[10752.727509] vicodec vicodec.0: Device registered as /dev/video2
[10752.727534] vicodec vicodec.0: Device registered as /dev/video3

I think /dev/video0, /dev/video1 are already used by uvcvideo

The dev file used in v4l2-decode.c is "/dev/video1"

When running the code as is, it prints:
"mmap: Invalid argument"

Changing the code of v4l2-decode.c to use "/dev/video0" prints:
"Driver didn't accept RGB24 format. Can't proceed."

Changing it to use "/dev/video2" prints:
"Driver didn't accept FWHT format. Can't proceed."

Changing it to use "/dev/video3" prints:
"Driver didn't accept RGB24 format. Can't proceed."

I tried it on both kernel and modules 4.19.0-rc4+ compiled from
https://git.linuxtv.org/linux.git
and kenel and modules 4.19.0-rc1+ compiled from git://linuxtv.org/media_tree.git

Any idea what is the problem or how to investigate ?
Thanks,

Dafna Hirschfeld
