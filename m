Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39622 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbZGGN4B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2009 09:56:01 -0400
Received: by fxm18 with SMTP id 18so4921169fxm.37
        for <linux-media@vger.kernel.org>; Tue, 07 Jul 2009 06:55:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A53509D.8060503@redhat.com>
References: <4A53509D.8060503@redhat.com>
Date: Tue, 7 Jul 2009 15:55:59 +0200
Message-ID: <62e5edd40907070655g75dbfc5dy3799d85a15ad4a6c@mail.gmail.com>
Subject: Re: RFC: howto handle driver changes which require libv4l > x.y ?
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/7/7 Hans de Goede <hdegoede@redhat.com>:
> Hi All,
>
> So recently I've hit 2 issues where kernel side fixes need
> to go hand in hand with libv4l updates to not cause regressions.
>
> First lets discuss the 2 cases:
> 1) The pac207 driver currently limits the framerate (and thus
>   the minimum exposure time) because at higher framerate the
>   cam starts using a higher compression and we could not
>   decompress this. Thanks to Bertrik Sikken we can now handle
>   the higher decompression.
>
>   So no I really want to enable the higher framerates as those
>   are needed to make the cam work properly in full daylight.
>
>   But if I do this, things will regress for people with an
>   older libv4l, as that won't be able to decompress the frames
>
> 2) Several zc3xxx cams have a timing issue between the bridge and
>   the sensor (the windows drivers have the same issue) which
>   makes them do only 320x236 instead of 320x240. Currently
>   we report their resolution to userspace as 320x240, leading to
>   a bar of noise at the bottom of the screen.
>
>   The fix here obviously is to report the real effective resoltion
>   to userspace, but this will cause regressions for apps which blindly
>   assume 320x240 is available (such as skype). The latest libv4l will
>   make the apps happy again by giving them 320x240 by adding small
>   black borders.
>
>
> Now I see 2 solutions here:
>
> a) Just make the changes, seen from the kernel side these are most
>   certainly bugfixes. I tend towards this for case 2)
>
> b) Come up with an API to tell the libv4l version to the kernel and
>   make these changes in the drivers conditional on the libv4l version
>
>
Solution b) sounds messy and will probably lead to a lot of error
prone glue code in the kernel.
Fast-forward a couple of libv4l releases and you will have a nightmare
maintainability scenario.

If people run an old libv4l with a new kernel and run into problem,
just tell them to upgrade their libv4l version.

My 2 cents,
Erik


> So this is my dilemma, your input is greatly appreciated.
>
> Regards,
>
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
