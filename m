Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34964 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbbKLKNb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 05:13:31 -0500
MIME-Version: 1.0
In-Reply-To: <1743324.8Mae4aQqGO@avalon>
References: <1447162740-28096-1-git-send-email-ulrich.hecht+renesas@gmail.com>
	<1743324.8Mae4aQqGO@avalon>
Date: Thu, 12 Nov 2015 11:13:30 +0100
Message-ID: <CAMuHMdUO9a7WtiJxAqbhvkY1kfMkFLUnOrogd0Jvh1GqySubWg@mail.gmail.com>
Subject: Re: [PATCH] media: adv7180: increase delay after reset to 5ms
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 12, 2015 at 12:10 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> (CC'ing Lars-Peter Clausen)
>
> Thank you for the patch.
>
> On Tuesday 10 November 2015 14:39:00 Ulrich Hecht wrote:
>> Initialization of the ADV7180 chip fails on the Renesas R8A7790-based
>> Lager board about 50% of the time.  This patch resolves the issue by
>> increasing the minimum delay after reset from 2 ms to 5 ms, following the
>> recommendation in the ADV7180 datasheet:
>>
>> "Executing a software reset takes approximately 2 ms. However, it is
>> recommended to wait 5 ms before any further I2C writes are performed."
>>
>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Lars, would you like to take this in your tree with other Analog Devices
> patches, or should I take it ?

Which tree is this? Should I include it in renesas-drivers?
Does it contain more fixes?

During the s2ram suspend phase, the lockdep_assert_held() in adv7180_write()
is triggered on r8a7791/koelsch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
