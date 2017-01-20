Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:35327 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbdATWPC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 17:15:02 -0500
Received: by mail-qk0-f178.google.com with SMTP id u25so21615309qki.2
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2017 14:15:02 -0800 (PST)
MIME-Version: 1.0
From: Dreamcat4 <dreamcat4@gmail.com>
Date: Fri, 20 Jan 2017 21:45:55 +0000
Message-ID: <CAN39uTpT1W9m+_OQvP_4pbPiOPKjdTGA6tyJ9VJeGq+AZQXfuw@mail.gmail.com>
Subject: Mysterious regression in dvb driver
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

Apologies if no-one wants to hear about this. But there was a patch
submitted in 3.17 for geniatech t220 / august dvb-t210 v1. And it
seems to have stopped working for some reason. (yet the patch code is
still there. I reached out to the birthplace / author of the patch,
but unfortunately its been a while, moved on to new hardware, and they
couldn't help.

So whats the problem?

Patch added support for scanning HD Channels (dvb-t2) for this
hardware. e.g. with w_scan program. This aspect:

Works in ubuntu 14.04.3 (fully updated kernel etc).

Not works anymore in any versions after that (e.g. 14.10, up to and
including latest 16.04).

I also tried a recent version of debian too, didn't work on debian either.

... mostly confused because all of them have similar modern kernel
now, including 14.04.3 too (which still works properly). Don't know
where to head next. Any ideas?


Link to more details:

https://tvheadend.org/boards/5/topics/10864?r=23758#message-23758
