Return-path: <linux-media-owner@vger.kernel.org>
Received: from zencphosting06.zen.co.uk ([82.71.204.9]:59406 "EHLO
	zencphosting06.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbcD2MOT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 08:14:19 -0400
Subject: Re: [PATCH 0/8] Input: atmel_mxt_ts - output raw touch diagnostic
 data via V4L
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
 <5719E03D.2010201@xs4all.nl> <20160422114517.0e7430bd@recife.lan>
 <571A3E3E.60601@itdev.co.uk> <571A40C0.90208@xs4all.nl>
 <20160422124425.39ac140f@recife.lan>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
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
	Florian Echtler <floe@butterbrot.org>
From: Nick Dyer <nick.dyer@itdev.co.uk>
Message-ID: <57235014.8060304@itdev.co.uk>
Date: Fri, 29 Apr 2016 13:14:12 +0100
MIME-Version: 1.0
In-Reply-To: <20160422124425.39ac140f@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/04/2016 16:44, Mauro Carvalho Chehab wrote:
>> On the other hand, it would be a good place to tell the user that it
>> is from a touch sensor.
>>
>> Using the upcoming metadata feature wouldn't work since there is no width
>> and height in the metadata format.
>>
>> I wonder what others think about adding a new type value.
> 
> IMO, two things should be done here:
> 
> 1) Add some caps flag to help userspace to identify what's there
>    on those devices;

In the patches I have written so far, I have used inputs to select between
different types of data, so I believe there's no real need for this yet.
Did you have anything else in mind?

> 2) Make sure that udev/systemd won't be naming the devnodes as
>    "/dev/video";
> 
> 
> The latter one could be solved with either the new dev meta or
> with another VFL_TYPE for input systems (like VFL_TYPE_TOUCH_SENSOR)
> and use this code snippet:
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index d8e5994cccf1..4d3e574eba49 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -887,6 +887,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>                 /* Use device name 'swradio' because 'sdr' was already taken. */
>                 name_base = "swradio";
>                 break;
> +       case VFL_TYPE_TOUCH_SENSOR:
> +               name_base = "v4l-touch";
> +               break;
>         default:
>                 printk(KERN_ERR "%s called with unknown type: %d\n",
>                        __func__, type);
> 
> 
> Such change would cause __video_register_device() to pass a different
> name_base to:
> 	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
> 
> This way, udev/systemd will use a different name (by default, 
> /dev/v4l-touch0), and existing apps won't identify this as a
> webcam.

Thanks - this sounds like a good approach to me. I will update.
