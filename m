Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep15.mx.upcmail.net ([62.179.121.35]:54039 "EHLO
	fep15.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1LaLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 06:47:20 -0500
Date: Sat, 31 Dec 2011 12:47:18 +0100
From: Dorozel Csaba <mrjuuzer@upcmail.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ir-kbd-i2c / rc-hauppauge / linux-3.x broken
In-Reply-To: <4EFEECF4.3010709@redhat.com>
References: <20111230120658.DXPH19694.viefep13-int.chello.at@edge04.upcmail.net>
	<4EFDF229.8090103@redhat.com>
	<20111231101532.GHMQ11861.viefep20-int.chello.at@edge04.upcmail.net>
	<4EFEECF4.3010709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20111231114717.TBV1347.viefep15-int.chello.at@edge04.upcmail.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> An RC-5 code is just 14 bits. I found some Hauppauge decoders returning
> just 12 bits on some places. It seems that all it needs is to do a
> code3 | 0x3f, in order to discard the two most significant bits (MSB).
> 
> So, the enclosed patch should fix the issues. Please test.

Half way .. something still wrong.

user juuzer # ir-keytable -t -d /dev/input/event6
Testing events. Please, press CTRL-C to abort.
1325331995.343188: event MSC: scancode = 3e3d
1325331995.343190: event sync
1325331995.446127: event MSC: scancode = 3e3d
1325331995.446129: event sync
1325331997.504133: event MSC: scancode = 1e3d
1325331997.504135: event key down: KEY_POWER2 (0x0164)
1325331997.504136: event sync
1325331997.607137: event MSC: scancode = 1e3d
1325331997.607138: event sync
1325331997.857161: event key up: KEY_POWER2 (0x0164)
1325331997.857163: event sync
1325331999.973135: event MSC: scancode = 3e3d
1325331999.973136: event sync
1325332000.075130: event MSC: scancode = 3e3d
1325332000.075131: event sync
