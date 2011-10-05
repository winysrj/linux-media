Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37618 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab1JEWTX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 18:19:23 -0400
Received: by iakk32 with SMTP id k32so2256620iak.19
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2011 15:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	<CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	<4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	<CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	<CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
Date: Thu, 6 Oct 2011 09:19:22 +1100
Message-ID: <CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
Subject: Re: [PATCH] af9013 frontend tuner bus lock
From: Jason Hecker <jwhecker@gmail.com>
To: Josu Lazkano <josu.lazkano@gmail.com>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> http://palosaari.fi/linux/v4l-dvb/firmware/af9015/5.1.0.0/dvb-usb-af9015.fw

5.1?  OK, I might eventually try that one too.

> This morning I get a little pixeled playback, less than a second.

OK, mine was fine for a few days then the pixellation started up in earnest.

At the moment my symptoms were always:

TunerA: Tuned - picture good
TunerB: Idle

Tuner B gets tuned, Tuner A starts to pixellate badly.

I am sure this is the case too:

TunerA: Idle
TunerB: Tuned - picture good

Tuner A gets tuned and has a bad recording.  *Never* has Tuner B
suffered from the pixellation in spite of whatever Tuner A is doing!

Anyway, Malcolm has suggested there is a bug lurking in MythTV too
causing problems with dual tuners so it's a bit hard to isolate the
issue.
