Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:54507 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbaFYI1R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 04:27:17 -0400
Message-ID: <53AA87DE.5030109@eukrea.com>
Date: Wed, 25 Jun 2014 10:27:10 +0200
From: Denis Carikli <denis@eukrea.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
	=?ISO-8859-1?Q?Eric_B=E9?= =?ISO-8859-1?Q?nard?=
	<eric@eukrea.com>
CC: devel@driverdev.osuosl.org, Russell King <linux@arm.linux.org.uk>,
	Sascha Hauer <kernel@pengutronix.de>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v14 08/10] drm/panel: Add Eukrea mbimxsd51 displays.
References: <1402913484-25910-1-git-send-email-denis@eukrea.com> <1402913484-25910-8-git-send-email-denis@eukrea.com> <20140624214926.GA30039@mithrandir> <20140624235639.487429ad@e6520eb> <20140624220404.GA30155@mithrandir>
In-Reply-To: <20140624220404.GA30155@mithrandir>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/25/2014 12:04 AM, Thierry Reding wrote:
>> because on this very simple display board, we only have DVI LVDS signals
>> without the I2C to detect the display.
>
> That's unfortunate. In that case perhaps a better approach would be to
> add a video timings node to the device that provides the DVI output?
I've just done that.

Should I resend now? The goal is to avoid as much as possible extra 
versions.

Also, as I said before in a response to "[PATCH v14 09/10] ARM: dts: 
mbimx51sd: Add display support.", the LCD regulator was inverted, it 
worked while inverted because of a bug which is now fixed by:
"imx-drm: parallel-display: Fix DPMS default state."

Right now, I don't have any other changes for this serie beside a simple 
rebase of "dts: imx5*, imx6*: correct display-timings rebased".

Denis.
