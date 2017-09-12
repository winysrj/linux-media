Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:4214 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751289AbdILMjW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 08:39:22 -0400
From: Mason <slash.tmp@free.fr>
Subject: Duplicated debug message in drivers/media/rc/rc-main.c
To: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media <linux-media@vger.kernel.org>
Message-ID: <d03f24dd-2e71-5f72-0c71-54ddc468f00a@free.fr>
Date: Tue, 12 Sep 2017 14:39:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I enabled all debug messages, and I see:

[    1.931214] Allocated space for 1 keycode entries (8 bytes)
[    1.936822] Allocated space for 1 keycode entries (8 bytes)

One comes from ir_create_table()
The other from ir_setkeytable()

ir_setkeytable() calls ir_create_table()

It looks like one of the two debug messages should be deleted?

Regards.
