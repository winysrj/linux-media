Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33056 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdBBMew (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 07:34:52 -0500
MIME-Version: 1.0
In-Reply-To: <20170202122239.GA12572@kroah.com>
References: <20170202113436.690145-1-arnd@arndb.de> <CAK8P3a0TMW+GrdbLPqBDKyqXaP-LvYkGfD5bfcW4W6dXMnHy1A@mail.gmail.com>
 <CAK8P3a3W0q8NjZdY9Wc328o6dCwkkod1k0zFqYtrkuvXwO_5dw@mail.gmail.com> <20170202122239.GA12572@kroah.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 2 Feb 2017 13:34:51 +0100
Message-ID: <CAK8P3a0KOTRL7xMdm80ijZ54=Qfyyhnww2O220OTTw6qpPgj+Q@mail.gmail.com>
Subject: Re: [PATCH] [media] staging: bcm2835: mark all symbols as 'static'
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 2, 2017 at 1:22 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Feb 02, 2017 at 01:11:36PM +0100, Arnd Bergmann wrote:
>> On Thu, Feb 2, 2017 at 1:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Thu, Feb 2, 2017 at 12:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> I got a link error in allyesconfig:
>> >> Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
>> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> >
>> > Please disregard this patch version, it's broken.
>>
>> Too late, I see it's already applied, I'll send a follow-up to revert
>> the first hunk.
>
> Ah, I could have just dropped your patch (it's a testing branch that I
> can rebase), but I took your newer patch that fixed it up, so all is
> good.
>
> That's what I get for applying patches too quickly :)

I should really have been more careful about testing. I had the first
version in my
working tree while doing randconfig tests. None of the new randconfig builds
ran into the issue (the driver gets rarely enabled because of its dependencies),
and the original failure had already been marked as fixed in my build system
after an earlier patch only changed one of the prototypes.

    Arnd
