Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:39599 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591AbaFXQZZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 12:25:25 -0400
Message-ID: <53A9A66F.20401@eukrea.com>
Date: Tue, 24 Jun 2014 18:25:19 +0200
From: Denis Carikli <denis@eukrea.com>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Sascha Hauer <kernel@pengutronix.de>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	=?ISO-8859-1?Q?Eric_B=E9nar?= =?ISO-8859-1?Q?d?=
	<eric@eukrea.com>, Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v14 04/10] imx-drm: use defines for clock polarity settings
References: <1402913484-25910-1-git-send-email-denis@eukrea.com> <1402913484-25910-4-git-send-email-denis@eukrea.com> <20140624151323.GU32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140624151323.GU32514@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/24/2014 05:13 PM, Russell King - ARM Linux wrote:
[...]
> If you'd like to send me better commit messages for
> these patches, I'll add them to what I already have:

> 	imx-drm: use defines for clock polarity settings
The comment of the clk_pol field of the ipu_di_signal_cfg struct was 
inverted.
Instead of merely inverting the comment, the values of clk_pol were defined.

> 	imx-drm: add RGB666 support for parallel display.
This permits to drive parallel displays that expect the RGB666 color format.
>
> It may also be worth describing the RGB666 format in the commit message
> for:
>
> 	v4l2: add new V4L2_PIX_FMT_RGB666 pixel format.
The RGB666 color format encodes 6 bits for each color(red, green and 
blue), linearly.
It looks like this in memory:
0                17
RRRRRRGGGGGGBBBBBB

Denis.
