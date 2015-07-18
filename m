Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:34356 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbbGRWVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2015 18:21:31 -0400
Received: by qkfc129 with SMTP id c129so47921087qkf.1
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2015 15:21:30 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 18 Jul 2015 18:21:30 -0400
Message-ID: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
Subject: Adding support for three new Hauppauge HVR-1275 variants - testers reqd.
From: Steven Toth <stoth@kernellabs.com>
To: tonyc@wincomm.com.tw, Antti Palosaari <crope@iki.fi>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

http://git.linuxtv.org/cgit.cgi/stoth/hvr1275.git/log/?h=hvr-1275

Patches above are available for test.

Antti, note the change to SI2168 to add support for enabling and
disabling the SI2168 transport bus dynamically.

I've tested with a combo card, switching back and forward between QAM
and DVB-T, this works fine, just remember to select a different
frontend as we have two frontends on the same adapter,
adapter0/frontend0 is QAM/8SVB, adapter0/frontend1 is DVB-T/T2.

If any testers have the ATSC or DVB-T, I'd expect these to work
equally well, replease report feedback here.

Thanks,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
