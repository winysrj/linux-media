Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38039 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0FHDk2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 23:40:28 -0400
Received: by vws17 with SMTP id 17so897432vws.19
        for <linux-media@vger.kernel.org>; Mon, 07 Jun 2010 20:40:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C0D63AF.7090203@helmutauer.de>
References: <20100607112744.7B3B010FC20F@dd16922.kasserver.com>
	<4C0CF124.4010103@redhat.com>
	<AANLkTinisZ5DtH1Izn6WZS8isrF_G3oFZuppoHuwhlUj@mail.gmail.com>
	<4C0D63AF.7090203@helmutauer.de>
Date: Mon, 7 Jun 2010 23:40:27 -0400
Message-ID: <AANLkTinavLdYZDZi1SjOyeKupWRX9kjA-Le7GFMQCWUB@mail.gmail.com>
Subject: Re: v4l-dvb - Is it still usable for a distribution ?
From: Jarod Wilson <jarod@wilsonet.com>
To: Helmut Auer <vdr@helmutauer.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 7, 2010 at 5:25 PM, Helmut Auer <vdr@helmutauer.de> wrote:
...
> Is your imon driver fully compatible with the lirc_imon in the display part ?

Yes, works perfectly fine with the exact same lcdproc setup here --
both vfd and lcd tested.

> It would be very helpful to add a parameter for disabling the IR Part, I have many users which
> are using only the display part.

Hm. I was going to suggest that if people aren't using the receiver,
there should be no need to disable IR, but I guess someone might want
to use an mce remote w/an mce receiver, and that would have
interesting results if they had one of the imon IR receivers
programmed for mce mode. I'll keep it in mind for the next time I'm
poking at the imon code in depth. Need to finish work on some of the
other new ir/rc bits first (you'll soon be seeing the mceusb driver
ported to the new infra also in v4l-dvb hg, as well as an lirc bridge
driver, which is currently my main focal point).

-- 
Jarod Wilson
jarod@wilsonet.com
