Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54925 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3LSQ7u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 11:59:50 -0500
Received: by mail-wg0-f41.google.com with SMTP id y10so5956491wgg.2
        for <linux-media@vger.kernel.org>; Thu, 19 Dec 2013 08:59:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52B323F0.2050701@iki.fi>
References: <1387231688-8647-1-git-send-email-crope@iki.fi>
	<1387231688-8647-7-git-send-email-crope@iki.fi>
	<52B2BA92.8080706@xs4all.nl>
	<52B323F0.2050701@iki.fi>
Date: Thu, 19 Dec 2013 11:59:49 -0500
Message-ID: <CAGoCfiz1kWHXPC-b-Exw=AYrNeOzaCgSvr3+zLuf12g5gyYJxA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 6/7] rtl2832_sdr: convert to SDR API
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I haven't
> looked situation more carefully yet, but one thing that must be done at the
> very first is to add some lock to prevent only DVB or V4L2 API could access
> the hardware at time.

Probably worth mentioning that we have *lots* of devices that suffer
from this problem.  Our general tact has to been to do nothing and let
the driver crash and burn in non-predictable ways when userland tries
to use both APIs at the same time.

So while it's pretty pathetic that we still haven't resolved this
after all these years, if you didn't address the issue in the initial
release then you wouldn't be much worse off than lots of other
devices.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
