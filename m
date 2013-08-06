Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:45776 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab3HFRVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 13:21:47 -0400
Received: by mail-ob0-f178.google.com with SMTP id ef5so1469104obb.37
        for <linux-media@vger.kernel.org>; Tue, 06 Aug 2013 10:21:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130806083123.GA11080@pequod.mess.org>
References: <CAFoaQoAjc-v6UiYxu8ZzaOQi4g8GurYdCB6JM8-GKQbYugJwTw@mail.gmail.com>
	<20130805112937.GA5216@pequod.mess.org>
	<CAFoaQoCpNxcqQjCt4KVPvSCOXKoOFeUs-qV7d04GSw0PyPcFEQ@mail.gmail.com>
	<20130805211505.GA8094@pequod.mess.org>
	<CAFoaQoBFVJ+pKHtJncyLxH5tjLDeR5v5fQ4VqGx0Yoko_tiN2w@mail.gmail.com>
	<20130806083123.GA11080@pequod.mess.org>
Date: Tue, 6 Aug 2013 18:21:47 +0100
Message-ID: <CAFoaQoC3p=hnocAH9GBHPMA7zb+JTFk8TKG5SQbxKRBRtijwog@mail.gmail.com>
Subject: Re: mceusb Fintek ir transmitter only works when X is not running
From: Rajil Saraswat <rajil.s@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> It's not about whether there is enough bandwidth, it's about whether
> issuing more usb urbs would overflow the bandwidth allocated to other
> devices (whether in use or not). Make sure you have
> CONFIG_USB_EHCI_TT_NEWSCHED defined in your kernel.
>

This did the trick!!. After enabling this along with
CONFIG_USB_EHCI_ROOT_HUB, the irsend works. Both the tx ports are
working independently.

Thanks a lot.
