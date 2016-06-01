Return-path: <linux-media-owner@vger.kernel.org>
Received: from zencphosting06.zen.co.uk ([82.71.204.9]:39412 "EHLO
	zencphosting06.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbcFAQXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2016 12:23:14 -0400
Subject: Re: [PATCH v2 4/8] Input: atmel_mxt_ts - output diagnostic debug via
 v4l2 device
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1462381638-7818-1-git-send-email-nick.dyer@itdev.co.uk>
 <1462381638-7818-5-git-send-email-nick.dyer@itdev.co.uk>
 <57484386.2050809@xs4all.nl>
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
From: Nick Dyer <nick.dyer@itdev.co.uk>
Message-ID: <64eabe26-1140-6d6e-e379-e54525c3e53e@itdev.co.uk>
Date: Wed, 1 Jun 2016 17:22:56 +0100
MIME-Version: 1.0
In-Reply-To: <57484386.2050809@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/05/2016 13:54, Hans Verkuil wrote:
> Hi Nick,

Thanks for the useful review. Most of it is straightforward and I've
updated it in a new version of these patches which I will post now.

I think the open question is whether you're happy with the
V4L2_PIX_FMT_YS16 or whether I need to rename it. For what it's worth,
Synaptics RMI4 also emits 16 bit signed, see

https://github.com/wanam/Adam-Kernel-GS4/blob/master/drivers/input/touchscreen/rmi_f54.c#L1831

> On 05/04/2016 07:07 PM, Nick Dyer wrote:
> BTW, did you run v4l2-compliance? I think it should work if you just do:
> 
> v4l2-compliance -d /dev/v4l-touch0

Yes, and I've now fixed all issues that I could find with it. I had to do
some minor updates to support the touch sensor stuff, see:
    https://github.com/ndyer/v4l-utils/commits/touch-sensor
