Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:46794 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbcGTHtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 03:49:07 -0400
Subject: Re: [PATCH v8 0/10] Output raw touch data via V4L2
To: Nick Dyer <nick@shmanahar.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
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
Message-ID: <1fca9689-3bfa-11bf-28c6-f81050bfeb88@xs4all.nl>
Date: Wed, 20 Jul 2016 09:48:58 +0200
MIME-Version: 1.0
In-Reply-To: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nick,

This series looks good. I plan on taking it for 4.9. I have to wait until
4.8-rc1 is out and merged in our media_tree repo before I can make the pull
request, probably in about 3 weeks from now.

One request: can you post the 'v4l2-compliance -a -f' output, using the latest
v4l2-compliance code with your patch on top.

I'd like to make sure all input and format combinations are working as they should.

Regards,

	Hans

On 07/18/2016 11:10 PM, Nick Dyer wrote:
> This is a series of patches to add output of raw touch diagnostic data via V4L2
> to the Atmel maXTouch and Synaptics RMI4 drivers.
> 
> It's a rewrite of the previous implementation which output via debugfs: it now
> uses a V4L2 device in a similar way to the sur40 driver.
> 
> We have a utility which can read the data and display it in a useful format:
>     https://github.com/ndyer/heatmap/commits/heatmap-v4l
> 
> Changes in v8:
> - Split out docs changes, rework in RST/Sphinx, and rebase against docs-next
> - Update for changes to vb2_queue alloc_ctxs
> - Rebase against git://linuxtv.org/media_tree.git and re-test
> 
> Changes in v7:
> - Tested by Andrew Duggan and Chris Healy.
> - Update bus_info to add "rmi4:" bus.
> - Fix code style issues in sur40 changes.
> 
> Changes in v6:
> - Remove BUF_TYPE_TOUCH_CAPTURE, as discussed with Hans V touch devices will
>   use BUF_TYPE_VIDEO_CAPTURE.
> - Touch devices should now register CAP_VIDEO_CAPTURE: CAP_TOUCH just says that
>   this is a touch device, not a video device, but otherwise it acts the same.
> - Add some code to v4l_s_fmt() to set sensible default values for fields not
>   used by touch.
> - Improve naming/doc of RMI4 F54 report types.
> - Various minor DocBook fixes, and split to separate patch.
> - Update my email address.
> - Rework sur40 changes so that PIX_FMT_GREY is supported for backward
>   compatibility. Florian is it possible for you to test?
> 
> Changes in v5 (Hans Verkuil review):
> - Update v4l2-core:
>   - Add VFL_TYPE_TOUCH, V4L2_BUF_TYPE_TOUCH_CAPTURE and V4L2_CAP_TOUCH
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
