Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:56841 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaJDLXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Oct 2014 07:23:07 -0400
Received: by mail-oi0-f50.google.com with SMTP id i138so1866753oig.9
        for <linux-media@vger.kernel.org>; Sat, 04 Oct 2014 04:23:07 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 4 Oct 2014 13:23:07 +0200
Message-ID: <CAEVwYfjyCU4N-3-Z9BbZpePNxpdkQ=n5ch+HPg4JpZxTnVKmQQ@mail.gmail.com>
Subject: Hauppauge HVR-5500, studder/lag with HD Channels
From: beta992 <beta992@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yesterday I upgraded to the Linux kernel 3.17RC7 and build & installed
the latest drivers from the media-tree (devel-3.17-rc6 branch).

When switching to HD channels I'm getting a lot of lag, switching back
to SD channels, it works without any lag/issues.
It's not a GPU problem, because it worked (great) before and
everything else is smooth.

I can't see any debug output (e.g. dmesg) thought, but on TVHeadend I
get a lot of stream errors.
When playing a stream over HTTP (with TVHeadend) on another computer,
it works OK.

Could it be an issue with the processing on the TV-card that happens
when decoding HD-channels for ouput (on the same computer/display)?


Hope you guys can take a look,

If more debug info is needed, please let me know.


Thanks!
