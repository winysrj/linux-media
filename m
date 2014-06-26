Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44418 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750940AbaFZU4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jun 2014 16:56:48 -0400
Date: Thu, 26 Jun 2014 21:56:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Denis Carikli <denis@eukrea.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, devel@driverdev.osuosl.org,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v14 04/10] imx-drm: use defines for clock polarity
	settings
Message-ID: <20140626205631.GB32514@n2100.arm.linux.org.uk>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com> <1402913484-25910-4-git-send-email-denis@eukrea.com> <20140625044845.GK5918@pengutronix.de> <53AA9A0F.605@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA9A0F.605@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 25, 2014 at 11:44:47AM +0200, Denis Carikli wrote:
> On 06/25/2014 06:48 AM, Sascha Hauer wrote:
>>> +#define ENABLE_POL_LOW		0
>>> +#define ENABLE_POL_HIGH		1
>>
>> Adding defines without a proper namespace (IPU_) outside a driver
>> private header file is not nice. Anyway, instead of adding the
>> defines ...
> Fixed in "imx-drm: use defines for clock polarity settings" and in  
> "imx-drm: Use drm_display_mode timings flags.".

Denis, can you send just this one updated patch, so I can update the
one I have here with this change.  Once you've done that, I'll send
the first four off to Greg.

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
