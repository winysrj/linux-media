Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60776 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbcF0L0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 07:26:35 -0400
Subject: Re: [PATCH v5 0/9] Output raw touch data via V4L2
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <30c68dab-b970-03d5-797b-3376d9d0dc10@xs4all.nl>
Date: Mon, 27 Jun 2016 13:26:28 +0200
MIME-Version: 1.0
In-Reply-To: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/23/2016 12:08 AM, Nick Dyer wrote:
> This is a series of patches to add output of raw touch diagnostic data via V4L2
> to the Atmel maXTouch and Synaptics RMI4 drivers.
> 
> It's a rewrite of the previous implementation which output via debugfs: it now
> uses a V4L2 device in a similar way to the sur40 driver.
> 
> We have a utility which can read the data and display it in a useful format:
>     https://github.com/ndyer/heatmap/commits/heatmap-v4l
> 
> These patches are also available from
>     https://github.com/ndyer/linux/commits/v4l-touch-2016-06-22
> 
> Changes in v5 (Hans Verkuil review):
> - Update v4l2-core:
>   - Add VFL_TYPE_TOUCH, V4L2_BUF_TYPE_TOUCH_CAPTURE and V4L2_CAP_TOUCH

The use of V4L2_CAP_TOUCH and V4L2_BUF_TYPE_TOUCH_CAPTURE is very inconsistent.
What is the rationale of adding V4L2_BUF_TYPE_TOUCH_CAPTURE? I can't remember
asking for it.

And wouldn't the use of V4L2_BUF_TYPE_TOUCH_CAPTURE break userspace for sur40?

I'm ambiguous towards having a V4L2_BUF_TYPE_TOUCH_CAPTURE, to be honest.

I would also recommend renaming V4L2_CAP_TOUCH to V4L2_CAP_TOUCH_CAPTURE.

I can imagine an embedded usb gadget device that outputs touch data to a PC.

Regards,

	Hans

>   - Change V4L2_INPUT_TYPE_TOUCH_SENSOR to V4L2_INPUT_TYPE_TOUCH
>   - Improve DocBook documentation
>   - Add FMT definitions for touch data
>   - Note this will need the latest version of the heatmap util
> - Synaptics RMI4 driver:
>   - Remove some less important non full frame report types
>   - Switch report type names to const char * array
>   - Move a static array to inside context struct
> - Split sur40 changes to a separate commit
> 
> Changes in v4:
> - Address nits from the input side in atmel_mxt_ts patches (Dmitry Torokhov)
> - Add Synaptics RMI4 F54 support patch
> 
> Changes in v3:
> - Address V4L2 review comments from Hans Verkuil
> - Run v4l-compliance and fix all issues - needs minor patch here:
>   https://github.com/ndyer/v4l-utils/commit/cf50469773f
> 
> Changes in v2:
> - Split pixfmt changes into separate commit and add DocBook
> - Introduce VFL_TYPE_TOUCH_SENSOR and /dev/v4l-touch
> - Remove "single node" support for now, it may be better to treat it as
>   metadata later
> - Explicitly set VFL_DIR_RX
> - Fix Kconfig
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
