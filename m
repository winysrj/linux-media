Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:54366 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752991AbdJUJ6D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Oct 2017 05:58:03 -0400
Received: by mail-wr0-f172.google.com with SMTP id o44so13171371wrf.11
        for <linux-media@vger.kernel.org>; Sat, 21 Oct 2017 02:58:02 -0700 (PDT)
Date: Sat, 21 Oct 2017 11:57:57 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at
Subject: Re: [PATCH] [media] dvb-frontends/stv0910: prevent consecutive
 mutex_unlock()'s
Message-ID: <20171021115757.729e000f@audiostation.wuest.de>
In-Reply-To: <23019.4906.236885.50919@morden.metzler>
References: <20171021083641.7226-1-d.scheller.oss@gmail.com>
        <23019.4906.236885.50919@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sat, 21 Oct 2017 11:28:10 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Daniel Scheller writes:
>  > From: Daniel Scheller <d.scheller@gmx.net>
>  > 
>  > When calling gate_ctrl() with enable=0 if previously the mutex
>  > wasn't locked (ie. on enable=1 failure and subdrivers not handling
>  > this properly, or by otherwise badly behaving drivers), the
>  > i2c_lock could be unlocked  
> 
> I think drivers and subdrivers should rather be fixed so that this
> cannot happen.

As long as stv6111 remains the only chip/driver interfacing with the
stv0910, that's an easy task. However, if other hardware has some other
stv0910+tunerchip combination, things get interesting. In a perfect
world with unicorns and such, every component interacts as intended,
but that's not the case, so I believe this should be handled at the
root.

> But to do this we will first need to define exactly how a failure in
> gate_ctrl() is supposed to be handled, both inside gate_ctrl() and
> by calling drivers.

Well, IMHO (and thats the intention) if gate_ctrl fails due to a
hardware/I2C problem, it isn't opened so there's no need to hold the
lock (since the gate isn't - exclusively - opened). For reasons stated
above this keeps things safe from deadlocking (and we want to avoid
that, even more than double unlocking).

>  > consecutively which isn't allowed. Prevent this by keeping track
>  > of the lock state, and actually call mutex_unlock() only when
>  > certain the lock is held.  
> 
> Why not use mutex_is_locked()?

Good catch (I should try harder finding out what the kernel API has to
offer...). If you prefer that, I'll respin with this and without the
var as v2.

> And there should be a debug message if it (tried double unlocking)
> happens.

Ok. Should IMHO go to dev_dbg then - if drivers don't catch that
situation, this may else lead do kernel log spam.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
