Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50983 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1KZMry (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 07:47:54 -0500
Received: by bke11 with SMTP id 11so5619098bke.19
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2011 04:47:52 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 26 Nov 2011 13:47:52 +0100
Message-ID: <CAO=zWDJD19uCJJfdZQVQzHOSxLcXb11D+Avw--YV5mCk8qxPww@mail.gmail.com>
Subject: Status of RTL283xU support?
From: Maik Zumstrull <maik@zumstrull.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

it seems I've found myself with an rtl2832u-based DVB-T USB stick. The
latest news on that seems to be that you were working on cleaning up
the code of the Realtek-provided GPL driver, with the goal of
eventually getting it into mainline.

Would you mind giving a short status update?

Is there a working out-of-tree version somewhere I could build? I've
tried the linuxtv.org build script against your tree, but it fails
with git errors; possibly due to the recent outage of git.kernel.org.


Thanks,

Maik
