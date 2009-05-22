Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:64298 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034AbZEVP2z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 11:28:55 -0400
Received: by pzk7 with SMTP id 7so1364540pzk.33
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 08:28:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243003530.24983.8.camel@pc67246619>
References: <1243003530.24983.8.camel@pc67246619>
Date: Fri, 22 May 2009 11:28:52 -0400
Message-ID: <829197380905220828i2b8cf7e4h6f067b996fd72fab@mail.gmail.com>
Subject: Re: Review of the Linux driver for the TerraTec Cinergy HTC USB XS HD
	stick
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ad Denissen <ad.denissen@hccnet.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 22, 2009 at 10:45 AM, Ad Denissen <ad.denissen@hccnet.nl> wrote:
> Hi Markus,
>
> I have a TerraTec Cinergy HTC USB XS HD stick and more than 10 years of
> experience with Linux (drivers).
>
> This USB stick works fine under Windows, but I need it under Linux
> for my MythTV experiments in DVB-C mode.
>
> Can I help you in the cleanup of the Linux driver for this device?
>
> Kind regards,
>
> Ad Denissen

Hello Ad,

The TerraTec Cinergy HTC USB XS HD makes use of the Micronas drx-k
demodulator.  There is currently no driver at all for this device in
the mainline Linux kernel.  As a result, getting the device to work in
the mainline kernel is much more than "cleanup".

Markus's support for the drx-k uses his closed source product, and
therefore is not eligible for inclusion in the Linux kernel.  You may
wish to contact him though if you are interested in a commercial
closed source solution.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
