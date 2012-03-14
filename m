Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52497 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2CNL2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 07:28:04 -0400
Received: by yhmm54 with SMTP id m54so1642960yhm.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 04:28:04 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 Mar 2012 11:28:03 +0000
Message-ID: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com>
Subject: eMPIA EM2710 Webcam (em28xx) and LIRC
From: Rui Salvaterra <rsalvaterra@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, everyone.

I apologise in advance for the noise if this is the wrong place to ask
such questions. I have a couple of eMPIA EM2710 (Silvercrest) USB
webcams which work quite well, except for the fact that most of LIRC
is unnecessarily loaded when the em28xx module loads. I suppose it
shouldn't be necessary, since these are webcams and don't have any
kind of IR remote control. I tried blacklisting the relevant modules,
but they keep loading. If relevant, I'm running Linux 3.3.0-rc7 on
Ubuntu 11.10.
(I'm not subscribed to the list, but I occasionally lurk in the archives.)

Thanks!
