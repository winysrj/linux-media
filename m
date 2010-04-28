Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43713 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0D1NNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 09:13:40 -0400
Received: by fxm10 with SMTP id 10so551864fxm.19
        for <linux-media@vger.kernel.org>; Wed, 28 Apr 2010 06:13:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100428103303.2fe4c9ea@zombie>
References: <20100411231805.4bc7fdef@borg.bxl.tuxicoman.be>
	 <4BD7E7A3.2060101@web.de> <20100428103303.2fe4c9ea@zombie>
Date: Wed, 28 Apr 2010 17:13:36 +0400
Message-ID: <r2y1a297b361004280613s10585a6we3d14ddb9de5bcfc@mail.gmail.com>
Subject: Re: [PATCH] TT S2-1600 allow more current for diseqc
From: Manu Abraham <abraham.manu@gmail.com>
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 28, 2010 at 12:33 PM, Guy Martin <gmsoft@tuxicoman.be> wrote:
> On Wed, 28 Apr 2010 09:45:39 +0200
> André Weidemann <Andre.Weidemann@web.de> wrote:
>
>> I advise not to pull this change into the kernel sources.
>> The card has only been testet with the a maximum current of 515mA.
>> Anything above is outside the specification for this card.
>
>
> I'm currently running two of these cards in the same box with this
> patch.
> Actually, later on I've even set curlim = SEC_CURRENT_LIM_OFF because
> sometimes diseqc wasn't working fine and that seemed to solve the
> problem.

I would advise to not do this: since disabling current limiting etc
will cause a large problem in the case of a short circuit thereby no
protection to the hardware. In such an event, it could probably damage
the tracks carrying power on the card as well as the tracks on the
motherboard, and in some cases the gold finches themselves and or the
PCI connector.

Generally, there are only a few devices capable of sourcing > 0.5A, So
I wonder ....

Regards,
Manu
