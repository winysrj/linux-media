Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757960Ab0FFP1p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jun 2010 11:27:45 -0400
Message-ID: <4C0BBE58.6000504@redhat.com>
Date: Sun, 06 Jun 2010 12:27:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 and ir
References: <4C096A05.2010907@arcor.de>
In-Reply-To: <4C096A05.2010907@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

Em 04-06-2010 18:03, Stefan Ringel escreveu:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> Hi Mauro,
> 
> I write actually the ir implementation (tm6000-input.c). Can you give
> me any stuff what can help me?

I never tried to implement IR support for tm6000, but if you use the
em28xx-input as reference, it shouldn't be hard to add support for IR.

I suspect that tm6000 have a hardware/firmware IR decoder, probably
capable of handling NEC and RC-5 protocols. 

Probably, all that you need to do is to send some initialization sequence
at tm6000-input and periodically try to get data via URB (for example, you
may run a workqueue or a timer, on every 50 ms, checking for the code 
reception). You may use the rc-empty table on your initial tests and, after
having it working, you'll need to create a keymap table with your IR.

Cheers,
Mauro.
