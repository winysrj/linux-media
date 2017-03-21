Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34363 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933365AbdCUQtX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 12:49:23 -0400
Received: by mail-pf0-f181.google.com with SMTP id p189so59100862pfp.1
        for <linux-media@vger.kernel.org>; Tue, 21 Mar 2017 09:49:22 -0700 (PDT)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
From: Eric Nelson <eric@nelint.com>
Subject: CEC button pass-through
Message-ID: <22e92133-6a64-ffaf-a41f-5ae9b19f24e5@nelint.com>
Date: Tue, 21 Mar 2017 09:49:20 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks to your work and those of Russell King, I have an i.MX6
board up and running with the new CEC API, but I'm having
trouble with a couple of sets of remote control keys.

In particular, the directional keys 0x01-0x04 (Up..Right)
and the function keys 0x71-0x74 (F1-F4) don't appear
to be forwarded.

Running cec-ctl with the "-m" or "-M" options shows that they're
simply not being received.

I'm not sure if I'm missing a flag somewhere to tell my television
that we support these keys, or if I'm missing something else.

I'm using the --record option at the moment. Using --playback
seems to restrict the keys to an even smaller set (seems to
block numeric keys).

Do you have any guidance about how to trace this?

I am seeing these keys when using Pulse8/libCEC code and
the vendor driver and am in a position to trace the messages
using that setup if it helps.

Please advise,


Eric Nelson
