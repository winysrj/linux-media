Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:60306 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaKQJvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 04:51:47 -0500
Received: by mail-lb0-f169.google.com with SMTP id 10so15871552lbg.28
        for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 01:51:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL+AA1kQSrOCSxUPkSFa8xxpkCRJUj+46-RCwVhUrUc6Jduv9A@mail.gmail.com>
References: <CAL+AA1ntfVxkaHhY8qNciBkHRw0SXOAzBJgV+A9Y7oYtbD38mQ@mail.gmail.com>
	<CALF0-+VpPttePKF-VTLJ5Y29_EZtSz96PwN9av1SOkkc414CRA@mail.gmail.com>
	<CAL+AA1nUAgOYUeWxrgeHiWaDSkHvh0yXuwA-gjdUomn-s_HVyA@mail.gmail.com>
	<CALF0-+WuVtk3SpwCNfJB88jvgXEujVPmT9ute6Ohdhi=0VsOSw@mail.gmail.com>
	<20141109111200.6fb604c8@recife.lan>
	<CAL+AA1kQSrOCSxUPkSFa8xxpkCRJUj+46-RCwVhUrUc6Jduv9A@mail.gmail.com>
Date: Mon, 17 Nov 2014 12:51:46 +0300
Message-ID: <CAL+AA1=Sbe3D4BmV-Pv7SEhUBQutFiYMQ-H=iUWuAsY5aiTEzA@mail.gmail.com>
Subject: Re: STK1160 Sharpness
From: =?UTF-8?B?0JHQsNGA0YIg0JPQvtC/0L3QuNC6?= <bart.gopnik@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Mike Thomas <rmthomas@sciolus.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Where) can I find the the full list of the (key) differences between
SAA7113 and GM7113?

If it is not hard to do it, can anybody please implement it?
Unfortunately, I'm not very good with system drivers programming.

I'm interesting only in sharpness control because the image quality
(sharpness) during capture using CVBS input is bad (on my EasyCap
device). If I use S-Video input, the quality (sharpness) is better. It
is important to implement it, because the sharpness control
implemented in hardware (not in software, post-processing filtering).
Control of other parameters like gamma are also don't work, but I'm
not sure that gamma control is hardware (not software) implemented
(I'm not found any info about gamma in saa7113 datasheet).
