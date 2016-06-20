Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:36138 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbcFTMAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 08:00:42 -0400
Subject: Re: [PATCH v4 2/9] [media] v4l2-core: Add VFL_TYPE_TOUCH_SENSOR
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466172988-3698-3-git-send-email-nick.dyer@itdev.co.uk>
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
Message-ID: <5767DAE4.3000202@xs4all.nl>
Date: Mon, 20 Jun 2016 14:00:36 +0200
MIME-Version: 1.0
In-Reply-To: <1466172988-3698-3-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/17/2016 04:16 PM, Nick Dyer wrote:
> Some touch controllers send out raw touch data in a similar way to a
> greyscale frame grabber. Add a new device type for these devices.
> 
> Use a new device prefix v4l-touch for these devices, to stop generic
> capture software from treating them as webcams.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/touchscreen/sur40.c    |  4 ++--
>  drivers/media/v4l2-core/v4l2-dev.c   | 13 ++++++++++---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 15 ++++++++++-----
>  include/media/v4l2-dev.h             |  3 ++-
>  include/uapi/linux/videodev2.h       |  1 +

The new interface also needs to be documented in the media DocBook: section 4
describes all the interfaces, so a new one should be added here.

Sorry, just realized this.

I recommend that you grep for swradio:

git grep swradio Documentation/DocBook/media

and add a line there for v4l-touch as well. It also looks like a new interface
define is needed as a media type.

Regards,

	Hans
