Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61402 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0GISJE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 14:09:04 -0400
Received: by fxm14 with SMTP id 14so1284975fxm.19
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 11:09:01 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 9 Jul 2010 14:09:01 -0400
Message-ID: <AANLkTikYq6w4ELQntkKMF-PuB1JkO7Eu6kx5XqxSAnU6@mail.gmail.com>
Subject: RFC: Use of s_std calling s_freq when tuner powered down
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

Here's the scenario:

1.  I have a USB device that supports both an analog tuner and
composite/s-video inputs
2.  The bridge is smart enough to power down the tuner when capturing
on composite/s-video
3.  Changing the video standard appears to send set_freq() calls to
the tuner, which in i2c fail because it's powered down.

So I looked at the tuner-core code, and I'm seeing that tuner_s_std()
will call set_freq() if the tuner->tv_freq field is nonzero.  This
seems reasonable, except as far as I can tell there is no way to set
it to zero (because the places that set the value to zero will return
failure because zero is outside the tuning range).

This behavior happens with tvtime, which always does a tuning on
startup, before switching to the A/V inputs.  While I agree that I
should probably fix tvtime so it doesn't do this, it seems strange
that there is no way to reset tv_freq to zero when toggling away from
the tuner input, so that these errors don't occur.

Any thoughts?  Obviously I would like to eliminate the i2c errors from
littering the dmesg log when there is no real failure condition.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
