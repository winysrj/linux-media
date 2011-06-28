Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38786 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab1F1Frx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 01:47:53 -0400
Received: by iyb12 with SMTP id 12so4662559iyb.19
        for <linux-media@vger.kernel.org>; Mon, 27 Jun 2011 22:47:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=we3eOeFq6ru245i20e5uD-YRyMA@mail.gmail.com>
References: <4DFFA7B6.9070906@free.fr>
	<4DFFA917.5060509@iki.fi>
	<4E017D7D.4050307@free.fr>
	<BANLkTimQymz5K6YhhUgPeWjMFkkVoU6j4A@mail.gmail.com>
	<4E079E9F.7050004@free.fr>
	<1309125622.5421.15.camel@wide>
	<BANLkTi=we3eOeFq6ru245i20e5uD-YRyMA@mail.gmail.com>
Date: Tue, 28 Jun 2011 07:47:51 +0200
Message-ID: <BANLkTinVNv429OC-6pyO4-epAmCE7rYYwQ@mail.gmail.com>
Subject: Re: Updates to French scan files
From: Christoph Pfister <christophpfister@gmail.com>
To: Johann Ollivier Lapeyre <johann.ollivierlapeyre@gmail.com>
Cc: Alexis de Lattre <alexis@via.ecp.fr>, mossroy <mossroy@free.fr>,
	linux-media@vger.kernel.org, n_estre@yahoo.fr, alkahan@free.fr,
	ben@geexbox.org, xavier@dalaen.com, jean-michel.baudrey@orange.fr,
	lissyx@dyndns.org, sylvestre.cartier@gmail.com,
	brossard.damien@gmail.com, jean-michel-62@orange.fr
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/27 Johann Ollivier Lapeyre <johann.ollivierlapeyre@gmail.com>:
> Dear LinuxTV friends,
>
>> In order to simplify things, I would propose only ONE scan file with
>> offset -166, 0, 166, 333 and 500. OK, it will take more time for users
>> to run a scan (+66 %) compared to having a file with only offsets -166,
>> 0, 166 but at least we are sure to cover all the possible offset that
>> can be used in France, and we simplify things as much as we can for
>> users.
<snip>

There are five files,
- auto-Default
- auto-With167kHzOffsets
- auto-Australia
- auto-Italy
- auto-Taiwan

which cover all dvb-t transmitters known to me. If your device can
deal with auto* parameters, they're sufficient. (some / many?) devices
can also deal with the 167kHz offset automatically. It is extremely
unlikely that one of the other offsets will be used in future, so I
wait for evidence before I take any action there.

Christoph
