Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33652 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbcLMEFx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 23:05:53 -0500
Received: by mail-qk0-f177.google.com with SMTP id x190so105003973qkb.0
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2016 20:05:53 -0800 (PST)
MIME-Version: 1.0
From: Kevin Cheng <kcheng@gmail.com>
Date: Mon, 12 Dec 2016 23:05:32 -0500
Message-ID: <CAKNt1=e_eb5G4Ka1ao5Bpfas+BCefRh9vWVjQ2tKiyh97ouQUw@mail.gmail.com>
Subject: em28xx - Hauppauge WinTV Dualhd atsc/qam
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm working on support in the em8xx module for the Hauppauge WinTV
dualhd atsc/qam usb stick. I'vey got the first tuner+fe working so
far, but would appreciate any suggestions/feedback on the items below.

the device has:
2x LGDT3306A frontend
2x si2157 tuner

(1) since the tuner sits behind the front end, I initially had the
front end configured to use the i2c gate control but this wasn't
enough because the tuner would send commands on a timer without
knowing that the gate had to be opened.

I added an i2c_driver to the lgdt3306a module using an i2c_mux and it
solved the problem but the lgdt3306a module now has two ways to
initialize -- through _attach and through (i2c) _probe.  Is this the
correct approach?

(2) The second front end + tuner registers ok but doesn't work quite
right.  Tuning works but it doesn't seem like the stream is passing
through... I noticed that em28xx_capture_start in em28xx-core.c is
hardcoded to only use the first transport stream but when i tested
changing it to only enable TS2, that didn't work either.  I'm guessing
there is something else in the code that's assuming only the first
transport stream is used.  Anyone have an idea of what I'm missing?


Thanks,
-Kevin
