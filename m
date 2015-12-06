Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.eqx.gridhost.co.uk ([95.142.156.2]:60515 "EHLO
	mail1.eqx.gridhost.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbbLFJg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2015 04:36:59 -0500
Received: from [209.85.192.42] (helo=mail-qg0-f42.google.com)
	by mail1.eqx.gridhost.co.uk with esmtpsa (UNKNOWN:AES128-GCM-SHA256:128)
	(Exim 4.72)
	(envelope-from <olli.salonen@iki.fi>)
	id 1a5Vk3-000179-Cx
	for linux-media@vger.kernel.org; Sun, 06 Dec 2015 09:36:27 +0000
Received: by qgec40 with SMTP id c40so123109671qge.2
        for <linux-media@vger.kernel.org>; Sun, 06 Dec 2015 01:36:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5663EBBF.6060504@freenet.de>
References: <5663EBBF.6060504@freenet.de>
Date: Sun, 6 Dec 2015 11:36:26 +0200
Message-ID: <CAAZRmGw3yL04NYrCLJ30m0jCowT5X2qem4K77RKtO69XVnm+1w@mail.gmail.com>
Subject: Re: Changes in dw2102.c to support my Tevii S662
From: Olli Salonen <olli.salonen@iki.fi>
To: =?UTF-8?Q?Steffen_G=C3=BCnther?= <stguenth@freenet.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steffen,

The patch itself looks valid. If you could submit it in a formally
correct format it could probably be added to the linux-media tree for
other people's enjoyment as well. Have a look at points 2, 6, 10 and
11 in the following link:
https://www.kernel.org/doc/Documentation/SubmittingPatches

Cheers,
-olli

On 6 December 2015 at 10:03, Steffen Günther <stguenth@freenet.de> wrote:
> Hi,
>
> I made some small changes on top of this patch
>
> https://patchwork.linuxtv.org/patch/28925/
>
> to support my Tevii S662 with module dvb-usb-dw2102.
>
> Scanning and tuning in works for me.
>
> Hope this is usefull!?
>
> Regards
> Steffen
