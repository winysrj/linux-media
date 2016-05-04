Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34456 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbcEDR6U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 13:58:20 -0400
MIME-Version: 1.0
In-Reply-To: <20160504063902.0af2f4d7@mir>
References: <20160315080552.3cc5d146@recife.lan>
	<20160503233859.0f6506fa@mir>
	<CA+55aFxAor=MJSGFkynu72AQN75bNTh9kewLR4xe8CpjHQQvZQ@mail.gmail.com>
	<20160504063902.0af2f4d7@mir>
Date: Wed, 4 May 2016 10:58:19 -0700
Message-ID: <CA+55aFyE82Hi29az_MG9oG0=AEg1o++Wng_DO2RvNHQsSOz87g@mail.gmail.com>
Subject: Re: [GIT PULL for v4.6-rc1] media updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 3, 2016 at 9:39 PM, Stefan Lippers-Hollmann <s.l-h@gmx.de> wrote:
>
> Just as a cross-check, this (incomplete, but au0828, cx231xx and em28xx
> aren't needed/ loaded on my system) crude revert avoids the problem for
> me on v4.6-rc6-113-g83858a7.

Hmm.

That just open-codes __media_device_usb_init().

The main difference seems to be that __media_device_usb_init() ends up
having that

     #ifdef CONFIG_USB
     #endif

around it.

I think that is bogus.

What happens if you replace that #ifdef CONFIG_USB in
__media_device_usb_init() with

    #if CONFIG_USB || (MODULE && CONFIG_USB_MODULE)

or alternatively just build with USB compiled in?

Mauro: that __media_device_usb_init() thing does seem to be completely
buggered for the modular USB case.

                Linus
