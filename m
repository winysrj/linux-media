Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:44564 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249Ab1H1Vlt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 17:41:49 -0400
Message-ID: <7828b98aef099b57693c20a829b28f75.squirrel@ssl-webmail-vh.clara.net>
Date: Sun, 28 Aug 2011 22:07:26 +0100
Subject: AVerMedia HC82R Hybrid NanoExpress (saa716x)
From: markk@clara.co.uk
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

[I'm not subscribed to this list.]

The AVerMedia HC82R "AVerTV Hybrid NanoExpress" is a hybrid analogue/DVB-T
ExpressCard with A/V input.

I have a Dell OEM version of this card, which has PCI vendor:product ID
1131:7160, subsystem 1461:0555. The current saa716x source from
http://jusst.de/hg/saa716x doesn't recognise it because its subsystem ID
differs from the normal HC82R value (1461:2355).

For my card:
$ lspci -vvv -nn -d1131:7160
05:00.0 Multimedia controller [0480]: Philips Semiconductors Device
[1131:7160] (rev 03)
	Subsystem: Avermedia Technologies Inc Device [1461:0555]
	...

For testing, I changed a line in saa716x_hybrid.h from
#define AVERMEDIA_HC82		0x2355
to
#define AVERMEDIA_HC82		0x0555
and with that change my card was recognised when inserted.

Maybe someone would like to write a patch to add support for the alternate
subsystem ID?


Mark


