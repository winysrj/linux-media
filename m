Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50098 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1DNRUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2011 13:20:15 -0400
Received: by iyb14 with SMTP id 14so1589457iyb.19
        for <linux-media@vger.kernel.org>; Thu, 14 Apr 2011 10:20:14 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Apr 2011 19:20:13 +0200
Message-ID: <BANLkTik4CEYh3XVaZTL5QONxGd1y3r-KZQ@mail.gmail.com>
Subject: rc_maps.cfg default config for hauppauge
From: =?ISO-8859-1?B?Qu1y8yBBbmRy4XM=?= <bbandi86@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi!

The default rc_maps.cfg doesn't work for hauppauge remotes, because
there's no rc_keymaps/hauppauge, only rc_keymaps/haupp. Also, there's
no config for rc-hauppauge-new table, so I made the following changes:

$diff rc_maps.cfg_orig rc_maps.cfg
113c113
< *     rc-rc5-hauppauge         hauppauge
---
> *     rc-rc5-hauppauge         haupp
118a119
> *     rc-hauppauge-new         haupp

It works with my HVR-1100 and 45 button remote.

Andris
