Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:26170 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbHVMp0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 08:45:26 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Petr Cvek <petr.cvek@tul.cz>, g.liakhovetski@gmx.de
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, philipp.zabel@gmail.com,
	daniel@zonque.org
Subject: Re: [PATCH v2 09/21] ARM: pxa: magician: Add OV9640 camera support
References: <cover.1439843482.git.petr.cvek@tul.cz>
	<2889798.x6xcIzdYMU@wuerfel> <55D65722.9030508@tul.cz>
	<1634812.ZDaECJ9ClW@wuerfel> <874mjs5yt2.fsf@belgarion.home>
	<55D7A186.4000505@tul.cz>
Date: Sat, 22 Aug 2015 14:41:10 +0200
In-Reply-To: <55D7A186.4000505@tul.cz> (Petr Cvek's message of "Sat, 22 Aug
	2015 00:09:10 +0200")
Message-ID: <87zj1j4hsp.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Petr Cvek <petr.cvek@tul.cz> writes:

>> So Guennadi, is it possible to add a gpio through platform data to ov9640
>> driver, does it make sense, and would you accept to have the reset handled there
>> ? And if yes, would you, Petr, accept to revamp your patch to have the reset and
>> power handled in ov9640 ?
>> 
>
> OK, why not, so power and reset gpio with polarity settings?
Even better pass ... nothing through platform-data.

I think there is now a gpio binding for devices which works this way :
 - in ov9640 : devm_gpiod_get(dev, "reset")
 - in magician: GPIO_LOOKUP() and gpiod_add_lookup_table()

In this way I think we'll gather at the same time :
 - no new platform data
 - ov9640 will follow the same path for devicetree and platform data

> Anyway I'm planning to send patch for OV9640 in future too (color correction
> matrix is not complete and some registers too).
Good.

Cheers.

-- 
Robert
