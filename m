Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751570AbdBBMWl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 07:22:41 -0500
Date: Thu, 2 Feb 2017 13:22:39 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lee Jones <lee@kernel.org>, Eric Anholt <eric@anholt.net>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-rpi-kernel@lists.infradead.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] staging: bcm2835: mark all symbols as 'static'
Message-ID: <20170202122239.GA12572@kroah.com>
References: <20170202113436.690145-1-arnd@arndb.de>
 <CAK8P3a0TMW+GrdbLPqBDKyqXaP-LvYkGfD5bfcW4W6dXMnHy1A@mail.gmail.com>
 <CAK8P3a3W0q8NjZdY9Wc328o6dCwkkod1k0zFqYtrkuvXwO_5dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3W0q8NjZdY9Wc328o6dCwkkod1k0zFqYtrkuvXwO_5dw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 02, 2017 at 01:11:36PM +0100, Arnd Bergmann wrote:
> On Thu, Feb 2, 2017 at 1:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thu, Feb 2, 2017 at 12:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> I got a link error in allyesconfig:
> >> Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >
> > Please disregard this patch version, it's broken.
> 
> Too late, I see it's already applied, I'll send a follow-up to revert
> the first hunk.

Ah, I could have just dropped your patch (it's a testing branch that I
can rebase), but I took your newer patch that fixed it up, so all is
good.

That's what I get for applying patches too quickly :)

thanks,

greg k-h
