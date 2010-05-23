Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35498 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0EWTSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 15:18:55 -0400
Received: by bwz7 with SMTP id 7so664345bwz.19
        for <linux-media@vger.kernel.org>; Sun, 23 May 2010 12:18:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <91E6C7608D34E145A3D9634F0ED7163E88873A@venus.logiways-france.fr>
References: <4BF290A2.1020904@free.fr> <4BF432E7.2000203@free.fr>
	 <alpine.DEB.2.01.1005201256140.29367@ureoreg>
	 <91E6C7608D34E145A3D9634F0ED7163E88873A@venus.logiways-france.fr>
Date: Sun, 23 May 2010 21:18:53 +0200
Message-ID: <AANLkTilgvpszr2yeDOnUS5MiJNSDpf42kVdBkn9kCOmh@mail.gmail.com>
Subject: Re: [linux-dvb] new DVB-T initial tuning for fr-nantes
From: Christoph Pfister <christophpfister@gmail.com>
To: Thierry LELEGARD <tlelegard@logiways.com>
Cc: linux-media@vger.kernel.org, Damien Bally <biribi@free.fr>,
	BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/5/20 Thierry LELEGARD <tlelegard@logiways.com>:
>> One thing that would be good to do -- for someone who is in the
>> area served by a transmitter -- rather than use «AUTO» for the
>> FEC and Guard Interval values above, would be to perform a NIT
>> scan on the appropriate frequencies.

You can also try to query the actual parameters from the frontend (but
that's again a different story).

<snip>
> I think that in such a moving environment, the "AUTO" choice is
> definitely better.

I still dislike "AUTO" in the dvb-apps repo, but I don't want to
invest more time in these things (you should be using autoscan
anyway).

> -Thierry

Thanks (committed Damien's version),

Christoph
