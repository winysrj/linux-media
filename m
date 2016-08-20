Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36715 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbcHTUow (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 16:44:52 -0400
Received: by mail-wm0-f47.google.com with SMTP id q128so73741000wma.1
        for <linux-media@vger.kernel.org>; Sat, 20 Aug 2016 13:44:51 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>
Date: Sat, 20 Aug 2016 16:44:50 -0400
Message-ID: <CAKTMqxu_qTdGt5gL2-Xft0mYD9oU-v_OCsgrvXfXTiNa+hZRQg@mail.gmail.com>
Subject: ALSA sound errors when using QV4L2
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

When I use qv4l2 and start recording, I get these repetitively printed
in my terminal:

ALSA lib pcm.c:7843:(snd_pcm_recover) overrun occurred
ALSA lib pcm.c:7843:(snd_pcm_recover) underrun occurred

There is skipping in the the sound. I get these error message whatever
device that I use. There must be a bug in the v4l driver that causes
this. I can't use any other software than qv4l2 to test this, because
others will cause my system to freeze (see my previous email). Is it
possible to fix this?

Thanks,
Alexandre-Xavier
