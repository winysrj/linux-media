Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45044 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab0LROUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 09:20:53 -0500
Received: by wwa36 with SMTP id 36so1586453wwa.1
        for <linux-media@vger.kernel.org>; Sat, 18 Dec 2010 06:20:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012181231.27198.hverkuil@xs4all.nl>
References: <201012181231.27198.hverkuil@xs4all.nl>
Date: Sat, 18 Dec 2010 09:20:50 -0500
Message-ID: <AANLkTin+R4A8uvJXO4xxSnDe=vXgHTKrYsgPvGuo__rE@mail.gmail.com>
Subject: Re: Volunteers needed: BKL removal: replace .ioctl by .unlocked_ioctl
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	sakari.ailus@maxwell.research.nokia.com,
	David Cohen <dacohen@gmail.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Mike Isely <isely@isely.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Anatolij Gustschin <agust@denx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Good work, thanks Hans.

> I've made an inventory of all drivers that still use .ioctl and I am looking
> for volunteers to tackle one or more drivers.

> cx23885 (Steve Toth)
> cx88

I'll take care of these and also the saa7164 driver.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
