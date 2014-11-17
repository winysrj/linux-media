Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45424 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbaKQKLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 05:11:06 -0500
Date: Mon, 17 Nov 2014 08:11:00 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: =?UTF-8?B?0JHQsNGA0YIg0JPQvtC/0L3QuNC6?= <bart.gopnik@gmail.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Mike Thomas <rmthomas@sciolus.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: STK1160 Sharpness
Message-ID: <20141117081100.72908b15@recife.lan>
In-Reply-To: <CAL+AA1=Sbe3D4BmV-Pv7SEhUBQutFiYMQ-H=iUWuAsY5aiTEzA@mail.gmail.com>
References: <CAL+AA1ntfVxkaHhY8qNciBkHRw0SXOAzBJgV+A9Y7oYtbD38mQ@mail.gmail.com>
	<CALF0-+VpPttePKF-VTLJ5Y29_EZtSz96PwN9av1SOkkc414CRA@mail.gmail.com>
	<CAL+AA1nUAgOYUeWxrgeHiWaDSkHvh0yXuwA-gjdUomn-s_HVyA@mail.gmail.com>
	<CALF0-+WuVtk3SpwCNfJB88jvgXEujVPmT9ute6Ohdhi=0VsOSw@mail.gmail.com>
	<20141109111200.6fb604c8@recife.lan>
	<CAL+AA1kQSrOCSxUPkSFa8xxpkCRJUj+46-RCwVhUrUc6Jduv9A@mail.gmail.com>
	<CAL+AA1=Sbe3D4BmV-Pv7SEhUBQutFiYMQ-H=iUWuAsY5aiTEzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 17 Nov 2014 12:51:46 +0300
Барт Гопник <bart.gopnik@gmail.com> escreveu:

> (Where) can I find the the full list of the (key) differences between
> SAA7113 and GM7113?

I've no idea. Perhaps you would need to get both datasheets and compare
them.

> If it is not hard to do it, can anybody please implement it?

The hardest part seems to graduate the sharpness levels, as sharpness
actually is split into 3 different controls.

Of course, one interested on doing that would need to have a device
with the needed chipsets and time/interest on doing that.

Adding control framework at stk1160 also requires some time. I can't
volunteer myself of doing that. I don't have any stk1160-based
devices.

> Unfortunately, I'm not very good with system drivers programming.
> 
> I'm interesting only in sharpness control because the image quality
> (sharpness) during capture using CVBS input is bad (on my EasyCap
> device). If I use S-Video input, the quality (sharpness) is better. 

Yeah, the saa7115 datasheet (freely available at NXP site) mentions that 
sharpness control may be needed for some kinds of output.

> It is important to implement it, because the sharpness control
> implemented in hardware (not in software, post-processing filtering).
> Control of other parameters like gamma are also don't work, but I'm
> not sure that gamma control is hardware (not software) implemented
> (I'm not found any info about gamma in saa7113 datasheet).

Regards,
Mauro
