Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:36705 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZHIH5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Aug 2009 03:57:23 -0400
Received: by qyk34 with SMTP id 34so2197530qyk.33
        for <linux-media@vger.kernel.org>; Sun, 09 Aug 2009 00:57:24 -0700 (PDT)
MIME-Version: 1.0
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Sun, 9 Aug 2009 16:57:04 +0900
Message-ID: <5e9665e10908090057n25103147s8b048bb0eb1d2d5b@mail.gmail.com>
Subject: About some sensor drivers in mc5602 gspca driver
To: v4l2_linux <linux-media@vger.kernel.org>
Cc: erik.andren@gmail.com, moinejf@free.fr,
	"Verkuil, Hans" <hverkuil@xs4all.nl>,
	=?UTF-8?B?6rmALCDrj5nsiJg=?= <dongsoo45.kim@samsung.com>,
	=?UTF-8?B?6rmALCDtmJXspIA=?= <riverful.kim@samsung.com>,
	=?UTF-8?B?67CVLCDqsr3rr7w=?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

It has been years I've working on linux multimedia drivers, but what a
shame I found that there were already sensor drivers that I've already
implemented. Precisely speaking, soc camera devices from Samsung named
s5k4aa* and s5k83a* were already in Linux kernel and even seems to
have been there for years.
But a thing that I'm curious is those drivers are totally mc602 and
gspca oriented. So some users who are intending to use those samsung
camera devices but not using gspca and mc5602 H/W have to figure out
another way.
As you know, the s5k* camera devices are actually ISP devices which
are made in SoC device and can be used independently with any kind of
ITU or MIPI supporting host devices.
However, I see that gspca and mc5602 have their own driver structure
so it seems to be tough to split out the sensor drivers from them.
So, how should we coordinate our drivers if a new s5k* driver is
getting adopted in the Linux kernel? different version of s5k* drivers
in gspca and subdev or gspca also is able to use subdev drivers?
I am very willing to contribute several drivers for s5k* soc camera
isp devices and in the middle of researching to prepare for
contribution those s5k* drivers popped up.
Please let me know whether it is arrangeable or not.
Cheers,

Nate

-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
