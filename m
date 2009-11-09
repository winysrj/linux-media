Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56287 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZKICeA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 21:34:00 -0500
Received: by bwz27 with SMTP id 27so3012302bwz.21
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 18:34:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
References: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
	 <829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
	 <cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
Date: Sun, 8 Nov 2009 21:34:04 -0500
Message-ID: <829197380911081834v445d36c1yd931c5af69a21505@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Barry Williams <bazzawill@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 8, 2009 at 9:01 PM, Barry Williams <bazzawill@gmail.com> wrote:
> On the first box I have
> Bus 003 Device 003: ID 0fe9:db98 DVICO
> Bus 003 Device 002: ID 0fe9:db98 DVICO
>
> on the second
> Bus 001 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
> (ZL10353+xc2028/xc3028) (initialized)
> Bus 001 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
> (ZL10353+xc2028/xc3028) (initialized)

And on which of the two systems are you still having the tuning
problem with?  Also, did you reboot after you installed the patch?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
