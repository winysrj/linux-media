Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34521 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1K3Vbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 16:31:36 -0500
Received: by eeuu47 with SMTP id u47so661734eeu.19
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 13:31:34 -0800 (PST)
Message-ID: <1322688686.2476.15.camel@tvbox>
Subject: Re: [PATCH FOR 3.2 FIX] af9015: limit I2C access to keep FW happy
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Wed, 30 Nov 2011 21:31:26 +0000
In-Reply-To: <4ED422D5.60701@iki.fi>
References: <4EC014E5.5090303@iki.fi> <4EC01857.5050000@iki.fi>
	 <4ec1955e.e813b40a.37be.3fce@mx.google.com> <4ED422D5.60701@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-11-29 at 02:09 +0200, Antti Palosaari wrote:
> On 11/15/2011 12:25 AM, Malcolm Priestley wrote:
> > I have tried this patch, while it initially got MythTV working, there is
> > too many call backs and some failed to acquire the lock. The device
> > became unstable on both single and dual devices.
> >
> > The callbacks
> >
> > af9015_af9013_read_status,
> > af9015_af9013_init
> > af9015_af9013_sleep
> >
> > had to be removed.
> >
> > I take your point, a call back can be an alternative.
> >
> > The patch didn't stop the firmware fails either.
> >
> > The af9015 usb bridge on the whole is so unstable in its early stages,
> > especially on a cold boot and when the USB controller has another device
> > on it, such as card reader or wifi device.
> >
> > I am, at the moment looking to see if the fails are due to interface 1
> > being claimed by HID.
> 
> I just got af9013 rewrite ready. Feel free to test.
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/misc
> 
> It reduces typical statistics polling load maybe 1/4 from the original.
> 
> I see still small glitch when switching to channel. That seems to come 
> from tuner driver I2C load. There is 3 tuners used for dual devices; 
> MXL5005S, MXL5007T and TDA18271. I have only MXL5005S and MXL5007T dual 
> devices here. MXL5005S is worse than MXL5007T but both makes still 
> rather much I/O.

I have had a quick test of this patch, it seems a lot better.

I will do more testing on my troublesome PC and Mythtv at the weekend.

Regards

Malcolm



