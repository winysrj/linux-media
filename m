Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:59098 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548AbcGTNUL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 09:20:11 -0400
Subject: Re: [PATCH v7] [media] pci: Add tw5864 driver
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Kozlov Sergey <serjk@netup.ru>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <20160720130712.31469-1-andrey.utkin@corp.bluecherry.net>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com,
	Andrey Utkin <andrey_utkin@fastmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d52da47a-7e1f-1678-4129-3401782710ee@xs4all.nl>
Date: Wed, 20 Jul 2016 15:20:04 +0200
MIME-Version: 1.0
In-Reply-To: <20160720130712.31469-1-andrey.utkin@corp.bluecherry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2016 03:07 PM, Andrey Utkin wrote:
> Changes since v6:
>  - Change tw5864_input_std_get() behaviour as suggested by Hans, and also simplify
>  - tw5864_from_v4l2_std(): drop WARN_ON_ONCE on returning STD_INVALID
>  - tw5864_prepare_frame_headers(): not only WARN_ON_ONCE, but also return if buffer space is too small
>  - tw5864_frameinterval_get(): return -EINVAL instead of "1" on failure
> 
> Granular git log: https://github.com/bluecherrydvr/linux/commits/release/tw5864/pre_1.26/drivers/media/pci/tw5864
> 
> ---8<---
> Support for boards based on Techwell TW5864 chip which provides
> multichannel video & audio grabbing and encoding (H.264, MJPEG,
> ADPCM G.726).
> 
> This submission implements only H.264 encoding of all channels at D1
> resolution.
> 
> Thanks to Mark Thompson <sw@jkqxz.net> for help, and for contribution of
> H.264 startcode emulation prevention code.
> 
> Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> Tested-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>

Looks good. Once we moved to v4.8-rc1 in 3 weeks time or so I'll make a pull request for this.

Regards,

	Hans
