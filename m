Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50544 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2CPCgc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 22:36:32 -0400
Received: by yhmm54 with SMTP id m54so3833835yhm.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 19:36:31 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 16 Mar 2012 03:36:31 +0100
Message-ID: <CAGa-wNOb8m9D0nZccqe+nKjEjWx5p7SaXHPJHHrb8z7Ts8YuUA@mail.gmail.com>
Subject: Re: cxd2820r: i2c wr failed (PCTV Nanostick 290e)
From: Claus Olesen <ceolesen@gmail.com>
To: kae@midnighthax.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have two 290e's - one for dvb-c and one for dvb-t - on the same computer
running F16, Kaffeine and latest media files
and I see lots of lines in /var/log/messages like this

cxd2820r: i2c wr failed ret:-110 reg:db len:1

and fewer like this

tda18271_write_regs: [16-0060|M] ERROR: idx = 0x3, len = 1,
i2c_transfer returned: -110

but strangely none today.
But despite that then I haven't noticed any problems and in particular that of
yours of lsusb not showing your 290e.

lsusb on my computer shows the 290e's as
Bus 002 Device 002: ID 2013:024f Unknown (Pinnacle?)
Bus 002 Device 003: ID 2013:024f Unknown (Pinnacle?)

However, not long ago I reported a conflict with the 290e and USB a mem stick
http://www.mail-archive.com/linux-media@vger.kernel.org/msg42499.html
which leads me to think that for what it is worth as a test you may want to try
with only 1 USB attached namely only the 290e
