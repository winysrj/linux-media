Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:51450 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaFYJot (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 05:44:49 -0400
Message-ID: <53AA9A0F.605@eukrea.com>
Date: Wed, 25 Jun 2014 11:44:47 +0200
From: Denis Carikli <denis@eukrea.com>
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: devel@driverdev.osuosl.org, Russell King <linux@arm.linux.org.uk>,
	=?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v14 04/10] imx-drm: use defines for clock polarity settings
References: <1402913484-25910-1-git-send-email-denis@eukrea.com> <1402913484-25910-4-git-send-email-denis@eukrea.com> <20140625044845.GK5918@pengutronix.de>
In-Reply-To: <20140625044845.GK5918@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/25/2014 06:48 AM, Sascha Hauer wrote:
>> +#define ENABLE_POL_LOW		0
>> +#define ENABLE_POL_HIGH		1
>
> Adding defines without a proper namespace (IPU_) outside a driver
> private header file is not nice. Anyway, instead of adding the
> defines ...
Fixed in "imx-drm: use defines for clock polarity settings" and in 
"imx-drm: Use drm_display_mode timings flags.".

Denis.
