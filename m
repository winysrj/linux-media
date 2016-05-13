Return-path: <linux-media-owner@vger.kernel.org>
Received: from zencphosting06.zen.co.uk ([82.71.204.9]:41629 "EHLO
	zencphosting06.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbcEMPSA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 11:18:00 -0400
Subject: Re: [PATCH v2 0/8] Input: atmel_mxt_ts - output raw touch diagnostic
 data via V4L
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Florian Echtler <floe@butterbrot.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1462381638-7818-1-git-send-email-nick.dyer@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>
From: Nick Dyer <nick.dyer@itdev.co.uk>
Message-ID: <5735F01A.3010101@itdev.co.uk>
Date: Fri, 13 May 2016 16:17:46 +0100
MIME-Version: 1.0
In-Reply-To: <1462381638-7818-1-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Hans, Dmitry, Henrik-

You kindly passed comment on this feature in its earlier form - would it be
possible to have some feedback on the updates?

It would be good to know whether we are on the right track with the V4L2
approach, because there is additional work that we want to base on it.

best regards

Nick

On 04/05/2016 18:07, Nick Dyer wrote:
> This is a series of patches to add diagnostic data support to the Atmel
> maXTouch driver. It's a rewrite of the previous implementation which output via
> debugfs: it now uses a V4L2 device in a similar way to the sur40 driver.
> 
> There are significant performance advantages to putting this code into the
> driver.  The algorithm for retrieving the data has been fairly consistent
> across a range of chips, with the exception of the mXT1386 series (see patch).
> 
> We have a utility which can read the data and display it in a useful format:
>     https://github.com/ndyer/heatmap/commits/heatmap-v4l
> 
> These patches are also available from
>     https://github.com/ndyer/linux/commits/diagnostic-v4l
> 
> Changes in v2:
> - Split pixfmt changes into separate commit and add DocBook
> - Introduce VFL_TYPE_TOUCH_SENSOR and /dev/v4l-touch
> - Remove "single node" support for now, it may be better to treat it as metadata later
> - Explicitly set VFL_DIR_RX
> - Fix Kconfig
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
