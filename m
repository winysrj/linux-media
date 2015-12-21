Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59797 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbLUOmc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 09:42:32 -0500
Subject: Re: [PATCH v2] [media] media-device: handle errors at
 media_device_init()
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <e4902f65ceabce2f315e63ba75d4482a4985b351.1450182151.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Luis de Bethencourt <luis@debethencourt.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56780FCD.9060007@osg.samsung.com>
Date: Mon, 21 Dec 2015 11:42:21 -0300
MIME-Version: 1.0
In-Reply-To: <e4902f65ceabce2f315e63ba75d4482a4985b351.1450182151.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 12/15/2015 09:22 AM, Mauro Carvalho Chehab wrote:
> Changeset 43ac4401dca9 ("[media] media-device: split media
> initialization and registration") broke media device register
> into two separate functions, but introduced a BUG_ON() and
> made media_device_init() void. It also introduced several
> warnings.
> 
> Instead of adding BUG_ON(), let's revert to WARN_ON() and fix
> the init code in a way that, if something goes wrong during
> device init, driver probe will fail without causing the Kernel
> to BUG.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---

I agree with your patch, in fact the first version of the media
split patch did exactly this and later media_device_init() was
converted to void and the BUG_ON() introduced to address some
feedback I got during the patches review.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

On an OMAP3 IGEPv2:

Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
