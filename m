Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:4835 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZAXWw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 17:52:29 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1891980fkf.5
        for <linux-media@vger.kernel.org>; Sat, 24 Jan 2009 14:52:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497B2AD1.6090503@iki.fi>
References: <6fd6e6490901240056u59e275b2nc82e755123ffc87b@mail.gmail.com>
	 <497B2AD1.6090503@iki.fi>
Date: Sat, 24 Jan 2009 23:52:26 +0100
Message-ID: <6fd6e6490901241452l5c2473d7l4cfc8054e46bb79b@mail.gmail.com>
Subject: Re: Volar X remote control problem
From: Felipe Morales <felipe.morales.moreno@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari wrote:
>
> Looks like it is buggy HID.
> http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030292.html
>
> Antti
> --
> http://palosaari.fi/
>

Thanks a lot! It worked perfectly! Sorry not to have looked thoroughly
the mailing list...

By the way, for the Volar X the code to put in the /etc/modprobe.d/usbhid is:

options usbhid quirks=0x07ca:0xa815:0x04

to match the vendor and product id
