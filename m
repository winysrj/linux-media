Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59429 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933755AbdKGJvB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Nov 2017 04:51:01 -0500
Date: Tue, 7 Nov 2017 07:50:54 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: Ralph Metzler <rjkm@metzlerbros.de>, linux-media@vger.kernel.org,
        mchehab@kernel.org, jasmin@anw.at
Subject: Re: [PATCH] [media] dvb-frontends/stv0910: prevent consecutive
 mutex_unlock()'s
Message-ID: <20171107075054.606020c0@vento.lan>
In-Reply-To: <20171021115757.729e000f@audiostation.wuest.de>
References: <20171021083641.7226-1-d.scheller.oss@gmail.com>
        <23019.4906.236885.50919@morden.metzler>
        <20171021115757.729e000f@audiostation.wuest.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 21 Oct 2017 11:57:57 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> Am Sat, 21 Oct 2017 11:28:10 +0200
> schrieb Ralph Metzler <rjkm@metzlerbros.de>:
> 
> > Daniel Scheller writes:  
> >  > From: Daniel Scheller <d.scheller@gmx.net>
> >  > 
> >  > When calling gate_ctrl() with enable=0 if previously the mutex
> >  > wasn't locked (ie. on enable=1 failure and subdrivers not handling
> >  > this properly, or by otherwise badly behaving drivers), the
> >  > i2c_lock could be unlocked    
> > 
> > I think drivers and subdrivers should rather be fixed so that this
> > cannot happen.  

Agreed.

> 
> As long as stv6111 remains the only chip/driver interfacing with the
> stv0910, that's an easy task. However, if other hardware has some other
> stv0910+tunerchip combination, things get interesting. In a perfect
> world with unicorns and such, every component interacts as intended,
> but that's not the case, so I believe this should be handled at the
> root.

No matter what tuner/demod is used, if the locks there are not
properly handled, bad things will happen. So, if this patch is
needed for the driver(s) to work, it means that we have a serious
issue urging a real fix.

This ugly hack won't prevent it to happen. It just masks the
issue, by keeping the driver locked for more time than needed,
with possibly cause other issues.

> 
> > But to do this we will first need to define exactly how a failure in
> > gate_ctrl() is supposed to be handled, both inside gate_ctrl() and
> > by calling drivers.  
> 
> Well, IMHO (and thats the intention) if gate_ctrl fails due to a
> hardware/I2C problem, it isn't opened so there's no need to hold the
> lock (since the gate isn't - exclusively - opened). For reasons stated
> above this keeps things safe from deadlocking (and we want to avoid
> that, even more than double unlocking).
> 
> >  > consecutively which isn't allowed. Prevent this by keeping track
> >  > of the lock state, and actually call mutex_unlock() only when
> >  > certain the lock is held.    
> > 
> > Why not use mutex_is_locked()?  
> 
> Good catch (I should try harder finding out what the kernel API has to
> offer...). If you prefer that, I'll respin with this and without the
> var as v2.

I may consider accepting something like:

	WARN_ON(mutex_is_locked(mutex));

That will actually cause a bug at the driver with a stack dump,
with may lead to a proper fix on the drivers, instead of a hackish
solution that would just let the bug to stay there forever.

Thanks,
Mauro
