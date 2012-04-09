Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab2DIK3S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Apr 2012 06:29:18 -0400
Message-ID: <4F82BA81.1040801@redhat.com>
Date: Mon, 09 Apr 2012 12:31:29 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jaime Velasco <jsagarribay@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Gregor Jasny <gjasny@googlemail.com>
Subject: Re: [PATCH] stk-webcam: Don't flip the image by default
References: <1333900903-2585-1-git-send-email-hdegoede@redhat.com> <CAO2_v5CZhs0QQcGMzsnA+wxsyLJ_OXhs++9L+HtscSeDc+_uTA@mail.gmail.com>
In-Reply-To: <CAO2_v5CZhs0QQcGMzsnA+wxsyLJ_OXhs++9L+HtscSeDc+_uTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/09/2012 09:27 AM, Jaime Velasco wrote:
>
> 2012/4/8 Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>>
>
>     Prior to this patch the stk-webcam driver was enabling the vflip and mirror
>     bits in the sensor by default. Which only is the right thing to do if the
>     sensor is actually mounted upside down, which it usually is not.
>
>     Actually we've received upside down reports for both usb-ids which this
>     driver supports, one for an "ASUSTeK Computer Inc." "A3H" laptop with
>     a build in 174f:a311 webcam, and one for an "To Be Filled By O.E.M."
>     "Z96FM" laptop with a build in 05e1:0501 webcam.
>
>     Signed-off-by: Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>>
>
>
> Hi, I don't know hoy many users of stk-webcam could be, but this will surely cause a small regression for them. I agree it seems neater your way, but I don't think it makes sense to half-break the driver for a set of users in order to fix it for another.

I understand where you're coming from, but the vflip/hflip options of the driver
in turn toggle bits in the sensor, which default to no flipping. IOW thse bits
should only be set if a sensor is mounted upside down (or a user explicitly
indicates he wants a flipped image). Likely some of these cameras are found
in Asus laptops, and Asus is well known for mounting some of their laptop
webcam modules upside down, I guess this is where the flip by default behavior
comes from, but that does not make it *right*.

Currently we are getting bug reports from users who have a laptop where the
sensor is mounted the right way up, and they are getting an upside down image...

So either way we are doing the wrong thing for a group of users, and we
are going to need a quirk table in the driver, if we add such a quirk
table I would much rather have it contain entries for laptops which
actually have the camera upside down. Esp. since that is how we are doing
it in all other drivers. It just does not make sense to flip by default, and
then keep a list of non buggy laptops, and change the flipping behavior there ...

Regards,

Hans
