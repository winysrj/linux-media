Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:47565 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0FHI4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 04:56:45 -0400
In-Reply-To: <AANLkTinavLdYZDZi1SjOyeKupWRX9kjA-Le7GFMQCWUB@mail.gmail.com>
Subject: Re: v4l-dvb - Is it still usable for a distribution ?
from: vdr@helmutauer.de
to: jarod@wilsonet.com
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20100608085644.73E9B10FC098@dd16922.kasserver.com>
Date: Tue,  8 Jun 2010 10:56:44 +0200 (CEST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

> > Is your imon driver fully compatible with the lirc_imon in the display part ?
> 
> Yes, works perfectly fine with the exact same lcdproc setup here --
> both vfd and lcd tested.
> 
> > It would be very helpful to add a parameter for disabling the IR Part, I have many users which
> > are using only the display part.
> 
> Hm. I was going to suggest that if people aren't using the receiver,
> there should be no need to disable IR, but I guess someone might want
> to use an mce remote w/an mce receiver, and that would have
> interesting results if they had one of the imon IR receivers
> programmed for mce mode. I'll keep it in mind for the next time I'm
> poking at the imon code in depth. Need to finish work on some of the
> other new ir/rc bits first (you'll soon be seeing the mceusb driver
> ported to the new infra also in v4l-dvb hg, as well as an lirc bridge
> driver, which is currently my main focal point).
> 
Just one more question.
Your driver is missing the ir_protocol parameter. How can I switch between Native Imon and RC-6 ?

Bye
Helmut Auer



