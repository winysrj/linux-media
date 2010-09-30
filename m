Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37742 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab0I3Sw1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 14:52:27 -0400
Received: by bwz11 with SMTP id 11so1648345bwz.19
        for <linux-media@vger.kernel.org>; Thu, 30 Sep 2010 11:52:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100928154659.0e7e4147@pedra>
References: <cover.1285699057.git.mchehab@redhat.com>
	<20100928154659.0e7e4147@pedra>
Date: Thu, 30 Sep 2010 14:52:25 -0400
Message-ID: <AANLkTik_3MSjyqokvam28g5ohhCP=bb=_uzyzK0iM8Et@mail.gmail.com>
Subject: Re: [PATCH 08/10] V4L/DVB: tda18271: allow restricting max out to 4 bytes
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Sep 28, 2010 at 2:46 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> By default, tda18271 tries to optimize I2C bus by updating all registers
> at the same time. Unfortunately, some devices doesn't support it.
>
> The current logic has a problem when small_i2c is equal to 8, since there
> are some transfers using 11 + 1 bytes.
>
> Fix the problem by enforcing the max size at the right place, and allows
> reducing it to max = 3 + 1.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

This looks to me as if it is working around a problem on the i2c
master.  I believe that a fix like this really belongs in the i2c
master driver, it should be able to break the i2c transactions down
into transactions that the i2c master can handle.

I wouldn't want to merge this without a better explanation of why it
is necessary in the tda18271 driver.  It seems to be a band-aid to
cover up a problem in the i2c master device driver code.

Regards,

Mike Krufky
