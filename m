Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:41846 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab3BAVPl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 16:15:41 -0500
Received: by mail-qa0-f43.google.com with SMTP id dx4so512367qab.9
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 13:15:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510C2DA2.7020000@googlemail.com>
References: <510A9A1E.9090801@googlemail.com>
	<CAGoCfiwQNBv1r5KgCzYFf7X1hP--fyQpqvRHCDtKFcSxwbJWpA@mail.gmail.com>
	<510ADB2F.4080901@googlemail.com>
	<510AF800.2090607@googlemail.com>
	<510BACD5.2070406@googlemail.com>
	<510BCE2F.1070100@googlemail.com>
	<CAGoCfix8XDzcgtCiL39Qna_QBx_=ZEKyMknzbsS3iTXS04_a8A@mail.gmail.com>
	<510C2DA2.7020000@googlemail.com>
Date: Fri, 1 Feb 2013 16:07:58 -0500
Message-ID: <CAGoCfiy3hJtkxZG==wg4o1AG2dV3ESiwApNj3GxENDsLSQ=jSA@mail.gmail.com>
Subject: Re: WinTV-HVR-1400: scandvb (and kaffeine) fails to find any channels
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 1, 2013 at 4:03 PM, Chris Clayton <chris2553@googlemail.com> wrote:
> Yes, I noticed that but even with the tuning timeout set at medium or
> longest, I doesn't find any channels. However, I've been following the debug
> messages through the code and ended up at
> drivers/media/pci/cx23885/cx23885-i2c.c.
>
> I've found that by amending I2C_WAIT_DELAY from 32 to 64, I get improved
> results from scanning. With that delay doubled, scandvb now finds 49
> channels over 3 frequencies. That's with all debugging turned off, so no
> extra delays provided by the production of debug messages.
>
> I'll play around more tomorrow and update then.

It could be that the cx23885 driver doesn't properly implement I2C
clock stretching, which is something you don't encounter on most
tuners but is an issue when communicating with the Xceive parts.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
