Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63854 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535AbaKNO4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 09:56:49 -0500
Received: by mail-pa0-f49.google.com with SMTP id lj1so17549710pab.22
        for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 06:56:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m3lhneez9h.fsf@t19.piap.pl>
References: <m3lhneez9h.fsf@t19.piap.pl>
Date: Fri, 14 Nov 2014 18:56:48 +0400
Message-ID: <CANZNk82C9SmBXx4T=CxRjLGOZPuRdahwF4mXYUk8pJ427vdCPQ@mail.gmail.com>
Subject: Re: SOLO6x10: fix a race in IRQ handler.
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: =?ISO-8859-2?Q?Krzysztof_Ha=B3asa?= <khalasa@piap.pl>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-11-14 16:35 GMT+04:00 Krzysztof Hałasa <khalasa@piap.pl>:
> The IRQs have to be acknowledged before they are serviced, otherwise some events
> may be skipped. Also, acknowledging IRQs just before returning from the handler
> doesn't leave enough time for the device to deassert the INTx line, and for
> bridges to propagate this change. This resulted in twice the IRQ rate on ARMv6
> dual core CPU.

Thanks!
I'm not experienced in interaction with hardware in this regard...
could you please point to some reading which explains this moment? Or
you just know this from experience? The solo device specs are very
terse about this, so I considered that it should work fine without
regard to how fast we write back to that register.

-- 
Andrey Utkin
