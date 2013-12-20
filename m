Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:40626 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3LTF6q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 00:58:46 -0500
Message-ID: <52B3DC91.5070709@gentoo.org>
Date: Fri, 20 Dec 2013 06:58:41 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
CC: =?ISO-8859-1?Q?Sven_M=FCller?= <xpert-reactos@gmx.de>
Subject: Questions on how to add support for DVB-C/T on HVR4400 and HVR5500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I am trying to also add support for for using SI2165 driver on HVR4400
and HVR5500 cards.

The pci subdevice id of the HVR5500 (0x0070:0xc138) is assigned to
HVR4400 in cx23885-cards.c.
Is that just because the DVB-S2 part is identical, to not add redundant
code? In this case I could just modify it to a new HVR5500 enum value.

How is a second demod wired to cx23885 in this case? Is this done via
another port, so portb for DVB-S/S2 and portc for DVB-C/T?

On HVR5500, there is a device at i2c addr 0x60, this could either be a
tuner (NXP 18271C2?) or the demod SI2165.

Or is there a need to change gpio values to get the demod out of the reset?

Does the HVR4400 contain a SI2161 demod? I cannot read the name on the
pictures, but it looks very similar the SI2165.

Regards
Matthias
