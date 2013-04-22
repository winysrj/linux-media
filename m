Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab3DVMq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 08:46:58 -0400
Message-ID: <51753138.1080106@redhat.com>
Date: Mon, 22 Apr 2013 09:46:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [GIT PULL FOR v3.10] Camera sensors patches
References: <3775187.HOcoQVPfEE@avalon> <20130417135503.GL13687@opensource.wolfsonmicro.com> <20130417113639.1c98f574@redhat.com> <1905734.rpqfOCmvCu@avalon> <20130422100320.GC30351@opensource.wolfsonmicro.com>
In-Reply-To: <20130422100320.GC30351@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-04-2013 07:03, Mark Brown escreveu:
> On Mon, Apr 22, 2013 at 01:14:07AM +0200, Laurent Pinchart wrote:
>
>> I think that Mark's point was that the regulators should be provided by
>> platform code (in the generic sense, it could be DT on ARM, board code, or a
>> USB bridge driver for a webcam that uses the mt9p031 sensor) and used by the
>> sensor driver. That's exactly what my mt9p031 patch does.
>
> Yes, you understood me perfectly - to a good approximation the matching
> up should be done by whatever the chip is soldered down to.
>

That doesn't make any sense to me. I2C devices can be used anywere,
as they can be soldered either internally on an USB webcam without
any regulators or any other platform code on it or could be soldered
to some platform-specific bus.

Also, what best describes "soldered" here is the binding between
an I2C driver and the I2C adapter. The I2C adapter is a platform
driver on embedded devices, where, on an usual USB camera, it
is just a USB->I2C bridge.

Also, requiring that simple USB cameras to have regulators will
prevent its usual usage, as non-platform distros don't set config
REGULATOR (and they shouldn't, as that would just increase the
Kernel's footprint for a code that will never ever be needed there).

Regards,
Mauro
