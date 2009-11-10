Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:57932 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZKJALe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 19:11:34 -0500
Received: by fxm21 with SMTP id 21so609688fxm.21
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 16:11:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <13029.64.213.30.2.1257810088.squirrel@webmail.exetel.com.au>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
	 <20091109144647.2f876934@pedra.chehab.org>
	 <13029.64.213.30.2.1257810088.squirrel@webmail.exetel.com.au>
Date: Mon, 9 Nov 2009 19:11:38 -0500
Message-ID: <829197380911091611m5d534cffvde5334c81fc2515c@mail.gmail.com>
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Robert Lowery <rglowery@exemail.com.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 6:41 PM, Robert Lowery <rglowery@exemail.com.au> wrote:
> Although the xc3028-v27.fw generated from
> HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip using the above process works fine
> for me, the firmware is a couple of years old now and I can't help
> wondering if there might be a newer version in the latest Windows drivers
> out there containing performance or stability fixes it in.
>
> Do you think it would be worthwhile extracting a newer version of firmware?

That is the latest version of the firmware for that chip.  Xceive has
not updated it since then, given that they are focusing on newer
products like the xc5000 and xc3028L.

Your problem has nothing to do with the firmware.  The issue is the
driver support for your particular device was only added recently
(after Ubuntu did their kernel freeze for Karmic).  The work
associated with adding support for devices is nontrivial, and I
typically only do it when people report that their device needs
support.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
