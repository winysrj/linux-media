Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43789 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517AbcAYO7f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 09:59:35 -0500
Subject: Re: [PATCH v2 00/10] [media] tvp5150: add MC and DT support
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
References: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56A63849.8040004@xs4all.nl>
Date: Mon, 25 Jan 2016 15:59:21 +0100
MIME-Version: 1.0
In-Reply-To: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/07/2016 01:46 PM, Javier Martinez Canillas wrote:

FYI: this patch series no longer applies after the merge of 4.5-rc1.

So besides fixing Mauro's comment for 3/10 you need to respin this series
anyway.

Regards,

	Hans

> Hello,
> 
> One of my testing platforms for the MC next gen [0] work has been an OMAP3
> board (IGEPv2) with a tvp5151 video decoder attached to the OMAP3ISP block.
> 
> I've been using some patches from Laurent Pinchart that adds MC support to
> the tvp5150 driver. The patches were never posted to the list and it seems
> he doesn't have time to continue working on this so I have taken them from
> his personal tree [1] and submitting now for review.
> 
> The series also contains patches that adds DT support to the driver so it
> can be used in DT based platforms.
> 
> This is the second version of the series that fixes issues addressed by
> Rob Herring and Laurent Pinchart. The first patch-set version was [2].
> 
> To test, the following media pipeline was used:
> 
> $ media-ctl -r -l '"tvp5150 1-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> $ media-ctl -v --set-format '"OMAP3 ISP CCDC":0 [UYVY2X8 720x240 field:alternate]'
> $ media-ctl -v --set-format '"OMAP3 ISP CCDC":1 [UYVY2X8 720x240 field:interlaced-tb]'
> 
> And frames captured with the yavta tool:
> 
> $ yavta -f UYVY -s 720x480 -n 1 --field interlaced-tb --capture=1 -F /dev/video2
> $ raw2rgbpnm -f UYVY -s 720x480 frame-000000.bin frame-000000.pnm
> 
> The patches are on top of [0] not because is a depedency but just to avoid
> merge conflicts and I don't expect them to be picked before that anyways.
> 
> Best regards,
> Javier
> 
> [0]: http://lists.infradead.org/pipermail/linux-arm-kernel/2015-August/367109.html
> [1]: http://git.linuxtv.org/pinchartl/media.git/log/?h=omap3isp/tvp5151
> [2]: https://lkml.org/lkml/2016/1/4/216
> 
> Changes in v2:
> - Fix indentation of the DTS example. Suggested by Rob Herring.
> - Rename powerdown-gpios to pdn-gpios to match the pin name in
>   the datasheet. Suggested by Laurent Pinchart.
> - Add optional properties for the video endpoint and list the supported
>   values. Suggested by Laurent Pinchart.
> - Add Reviewed-by tag from Laurent Pinchart to patch 8/10.
> - Include missing linux/gpio/consumer.h header. Reported by kbuild test robot.
> - Keep the headers sorted alphabetically. Suggested by Laurent Pinchart.
> - Rename powerdown to pdn to match datasheet pin. Suggested by Laurent Pinchart.
> - Embed mbus_type into struct tvp5150. Suggested by Laurent Pinchart.
> - Remove platform data support. Suggested by Laurent Pinchart.
> - Check if the hsync, vsync and field even active properties are correct.
>   Suggested by Laurent Pinchart.
> 
> Eduard Gavin (1):
>   [media] tvp5150: Add OF match table
> 
> Javier Martinez Canillas (3):
>   [media] tvp5150: Add device tree binding document
>   [media] tvp5150: Initialize the chip on probe
>   [media] tvp5150: Configure data interface via DT
> 
> Laurent Pinchart (6):
>   [media] tvp5150: Restructure version detection
>   [media] tvp5150: Add tvp5151 support
>   [media] tvp5150: Add pad-level subdev operations
>   [media] tvp5150: Add pixel rate control support
>   [media] tvp5150: Add s_stream subdev operation support
>   [media] tvp5150: Add g_mbus_config subdev operation support
> 
>  .../devicetree/bindings/media/i2c/tvp5150.txt      |  45 ++++
>  drivers/media/i2c/tvp5150.c                        | 269 +++++++++++++++++----
>  2 files changed, 268 insertions(+), 46 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> 

