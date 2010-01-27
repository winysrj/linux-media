Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41148 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab0A0VVK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 16:21:10 -0500
Received: by bwz19 with SMTP id 19so5208815bwz.28
        for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 13:21:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B60A983.7040405@gmail.com>
References: <4B60A983.7040405@gmail.com>
Date: Wed, 27 Jan 2010 16:21:08 -0500
Message-ID: <829197381001271321m4f9f1be9x7752790100922d2d@mail.gmail.com>
Subject: Re: dmesg output with Pinnacle PCTV USB Stick
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Sebastian Spiess <sebastian.spiess@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 27, 2010 at 4:00 PM, Sebastian Spiess
<sebastian.spiess@gmail.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi there,
> below is my dmesh output for my Pinnacle PCTV Hybrid Pro
>
> hope it helps
>
> [ 8899.390876] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
> interface 0, class 0)

Are you absolutely sure this is a PCTV Hybrid Pro?  What is the exact
model number?  Does it have the A/V cable for composite/svideo input?

Based on the USB ID, I would have assumed this was a model "70e",
which is a digital only device.  It's on my TODO list, but it's a
really low priority given how old it is.  I actually did spend some
time working on it, but ran into problems and without the hardware
concluded it wasn't worth the time.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
