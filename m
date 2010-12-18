Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1168 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab0LRLq2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 06:46:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: Volunteers needed: BKL removal: replace .ioctl by .unlocked_ioctl
Date: Sat, 18 Dec 2010 12:46:09 +0100
Cc: pawel@osciak.com, Marek Szyprowski <m.szyprowski@samsung.com>,
	Steven Toth <stoth@kernellabs.com>,
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
References: <201012181231.27198.hverkuil@xs4all.nl>
In-Reply-To: <201012181231.27198.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012181246.09823.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Saturday, December 18, 2010 12:31:26 Hans Verkuil wrote:
> Driver list:
> 
> saa7146 (Hans Verkuil)
> mem2mem_testdev (Pawel Osciak or Marek Szyprowski)
> cx23885 (Steve Toth)
> cx18-alsa (Andy Walls)
> omap24xxcam (Sakari Ailus or David Cohen)
> au0828 (Janne Grunau)
> cpia2 (Andy Walls or Hans Verkuil)
> cx231xx (Mauro Carvalho Chehab)
> davinci (Muralidharan Karicheri)
> saa6588 (Hans Verkuil)
> pvrusb2 (Mike Isely)
> usbvision (Hans Verkuil)
> s5p-fimc (Sylwester Nawrocki)
> fsl-viu (Anatolij Gustschin)
> tlg2300 (Mauro Carvalho Chehab)
> zr364xx (Hans de Goede)
> soc_camera (Guennadi Liakhovetski)
> usbvideo/vicam (Hans de Goede)
> s2255drv (Pete Eberlein)
> bttv (Mauro Carvalho Chehab)
> stk-webcam (Hans de Goede)
> se401 (Hans de Goede)
> si4713-i2c (Hans Verkuil)
> dsbr100 (Hans Verkuil)

Oops, si4713-i2c and saa6588 are subdevs, so those two can be removed from
this list.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
