Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:28305 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752083AbcIWSXN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 14:23:13 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: merge soc_mediabus.c into pxa_camera.c
References: <874d9ba3-7508-7efd-e83f-a7c630a1fbe3@xs4all.nl>
        <87r38ddai5.fsf@belgarion.home>
        <68f66d44-2098-1b01-3ebb-2261afe4fd29@xs4all.nl>
Date: Fri, 23 Sep 2016 20:23:09 +0200
In-Reply-To: <68f66d44-2098-1b01-3ebb-2261afe4fd29@xs4all.nl> (Hans Verkuil's
        message of "Wed, 21 Sep 2016 08:46:45 +0200")
Message-ID: <87eg4acw6q.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

>> Hi Hans,
>> 
>> I wonder why you chose to copy-paste this code instead of adding in the Kconfig
>> a "depends on !SOC_CAMERA". Any specific reason ? As this will have to be dealt
>> with later anyway as you pointed out earlier, this format translation I mean, I
>> was wondering if this was the best approach.
>
> I thought about that, but that would make it impossible to COMPILE_TEST both the
> pxa and the soc_camera driver. In addition, the pxa and soc_camera are the only
> drivers that use this, and I prefer to just merge that code into pxa so that it can
> be modified independently from soc_camera.
>
> I really want to remove all dependencies to soc_camera. That will also make it easier
> to refactor soc_camera once I get the atmel-isi driver out of soc_camera.
Ok, fair enough.

I have tested that for at least YUV422, YUYV, YVYU and RGB565 formats :
Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

-- 
Robert
