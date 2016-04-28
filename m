Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33969 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbcD1VTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 17:19:35 -0400
Subject: Re: [PATCH 0/2] Fix ir-rx51 by using PWM pdata
To: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
References: <1461714709-10455-1-git-send-email-tony@atomide.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	Pavel Machel <pavel@ucw.cz>,
	Timo Kokkonen <timo.t.kokkonen@iki.fi>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Neil Armstrong <narmstrong@baylibre.com>
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <57227E63.4040907@gmail.com>
Date: Fri, 29 Apr 2016 00:19:31 +0300
MIME-Version: 1.0
In-Reply-To: <1461714709-10455-1-git-send-email-tony@atomide.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 27.04.2016 02:51, Tony Lindgren wrote:
> Hi all,
>
> Here are minimal fixes to get ir-rx51 going again. Then further
> fixes can be done as noted in the second patch.
>
> Regards,
>
> Tony
>
>
> Tony Lindgren (2):
>    ARM: OMAP2+: Add more functions to pwm pdata for ir-rx51
>    [media] ir-rx51: Fix build after multiarch changes broke it
>
>   arch/arm/mach-omap2/board-rx51-peripherals.c   | 35 ++++++++-
>   arch/arm/mach-omap2/pdata-quirks.c             | 33 ++++++++-
>   drivers/media/rc/Kconfig                       |  2 +-
>   drivers/media/rc/ir-rx51.c                     | 99 ++++++++++++++------------
>   include/linux/platform_data/media/ir-rx51.h    |  1 +
>   include/linux/platform_data/pwm_omap_dmtimer.h | 21 ++++++
>   6 files changed, 141 insertions(+), 50 deletions(-)
>

I didn't test legacy boot, as I don't really see any value of doing it 
now the end of the legacy boot is near, the driver does not function 
correctly, however the patchset at least allows for the driver to be 
build and we have something to improve on. And I am going to send a 
patch that fixes the problem with omap_dm_timer_request_specific(). So, 
for both patches, you may add:

Tested-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>


Thanks,
Ivo
