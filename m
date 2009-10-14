Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:41928 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZJNDx3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 23:53:29 -0400
Received: by fxm27 with SMTP id 27so11055484fxm.17
        for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 20:52:52 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Oct 2009 23:52:52 -0400
Message-ID: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
Subject: em28xx DVB modeswitching change: call for testers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I have setup a tree that removes the mode switching code when
starting/stopping streaming.  If you have one of the em28xx dvb
devices mentioned in the previous thread and volunteered to test,
please try out the following tree:

http://kernellabs.com/hg/~dheitmueller/em28xx-modeswitch

In particular, this should work for those of you who reported problems
with zl10353 based devices like the Pinnacle 320e (or Dazzle) and were
using that one line change I sent this week.  It should also work with
Antti's Reddo board without needing his patch to move the demod reset
into the tuner_gpio.

This also brings us one more step forward to setting up the locking
properly so that applications cannot simultaneously open the analog
and dvb side of the device.

Thanks for your help,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
