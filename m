Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3931 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZCIHlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 03:41:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dongsoo Nathaniel Kim <dongsoo.kim@gmail.com>
Subject: Re: Is there any reference for v4l2-subdev?
Date: Mon, 9 Mar 2009 08:41:46 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?utf-8?q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <5e9665e10903081842h2c8a7185lc9a7e2a6d0f63a2a@mail.gmail.com>
In-Reply-To: <5e9665e10903081842h2c8a7185lc9a7e2a6d0f63a2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903090841.46902.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 09 March 2009 02:42:03 Dongsoo Nathaniel Kim wrote:
> Hello Hans,
>
> I've been working on camera device based on v4l2-int-device until now,
> but to follow latest work of yours I decided to make my driver in v4l2
> subdev before I send patch to the list.
> So I'm trying to find any passable driver to reference but I haven't
> found any one yet.
> Only thing I could find was v4l2-framework.txt for now. Am I missing
> something? I've not look into every single repository in hg yet, but
> which one could be the right one I am looking for?
> Please give me a guideline if there are some further work besides
> v4l2-framework.txt.
> Cheers,
>
> Nate

Hi Nate,

In the master v4l-dvb (www.linuxtv.org/hg/v4l-dvb) almost all i2c modules 
have been converted. It can however be confusing due to the use of 
backwards compatibility headers v4l2-i2c-drv.h and v4l2-i2c-drv-legacy.h. 
The latter will disappear once all adapter drivers have been converted. The 
first is still needed since the v4l-dvb master also supports kernels < 
2.6.22.

There has been a lot of discussion about that and it looks like 
v4l2-i2c-drv.h will probably disappear as well in the future as we will 
attempt to do the backwards compatibility in a different way.

Since you don't need such compatibility, you can ignore those headers and 
only concentrate on the subdev changes.

Good examples are wm8739.c and saa7115.c. Note that there are no sensor 
drivers converted as these are currently all soc-camera or v4l2-int based. 
I'm sure that you will need to add new ops to v4l2-subdev.h for sensor 
drivers.

The v4l-dvb master also contains several PCI and USB drivers that are 
converted to use v4l2_device/v4l2_subdev. Probably the best to look at is 
saa7134. Also interesting is cx18 since that models the analog digitizer 
part of the cx23418 device as a subdev, thus demonstrating that sub-devices 
do not have to be actual i2c devices.

It would be great if at least one sensor driver could be implemented in 
v4l2_subdev before the 2.6.30 merge window opens. Any changes that need to 
be made to v4l2_subdev to support such drivers will then be in the 2.6.30 
tree which will make it easier for you to track compared to v4l-dvb.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
