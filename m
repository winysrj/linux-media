Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58079 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab0KJWsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 17:48:23 -0500
Received: by ywc21 with SMTP id 21so143636ywc.19
        for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 14:48:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101110222418.6098a92a.ospite@studenti.unina.it>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
 <AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
 <AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com> <20101110222418.6098a92a.ospite@studenti.unina.it>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Wed, 10 Nov 2010 23:48:01 +0100
Message-ID: <AANLkTin+HtdoXO7+ObNCoix70knaL+Fi4725BOWVXuy9@mail.gmail.com>
Subject: Re: Bounty for the first Open Source driver for Kinect
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Markus Rechberger <mrechberger@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 10, 2010 at 10:24 PM, Antonio Ospite
<ospite@studenti.unina.it> wrote:
> If there are arguments against a kernel driver I can't see them yet.

+1
This device is a webcam+(other things), it should be handled similar
to other webcams already supported inside the kernel.
If we make an exception now, we should make many special hacks for
this only case to support it through the other libraries and layers of
the system.

If I want to use this device, I will add many userspace code to create
the skeleton model and that need much computation. Kernel Module adds
performance to my other code.

i
