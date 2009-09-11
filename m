Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbZIKSwx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 14:52:53 -0400
Date: Fri, 11 Sep 2009 15:52:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090911155217.0e0f01bd@caramujo.chehab.org>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436BA524F@dbde02.ent.ti.com>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<20090910172013.55825d2e@caramujo.chehab.org>
	<200909102335.52770.hverkuil@xs4all.nl>
	<20090911121342.08dd1939@caramujo.chehab.org>
	<829197380909110846t493deb9cga3a2af754f2e40cd@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E73940436BA522B@dbde02.ent.ti.com>
	<20090911140356.7a408159@caramujo.chehab.org>
	<19F8576C6E063C45BE387C64729E73940436BA524F@dbde02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Sep 2009 23:04:13 +0530
"Hiremath, Vaibhav" <hvaibhav@ti.com> escreveu:

> [Hiremath, Vaibhav] I was referring to standard V4L2 interface; I was referring to backward compatibility between Media controller devices itself.

Huh? There's no media controller concept implemented yet. Hans proposal is to
add a new API to enumerate devices, not to replace what currently exists.
> 
> Have you thought of custom parameter configuration? For example H3A(20)/Resizer(64) sub-device will have coeff. Which is non-standard (we had some discussion in the past) -
> 

I'm not saying that all new features should be implemented via sysfs. I'm just
saying that sysfs is the way Linux Kernel uses to describe device topology,
and, due to that, this is is the interface that applies at under the "media
controller" proposal.

In the case of resizer, I don't see why this can't be implemented as an ioctl
over /dev/video device.

> With SYSFS approach it is really difficult to pass big parameter to sub-device, which we can easily achieve using IOCTL.

I didn't get you point here. With sysfs, you can pass everything, even a mix of
strings and numbers, since get operation can be parsed via sscanf and generated
set uses sprintf (this doesn't mean that this is the recommended way to use it).

For example, on kernel 2.6.31, we have the complete hda audio driver pinup by
reading to just one var:

# cat /sys/class/sound/hwC0D0/init_pin_configs
0x11 0x02214040
0x12 0x01014010
0x13 0x991301f0
0x14 0x02a19020
0x15 0x01813030
0x16 0x413301f0
0x17 0x41a601f0
0x18 0x41a601f0
0x1a 0x41f301f0
0x1b 0x414511f0
0x1c 0x41a190f0

If you want to alter PIN 0x15 output config, all you need to do is:

# echo "0x15 0x02214040" >/sys/class/sound/hwC0D0/user_pin_configs
(or open /sys/class/sound/hwC0D0/init_pin_configs and write "0x15 0x02214040" to it)

And to reset to init config:
# echo 1 >/sys/class/sound/hwC0D0/clear

One big advantage is that you can have a shell script to do the needed setup,
automatically called by some udev rule, without needing to write a single line
of code. So, for those advanced configuration parameters that doesn't change
(for example board xtal speeds), you don't need to code it on your application.
Yet, you can do there, if needed.

Cheers,
Mauro
