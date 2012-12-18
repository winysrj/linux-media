Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55407 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2LRCZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 21:25:17 -0500
Received: by mail-lb0-f169.google.com with SMTP id gk1so209317lbb.14
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2012 18:25:15 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Dec 2012 20:56:15 -0500
Message-ID: <CAOcJUbxUwYJL+ktLHQGdqbeRfVcRfePwnT5mfJ5GbRwkB4f9Kw@mail.gmail.com>
Subject: dvb: or51211: apply pr_fmt and use pr_* macros instead of printk
From: Michael Krufky <mkrufky@linuxtv.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy,

Your patch from Nov 28 entitled, "dvb: or51211: apply pr_fmt and use
pr_* macros instead of printk" located in patchwork at the URL:

http://patchwork.linuxtv.org/patch/15688/

...creates the following build warning:

  CC [M]  drivers/media/dvb-frontends/or51211.o
drivers/media/dvb-frontends/or51211.c:45:0: warning: "pr_fmt"
redefined [enabled by default]
In file included from include/linux/kernel.h:13:0,
                 from drivers/media/dvb-frontends/or51211.c:33:
include/linux/printk.h:180:0: note: this is the location of the
previous definition
drivers/media/dvb-frontends/or51211.c:45:0: warning: "pr_fmt"
redefined [enabled by default]
In file included from include/linux/kernel.h:13:0,
                 from drivers/media/dvb-frontends/or51211.c:33:
include/linux/printk.h:180:0: note: this is the location of the
previous definition

Please take a look at your patch and send a revised version if you
think it's appropriate.

I will have the other "use %*ph[N] to dump small buffers" patches
merged -- thanks for your contribution!

Regards,

Mike Krufky
