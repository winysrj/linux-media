Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47530 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751198AbdGNBOI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 21:14:08 -0400
Received: from dyn3-82-128-184-143.psoas.suomi.net ([82.128.184.143] helo=c-46-246-83-47.ip4.frootvpn.com)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <crope@iki.fi>)
        id 1dVpBG-0004nL-EV
        for linux-media@vger.kernel.org; Fri, 14 Jul 2017 04:14:06 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: rc-core: how to use hid (hardware) decoder?
Message-ID: <a45b045a-e476-9967-db28-4bd9d7359696@iki.fi>
Date: Fri, 14 Jul 2017 04:14:05 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
Some remote controller receivers uses HID interface. I looked rc-core 
implementation, but failed to find how it could be used for hid. I need 
somehow get scancodes and keycodes out from rc-core and write those to 
hardware which then generate hid events. Also, I am not sure if kernel 
keycodes are same than HID codes, but if not then those should be 
translated somehow.

There is rc_g_keycode_from_table() function, which could be used to dump 
current scancode:keycode mapping, but calling it in a loop millions of 
times is not surely correctly :]

Any ideas?

regards
Antti


-- 
http://palosaari.fi/
