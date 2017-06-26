Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:53800 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751407AbdFZLVR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 07:21:17 -0400
Subject: Re: [PATCH v2] media: ov6650: convert to standalone v4l2 subdevice
To: Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20170616194533.20532-1-jmkrzyszt@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3a024b91-8c0b-7590-8af5-3c798cdd2852@xs4all.nl>
Date: Mon, 26 Jun 2017 13:21:00 +0200
MIME-Version: 1.0
In-Reply-To: <20170616194533.20532-1-jmkrzyszt@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/06/17 21:45, Janusz Krzysztofik wrote:
> Remove the soc_camera dependencies and move the diver to i2c
> 
> Lost features, fortunately not used or not critical on test platform:
> - soc_camera power on/off callback - replaced with clock enable/disable
>   only, no support for platform provided regulators nor power callback,
> - soc_camera sense request - replaced with arbitrarily selected default
>   master clock rate and pixel clock limit, no support for platform
>   requested values,
> - soc_camera board flags - no support for platform requested mbus config
>   tweaks.
> 
> Created against linux-4.12-rc2.
> Tested on Amstrad Delta with now out of tree but still locally
> maintained omap1_camera host driver.
> 
> Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
