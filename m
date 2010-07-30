Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49803 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab0G3CjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 22:39:09 -0400
MIME-Version: 1.0
In-Reply-To: <1280456235-2024-14-git-send-email-maximlevitsky@gmail.com>
References: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
	<1280456235-2024-14-git-send-email-maximlevitsky@gmail.com>
Date: Thu, 29 Jul 2010 22:39:09 -0400
Message-ID: <AANLkTim42mHVhOgmVGxh2XsbbbVC7ZOgtfd7DDSrxZDB@mail.gmail.com>
Subject: Re: [PATCH 13/13] IR: Port ene driver to new IR subsystem and enable
	it.
From: Jon Smirl <jonsmirl@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 29, 2010 at 10:17 PM, Maxim Levitsky
<maximlevitsky@gmail.com> wrote:
> note that error_adjustment module option is added.
> This allows to reduce input samples by a percent.
> This makes input on my system more correct.
>
> Default is 4% as it works best here.
>
> Note that only normal input is adjusted. I don't know
> what adjustments to apply to fan tachometer input.
> Maybe it is accurate already.

Do you have the manual for the ENE chip in English? or do you read Chinese?

Maybe you can figure out why the readings are off by 4%. I suspect
that someone has set a clock divider wrong when programming the chip.
For example setting the divider for a 25Mhz clock when the clock is
actually 26Mhz would cause the error you are seeing. Or they just made
a mistake in computing the divisor. It is probably a bug in the BIOS
of your laptop.  If that's the case you could add a quirk in the
system boot code to fix the register setting.

-- 
Jon Smirl
jonsmirl@gmail.com
