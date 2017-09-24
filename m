Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49455 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752241AbdIXMnB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 08:43:01 -0400
Date: Sun, 24 Sep 2017 13:42:59 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.15] RC cleanup fixes
Message-ID: <20170924124259.7dw7i4hax5chpnec@gofer.mess.org>
References: <20170923103356.hl5zrqekfjbsy7gt@gofer.mess.org>
 <20170923163531.3c1b1f06@vento.lan>
 <20170923203859.5msycu25qoqzy7iv@gofer.mess.org>
 <20170924060932.6e0962f1@vento.lan>
 <20170924104020.ni55zs5gtm7sklgw@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170924104020.ni55zs5gtm7sklgw@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 24, 2017 at 11:40:20AM +0100, Sean Young wrote:
> On Sun, Sep 24, 2017 at 06:09:32AM -0300, Mauro Carvalho Chehab wrote:
> > Ah, I see. Well, if none of the in-kernel drivers use it, we can
> > drop it.
> 
> Looks like our emails crossed each other -- I have already pushed out
> another PR without it.

So I force pushed a new version with this commit dropped. That probably
wasn't the right thing to do.

Should you prefer the original request without min/max timeout dropped for
lirc kapi drivers, please note that the original pull request now has
branch name v4.15a-v1 (commit fe96866c81291a2887559fdfcc58ddf8fe54111d,
as the pull request says.

Sorry about that.


Sean
