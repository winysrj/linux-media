Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35176 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162205AbeBNSoy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 13:44:54 -0500
Date: Wed, 14 Feb 2018 16:44:48 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.17] rc changes
Message-ID: <20180214164448.32a4c989@vento.lan>
In-Reply-To: <20180212200318.cxnxro2vsqauexqz@gofer.mess.org>
References: <20180212200318.cxnxro2vsqauexqz@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

Em Mon, 12 Feb 2018 20:03:18 +0000
Sean Young <sean@mess.org> escreveu:

> Hi Mauro,
> 
> Just very minor changes this time (other stuff is not ready yet). I would
> really appreciate if you could cast an extra critical eye on the commit 
> "no need to check for transitions", just to be sure it is the right change.

Did you send all patches in separate? This is important to allow us
to comment on an specific issue inside a patch...

>       media: rc: no need to check for transitions

I don't remember the exact reason for that, but, as far as I
remember, on a few devices, a pulse (or space) event could be
broken into two consecutive events of the same type, e. g.,
a pulse with a 125 ms could be broken into two pulses, like
one with 100 ms and the other with 25 ms.

That's said, I'm not sure if the current implementation are
adding the timings for both pulses into a single one.

For now, I'll keep this patch out of the merge.

Thanks,
Mauro
