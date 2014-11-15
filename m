Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:61572 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaKONsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 08:48:30 -0500
Received: by mail-vc0-f171.google.com with SMTP id id10so5663401vcb.16
        for <linux-media@vger.kernel.org>; Sat, 15 Nov 2014 05:48:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANZNk81y8=ugk3Ds0FhoeYBzh7ATy1Uyo8gxUQFoiPcYcwD+yQ@mail.gmail.com>
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
	<m3sihmf3mc.fsf@t19.piap.pl>
	<CANZNk81y8=ugk3Ds0FhoeYBzh7ATy1Uyo8gxUQFoiPcYcwD+yQ@mail.gmail.com>
Date: Sat, 15 Nov 2014 17:48:29 +0400
Message-ID: <CAM_ZknUoNBfnKJW-76FE1tW29O6oFAw+KDYPsViTLw7u-vFXuw@mail.gmail.com>
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas
 or help?
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to all for the great help so far, but I've got another issue
with upstream driver.

In upstream there's no more module parameter for video standard
(NTSC/PAL). But there's VIDIOC_S_STD handling procedure. But it turns
out not to work correctly: the frame is offset, so that in the bottom
there's black horizontal bar.
The S_STD ioctl call actually makes difference, because without that
the frame "slides" vertically all the time. But after the call the
picture is not correct.

Such change didn't help:
https://github.com/krieger-od/linux/commit/55b796c010b622430cb85f5b8d7d14fef6f04fb4
So, temporarily, I've hardcoded this for exact customer who uses PAL:
https://github.com/krieger-od/linux/commit/2c26302dfa6d7aa74cf17a89793daecbb89ae93a
rmmod/modprobe cycle works fine and doesn't make any difference from
reboot, but still it works correctly only with PAL hardcoded for the
first-time initialization.

Any ideas why wouldn't it work to change the mode after the driver load?
Would it be allowed to add back that kernel module parameter (the one
passed at module load time)?
-- 
Bluecherry developer.
