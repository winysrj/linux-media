Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33042 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbbIOLCg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 07:02:36 -0400
Subject: Re: [PATCH v4 2/2] [media] media-device: split media initialization
 and registration
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: Luis de Bethencourt <luis@debethencourt.com>,
	linux-sh@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	linux-samsung-soc@vger.kernel.org,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-arm-kernel@lists.infradead.org,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>
References: <1442313147-24566-1-git-send-email-javier@osg.samsung.com>
 <1442313147-24566-3-git-send-email-javier@osg.samsung.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <55F7FAA2.2090605@linux.intel.com>
Date: Tue, 15 Sep 2015 14:01:54 +0300
MIME-Version: 1.0
In-Reply-To: <1442313147-24566-3-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Javier Martinez Canillas wrote:
> The media device node is registered and so made visible to user-space
> before entities are registered and links created which means that the
> media graph obtained by user-space could be only partially enumerated
> if that happens too early before all the graph has been created.
> 
> To avoid this race condition, split the media init and registration
> in separate functions and only register the media device node when
> all the pending subdevices have been registered, either explicitly
> by the driver or asynchronously using v4l2_async_register_subdev().
> 
> The media_device_register() had a check for drivers not filling dev
> and model fields but all drivers in mainline set them and not doing
> it will be a driver bug so change the function return to void and
> add a BUG_ON() for dev being NULL instead.
> 
> Also, add a media_device_cleanup() function that will destroy the
> graph_mutex that is initialized in media_device_init().
> 
> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Thanks!

For drivers/media/media-device.c, drivers/media/platform/omap3isp/isp.c
and include/media/media-device.h:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Laurent, could you ack these if you're fine with them?

They depend on Mauro's patches so they should be applied after them.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
