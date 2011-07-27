Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:42099 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab1G0Stn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 14:49:43 -0400
Received: by eye22 with SMTP id 22so2264862eye.2
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 11:49:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL8ugEdYGV9H8vXWErh5-cKRhjT8nU8CxHoOSgxUJ3E_um1gFg@mail.gmail.com>
References: <1310581347-31102-1-git-send-email-agnel.joel@gmail.com>
	<CAL8ugEc33uZBEz-5WxVd5aGArCRq8tv6X1K0uaJHiEVgqEfd6g@mail.gmail.com>
	<6F36B362-244D-4127-8E57-2E4441709159@beagleboard.org>
	<CAL8ugEdYGV9H8vXWErh5-cKRhjT8nU8CxHoOSgxUJ3E_um1gFg@mail.gmail.com>
Date: Wed, 27 Jul 2011 13:49:41 -0500
Message-ID: <CAD=GYpbVf94cxMhud8eted7WBX_csN_abpyYFHR7tL9ng+cV5w@mail.gmail.com>
Subject: Re: [beagleboard] [RFC v1] mt9v113: VGA camera sensor driver and
 support for BeagleBoard
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Mark Grosen <mark@grosen.org>
Cc: beagleboard@googlegroups.com, jdk@ti.com,
	Javier Martin <javier.martin@vista-silicon.com>,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	k-kooi@ti.com, pprakash@ti.com, chase.maupin@ti.com,
	s-kipisz2@ti.com, saaguirre@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> Joel,
>>>
>>> I gave this a try this weekend. I ran into a few problems/questions.
>>>
>>> I wanted to try with pre-built (tested?) binaries so I grabbed yours
>>> (used your uImage):
>>> 1. media-ctl binary does not work because there is no libmediactl.so
>>> on my Angstrom root FS.
>>> 2. There was no yavta-nc application.
>>
>> have you tried 'opkg update ; opkg install mediactl yavta-nc' ?
>>
>
> Showing my Angstrom ignorance here, but I cannot get these packages
> via opkg update. I use Narcissus builder - I built a new FS yesterday
> using 2011.03 - should I have used "next". It runs fine, but when I do
> the opkg update; opkg install yavta-nc  it fails. I see media-ctl and
> yavta-nc in the package browser website, but my guess is they are for
> "newer" builds?
>

What is the failure? If you have some output, could you paste it?

As a last resort, you could download the .ipk from Angstrom Package
browser, and uncompress it to get yavta-nc

Thanks,
Joel
