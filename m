Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:35977 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab0BHPgq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 10:36:46 -0500
Received: by bwz23 with SMTP id 23so1238731bwz.1
        for <linux-media@vger.kernel.org>; Mon, 08 Feb 2010 07:36:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265587839.4186.16.camel@localhost>
References: <1265587839.4186.16.camel@localhost>
Date: Mon, 8 Feb 2010 10:36:44 -0500
Message-ID: <829197381002080736k171aea8bx455704e960650ef2@mail.gmail.com>
Subject: Re: Any saa711x users out there?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for taking the time to do some testing in your environment.

On Sun, Feb 7, 2010 at 7:10 PM, Andy Walls <awalls@radix.net> wrote:
> My observations:
>
> 1. With the amplifier on and anti-alias filter off things looked fine.
> 2. With the amplifier on and anti-alias filter on things looked fine.
> 3. With the amplifier off and anti-alias filter off things looked fine.
> 4. With the amplifier off and anti-alias filter on the screen washed brighter/whiter.
>
> I guess the anti-alias filter peaks the luma a little or attenuates the color a little.
> The amplifier and AGC is probably essential when using the anti-alias filter.

This all looks like good news, suggesting that under most conditions
people won't notice the difference (except in the signal conditions I
saw, in which case they will see a rather significant positive
improvement).  And since we don't let users independently control the
AA filter nor the amplifier, we can be confident that there won't be a
case when the amplifier is on but the AA filter is off.

My vote is to just push the one line change then flipping on the AA
filter in the saa7115_init_misc array of registers (essentially the
patch below):

http://kernellabs.com/hg/~dheitmueller/em28xx-test/rev/42272c1dd883

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
