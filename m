Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35999 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab3GRKDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 06:03:23 -0400
Received: by mail-oa0-f49.google.com with SMTP id n9so973332oag.36
        for <linux-media@vger.kernel.org>; Thu, 18 Jul 2013 03:03:22 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Jul 2013 11:03:22 +0100
Message-ID: <CAGj5WxBwGg0sUN-SSQsamYu2sB0mpE3HFf5RkdUkfd_rW9iTUg@mail.gmail.com>
Subject: Re: [PATCH] cx23885: Fix interrupt storm that happens in some cards
 when IR is enabled.
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry if I wasn't clear, but this patch is not intended to be merged
in the main tree (as it is).
I've sent it so that people facing this interrupt storm when IR is
enabled can test it in their cards (I only have the TBS6981 to test
and it works).
Probably I should have just sent a mail with a code sample...

About what it does, I don't have a clue! I just know that it does
silence the interrupt spam.
My best guess is that the IR interrupt line is shared with the ADC
interrupt line and maybe the ADC is generating an end-of-conversion
interrupt by default.
And touching this register can be disabling the ADC interrupts - or
powering down the ADC - or just disabling the ADC clock.

It would be valuable for other people that have this issues in their
cards to test and then make a proper patch to the cx23885.

If this doesn't work with other cards, then I'll just add those two
lines to be specific to my card init code.

Thanks and Regards,
Luis
