Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:41944 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066AbaFQNqN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jun 2014 09:46:13 -0400
Message-ID: <53A046A2.1010303@eukrea.com>
Date: Tue, 17 Jun 2014 15:46:10 +0200
From: Denis Carikli <denis@eukrea.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: devel@driverdev.osuosl.org, Russell King <linux@arm.linux.org.uk>,
	Sascha Hauer <kernel@pengutronix.de>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v14 09/10] ARM: dts: mbimx51sd: Add display support.
References: <1402913484-25910-1-git-send-email-denis@eukrea.com> <1402913484-25910-9-git-send-email-denis@eukrea.com> <539EE30C.4060502@eukrea.com>
In-Reply-To: <539EE30C.4060502@eukrea.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2014 02:29 PM, Denis Carikli wrote:
[...]
> Which result at the lcd regulator being physically powered on at boot.
> I didn't see that because powering it on at boot is what I want.
I fixed that in imx-drm's parallel-display with another patch I just 
sent separately.

Denis.
