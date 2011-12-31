Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep21.mx.upcmail.net ([62.179.121.41]:42324 "EHLO
	fep21.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1LaKQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 05:16:11 -0500
Date: Sat, 31 Dec 2011 11:15:33 +0100
From: Dorozel Csaba <mrjuuzer@upcmail.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ir-kbd-i2c / rc-hauppauge / linux-3.x broken
In-Reply-To: <4EFDF229.8090103@redhat.com>
References: <20111230120658.DXPH19694.viefep13-int.chello.at@edge04.upcmail.net>
	<4EFDF229.8090103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20111231101532.GHMQ11861.viefep20-int.chello.at@edge04.upcmail.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Basically, the bridge driver is not sending the complete RC-5
> keycode to the IR core, but just the 8 least siginificant bits.
> So, it is loosing the 0x1e00 code for the Hauppauge grey remote.
> 
> The fix should be at saa7134-input. It should be something like
> the enclosed patch (I'm just guessing there that code3 contains
> the MSB bits - you may need to adjust it to match the IR decoder
> there):

I'm absolutly not a programer but an unhappy linux user who want his working remote back.
Know nothing about c code, MSB bits ... After apply your fix looks what happening but remote is
still broken.

user juuzer # ir-keytable -t
Testing events. Please, press CTRL-C to abort.
1325324726.066129: event MSC: scancode = de3d
1325324726.066131: event sync
1325324726.169132: event MSC: scancode = de3d
1325324726.169134: event sync
1325324727.508129: event MSC: scancode = fe3d
1325324727.508131: event sync
1325324727.611132: event MSC: scancode = fe3d
1325324727.611134: event sync
1325324730.084132: event MSC: scancode = de3d
1325324730.084134: event sync
1325324730.187132: event MSC: scancode = de3d

It seems the code3 sometimes return with de (11011110) sometimes fe (11111110). Is it possible
to bitwise left 3 then bitwise right 3 so the result in both case is 1e (00011110) ? Or its totaly
wrong ?

