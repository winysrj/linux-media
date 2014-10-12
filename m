Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:41919 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaJLSCQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Oct 2014 14:02:16 -0400
Received: by mail-oi0-f46.google.com with SMTP id h136so11291775oig.19
        for <linux-media@vger.kernel.org>; Sun, 12 Oct 2014 11:02:16 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 12 Oct 2014 20:02:16 +0200
Message-ID: <CAEVwYfhaWMOzmvxAzV+DYn945LuA1wOSqpdvHEVpCxMW+u2afw@mail.gmail.com>
Subject: cx23885 0000:01:00.0: DVB: adapter 0 frontend 0 frequency 0 out of
 range (950000..2150000)
From: beta992 <beta992@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I build the latest drivers from git and used the patch from ZZram
(https://patchwork.linuxtv.org/patch/25867/).
The patch isn't implemented yet, but worked before.

What I understand the DVB-C uses:

/* For DVB-C */
> + .symbol_rate_min = 870000,
> + .symbol_rate_max = 11700000,

So maybe the check goes wrong somewhere. Unfortunately I'd find the ratings:
950000 .. 2150000 to patch/edit it.

Could you please take a look?

Many thanks!
