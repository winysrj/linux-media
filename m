Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:35462 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753093AbdJUJ2U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Oct 2017 05:28:20 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23019.4906.236885.50919@morden.metzler>
Date: Sat, 21 Oct 2017 11:28:10 +0200
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at
Subject: [PATCH] [media] dvb-frontends/stv0910: prevent consecutive mutex_unlock()'s
In-Reply-To: <20171021083641.7226-1-d.scheller.oss@gmail.com>
References: <20171021083641.7226-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Scheller writes:
 > From: Daniel Scheller <d.scheller@gmx.net>
 > 
 > When calling gate_ctrl() with enable=0 if previously the mutex wasn't
 > locked (ie. on enable=1 failure and subdrivers not handling this properly,
 > or by otherwise badly behaving drivers), the i2c_lock could be unlocked

I think drivers and subdrivers should rather be fixed so that this
cannot happen.
But to do this we will first need to define exactly how a failure in
gate_ctrl() is supposed to be handled, both inside gate_ctrl() and
by calling drivers.


 > consecutively which isn't allowed. Prevent this by keeping track of the
 > lock state, and actually call mutex_unlock() only when certain the lock
 > is held.

Why not use mutex_is_locked()?
And there should be a debug message if it (tried double unlocking) happens.


Regards,
Ralph
