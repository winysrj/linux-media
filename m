Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56851 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2CZOkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 10:40:33 -0400
Received: by obbeh20 with SMTP id eh20so5238800obb.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 07:40:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <assp.44329f40f0.1332772017.28771.12.camel@paddy.ipb-sub.ipb-halle.de>
References: <assp.44329f40f0.1332772017.28771.12.camel@paddy.ipb-sub.ipb-halle.de>
Date: Mon, 26 Mar 2012 11:40:32 -0300
Message-ID: <CALF0-+UH4BQGYRwNAFD9Lub-5WEBp2XhbQ_afYh+aKaCEL_mkA@mail.gmail.com>
Subject: Re: Hauppauge WinTV HVR 930C-HD - new USB ID 2040:b130 ?
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Steffen Neumann <sneumann@ipb-halle.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2012/3/26 Steffen Neumann <sneumann@ipb-halle.de>:
> sorry for bothering you directly, but I saw that

No problem.

> you kinda work on em288xx. I asked yesterday on linux-media

True about "kinda", I don't own any em28xx devices :)

> about my problems with the em28xx based 930C
> on a 3.3 vanilla kernel.

Yes, I saw the mail. I think indeed you have a device
that is not supported (yet?) by em28xx.
If lsusb says 2040:b130 rather than 2040:1605 then
I guess it's a new kind of device, different chipset,
I'm not sure (not an expert, sorry).

>
> Is this this the correct list to ask,
> and I just need to have more patience ?
> Or should I bring the issue up somewhere else ?

Not sure wherelse you can post your question.
Just wait for a while and ping again in a few weeks,
or so. I believe we are in the middle of a merge window
so developers are a little busy right now.

Hope it helps!
Ezequiel.
