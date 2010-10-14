Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45421 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab0JNAum (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 20:50:42 -0400
Received: by ewy20 with SMTP id 20so2808365ewy.19
        for <linux-media@vger.kernel.org>; Wed, 13 Oct 2010 17:50:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101013173010.74ee2827@glory.local>
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>
	<AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>
	<20100525114939.067404eb@glory.loctelecom.ru>
	<4C32044C.3060007@redhat.com>
	<AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>
	<20101013173010.74ee2827@glory.local>
Date: Wed, 13 Oct 2010 20:50:40 -0400
Message-ID: <AANLkTimuunSAwewBRaq0hg-c11utF=Lj0v3b=1+3k4Ag@mail.gmail.com>
Subject: Re: [PATCH] xc5000 and switch RF input
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Oct 13, 2010 at 5:30 PM, Dmitri Belimov <d.belimov@gmail.com> wrote:
> Hi
>
> Our TV card Behold X7 has two different RF input. This RF inputs can switch between
> different RF sources.
>
> ANT 1 for analog and digital TV
> ANT 2 for FM radio
>
> The switch controlled by zl10353.
>
> I add some defines for the tuner xc5000 and use tuner callback to saa7134 part.
> All works well. But my patch can touch other TV cards with xc5000.
>
> Devin can you check my changes on the other TV cards.
>
> With my best regards, Dmitry.

Hello Dmitri,

I've looked at the patch.  I really don't think this is the right
approach.  The tuner driver should not have any of this logic - it
should be in the bridge driver.  You can also look at Michael Krufky's
frontend override patches, which allow the bridge to intervene when
DVB frontend commands are made (for example, to toggle the antenna
before the tune is performed).

I understand the problem you are trying to solve, but jamming the
logic into the tuner driver really is a bad idea.

NACK.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
