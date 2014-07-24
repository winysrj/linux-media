Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:55643 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbaGXP5b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 11:57:31 -0400
Received: by mail-oa0-f44.google.com with SMTP id eb12so3969523oac.31
        for <linux-media@vger.kernel.org>; Thu, 24 Jul 2014 08:57:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D12786.5050906@InUnum.com>
References: <53D12786.5050906@InUnum.com>
Date: Thu, 24 Jul 2014 17:57:30 +0200
Message-ID: <CA+2YH7v8bQG4K2Gz8aB9_BOHwuK_1nGDxU102S7EBnsMGEuwKA@mail.gmail.com>
Subject: Re: omap3isp with DM3730 not working?!
From: Enrico <ebutera@users.sourceforge.net>
To: Michael Dietschi <michael.dietschi@inunum.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 24, 2014 at 5:34 PM, Michael Dietschi
<michael.dietschi@inunum.com> wrote:
> Hello,
>
> I have built a Poky image for Gumstix Overo and added support for a TVP5151
> module like described here http://www.sleepyrobot.com/?p=253.
> It does work well with an Overo board which hosts an OMAP3530 SoC. But when
> I try with an Overo hosting a DM3730 it does not work: yavta just seems to
> wait forever :(
>
> I did track it down to the point that IRQ0STATUS_CCDC_VD0_IRQ seems never be
> set but always IRQ0STATUS_CCDC_VD1_IRQ
>
> Can someone please give me a hint?

It's strange that you get the vd1_irq because it should not be set by
the driver and never trigger...

Anyway maybe a different pinmux where the camera pins are not setup correctly?

Enrico
