Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34082 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdCAEao (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 23:30:44 -0500
Received: by mail-qk0-f178.google.com with SMTP id s186so52331949qkb.1
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2017 20:29:53 -0800 (PST)
MIME-Version: 1.0
From: Alexandre-Xavier L-L <axdoomer@gmail.com>
Date: Tue, 28 Feb 2017 23:21:15 -0500
Message-ID: <CAKTMqxusgkfdsbo9KMHvWXhH++ENz_07TsoZbYC_UJpW9ApG8Q@mail.gmail.com>
Subject: Streaming audio from my device in VLC causes the whole system to freeze
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a few devices that work on Linux (for example, the Plextor
ConvertX PX-AV100U which uses the em28xx driver) and I wonder: When I
open their audio stream with VLC, I select the corresponding audio
device (example: hw:0,0) and it starts streaming, but almost instantly
freezes my OS.

I press "caps lock" or "num lock" and the light on the keyboard won't
change, which lets me think the kernel has frozen. The sound will
continue playing if any and the cursor can still move, but clicking
anywhere won't do anything. The computer doesn't react to any input.

How do I diagnose the cause of the problem? There is no kernel panic.
Is there any way that I can figure out where this bug comes from? I've
searched log files, but can't find anything.

Thanks,
Alexandre-Xavier
