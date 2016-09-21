Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:30449 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbcIUGhJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 02:37:09 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: merge soc_mediabus.c into pxa_camera.c
References: <874d9ba3-7508-7efd-e83f-a7c630a1fbe3@xs4all.nl>
Date: Wed, 21 Sep 2016 08:37:06 +0200
In-Reply-To: <874d9ba3-7508-7efd-e83f-a7c630a1fbe3@xs4all.nl> (Hans Verkuil's
        message of "Sun, 11 Sep 2016 11:02:33 +0200")
Message-ID: <87r38ddai5.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Linking soc_mediabus into this driver causes multiple definition linker warnings
> if soc_camera is also enabled:
>
>    drivers/media/platform/soc_camera/built-in.o:(___ksymtab+soc_mbus_image_size+0x0): multiple definition of `__ksymtab_soc_mbus_image_size'
>    drivers/media/platform/soc_camera/soc_mediabus.o:(___ksymtab+soc_mbus_image_size+0x0): first defined here
>>> drivers/media/platform/soc_camera/built-in.o:(___ksymtab+soc_mbus_samples_per_pixel+0x0): multiple definition of `__ksymtab_soc_mbus_samples_per_pixel'
>    drivers/media/platform/soc_camera/soc_mediabus.o:(___ksymtab+soc_mbus_samples_per_pixel+0x0): first defined here
>    drivers/media/platform/soc_camera/built-in.o: In function `soc_mbus_config_compatible':
>    (.text+0x3840): multiple definition of `soc_mbus_config_compatible'
>    drivers/media/platform/soc_camera/soc_mediabus.o:(.text+0x134): first defined here
>
> Since we really don't want to have to use any of the soc-camera code this patch
> copies the relevant code and data structures from soc_mediabus and renames it to pxa_mbus_*.
>
> The large table of formats has been culled a bit, removing formats that are not supported
> by this driver.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Robert Jarzmik <robert.jarzmik@free.fr>

Hi Hans,

I wonder why you chose to copy-paste this code instead of adding in the Kconfig
a "depends on !SOC_CAMERA". Any specific reason ? As this will have to be dealt
with later anyway as you pointed out earlier, this format translation I mean, I
was wondering if this was the best approach.

Cheers.

--
Robert
