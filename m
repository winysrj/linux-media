Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33736 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbcHTU3D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 16:29:03 -0400
Received: by mail-wm0-f65.google.com with SMTP id o80so7792718wme.0
        for <linux-media@vger.kernel.org>; Sat, 20 Aug 2016 13:29:03 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>
Date: Sat, 20 Aug 2016 16:29:01 -0400
Message-ID: <CAKTMqxuTTwSgZ40uVbikGGt1=wgdCfd=OkhJq8Bdz9LYLTsR6A@mail.gmail.com>
Subject: Computer freeze caused by the media drivers?
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have the latest v4l driver. When I use VLC to open my webcam stream,
it causes the computer to freeze. If I use my August vgb100 or any
other of my USB recording device and disconnect them, the computer
will freeze.

When I say freeze, I mean there is no error message, no keyboard LEDs
flashing, I can move my cursor on the screen, but when I click, it
doesn't do anything. The computer doesn't respond to keyboard keys
(e.g.: CTRL+ALT+F1). I can still head the audio from my Youtube video
at the back that keeps playing. The only thing to do is hard-restart
the computer.

I don't know if it's the media module that causes a freeze. How do I
find the cause? We should fix it. I feel like it's a kernel freeze
caused by this module, but I may not be right.

Thanks,
Alexandre-Xavier
