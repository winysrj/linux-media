Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:49856 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3DWPjB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 11:39:01 -0400
Received: by mail-ea0-f172.google.com with SMTP id g14so335679eak.31
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 08:39:00 -0700 (PDT)
Message-ID: <5176AB5F.1050901@googlemail.com>
Date: Tue, 23 Apr 2013 17:40:15 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: "Michael ." <boycee_@hotmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Fwd: Device no longer handled by em28xx kernel drivers
References: <DUB118-W3105CA5468C478D0494A7687CE0@phx.gbl>,<516EF48C.2080804@iki.fi>,<DUB118-W43501C44B9B252CC5A03DD87CE0@phx.gbl> <DUB118-W30802FB90E04796F1FBDE187CF0@phx.gbl>
In-Reply-To: <DUB118-W30802FB90E04796F1FBDE187CF0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(forwarding to the linux-media mailing list) (2nd try)


Am 18.04.2013 21:04, schrieb Michael .:
> Hi
>
> I hope you don't mind me contacting you directly.

Issues like this should always be discussed on the linux-media mailing
list, so please CC it in the future.
Neither I'm the em28xx maintainer nor do I know much about issues/things
that happened in the past.

> I have a USB device which I was surprised to find is no longer handled
> by the driver:

What does "no longer handled" mean ?
What was the last kernel that supported this device ?

>
> Bus 001 Device 004: ID 0ccd:0072 TerraTec Electronic GmbH Cinergy Hybrid T
>
> I believe the hardware is em28xx + zl10353 + xc5000 as I can see my
> precise hardware being detected by em28xx in dmesg output here:

Yes, according to http://linux.terratec.de/tv_en.html it uses em2882+xc5000.

>
> http://doc.ubuntu-fr.org/terratec_cinergy_xs
>
> As I understand there might have been two parallel drivers being
> developed.

I never heard of a second driver.

> I just wondered if there is any chance of this support being
> re-instated for this particular one?
> I am surprised to find that a device has gone from supported to
> unsupported!

I don't know. The em28xx driver is generally the right driver and it
already supports other devices with the xc5000 tuner.
If support for this device has really been removed a while ago, then
there must have been good reasons...

Mauro, Devin ?

Regards,
Frank

>
>
> Cheers,
>
> Michael.

