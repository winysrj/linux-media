Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46738 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2ITTVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 15:21:25 -0400
Received: by ieak13 with SMTP id k13so4009843iea.19
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2012 12:21:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <505B665D.4080004@schinagl.nl>
References: <1348080243-3818-1-git-send-email-oliver+list@schinagl.nl>
	<CAGoCfizA_wEcJdcXHfN1xA4MTMUJy4vCX4YpN8vpei9=wFZg-w@mail.gmail.com>
	<505B665D.4080004@schinagl.nl>
Date: Thu, 20 Sep 2012 15:21:24 -0400
Message-ID: <CAGoCfixUXWRPHMaKr-YMo32h2xUMOKLFWi_FXpt_=rcpJ_KZ8g@mail.gmail.com>
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-media@vger.kernel.org, crope@iki.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2012 at 2:54 PM, Oliver Schinagl
<oliver+list@schinagl.nl> wrote:
> dvbscan and dvbv5-scan does constantly say 'tuning failed' but it does say
> that on my terratec too. It does work fine however, so probably a bug in
> driver/tool unrelated to this patch.

Just to be clear, the message "tuning failed" is expected behavior
(albeit very misleading).  Basically it means that the tuning attempt
was performed but it failed to get a frequency lock on that channel.
This is very common in cases where you're scanning a range of
frequencies where many of them will not actually achieve a signal
lock.

I would really like to change that message to something more clear,
especially since you're certainly not the first one to think it
indicated there was a problem.  Suggestions/patches welcome.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
