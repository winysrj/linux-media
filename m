Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:35428 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPNWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 09:22:08 -0400
Received: by mail-qa0-f52.google.com with SMTP id w8so7262065qac.25
        for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 06:22:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <539E9F25.7030504@ladisch.de>
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com>
	<1402762571-6316-2-git-send-email-m.chehab@samsung.com>
	<539E9F25.7030504@ladisch.de>
Date: Mon, 16 Jun 2014 09:22:08 -0400
Message-ID: <CAGoCfiw3du9rXFvDfsUYLu4Ru6mbdWa+LtAyYupXosM0n-71NA@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 1/3] sound: Add a quirk to enforce period_bytes
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> This looks like a workaround for a userspace bug that would affect all
> USB audio devices.  What period/buffer sizes are xawtv/tvtime trying to
> use?

I have similar concerns, although I don't know what the right solution
is.  For example, the last time Mauro tweaked the latency in tvtime,
it broke support for all cx231xx devices (note that tvtime and xawtv
share essentially the same ALSA code):

http://git.linuxtv.org/cgit.cgi/tvtime.git/commit/?id=3d58ba563bfcc350c180b59a94cec746ccad6ebe

It seems like there is definitely something wrong with the
latency/period selection in both applications, but we need some
insight from people who are better familiar with the ALSA subsystem
for advice on the "right" way to do low latency audio capture (i.e.
properly negotiating minimal latency in a way that works with all
devices).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
