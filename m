Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:51089 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab0AEXTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 18:19:42 -0500
Received: by fxm25 with SMTP id 25so10305085fxm.21
        for <linux-media@vger.kernel.org>; Tue, 05 Jan 2010 15:19:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d5cd75471001050743n761e82d9ub5d59689dd4ccd28@mail.gmail.com>
References: <d5cd75471001050743n761e82d9ub5d59689dd4ccd28@mail.gmail.com>
Date: Wed, 6 Jan 2010 03:19:40 +0400
Message-ID: <1a297b361001051519l18c71475y7aa6e39095134314@mail.gmail.com>
Subject: Re: Terratec Cinergy C PCI HD - different subsystems
From: Manu Abraham <abraham.manu@gmail.com>
To: Hemmelig Konto <minforumkonto@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 5, 2010 at 7:43 PM, Hemmelig Konto <minforumkonto@gmail.com> wrote:
> Hi there
>
> I'm the owner of two Terratec Cinergy C PCI HD cards.
>
> I'm running on vanilla kernel 2.6.32.0 x64 and is using the s2-liblianin driver.
>
> My problem is that the driver only see 1 of my 2 cards.
> When I investigate the cards, I see that they have a different
> subsystem identifiers : 153b:1178 which works, and 153b.01788 which
> doesn't work. There are no visible difference between the card, as far
> as I can see.
>
> How do I get the driver to "attach" to both the cards so I can get
> both "adapter0" and "adapter1" - today it is only "adapter0" ?
>
> Please help !!!


Does this help http://jusst.de/hg/mantis-v4l-dvb ?

Regards,
Manu
