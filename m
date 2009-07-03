Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:33323 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139AbZGCCJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2009 22:09:53 -0400
Received: by yxe26 with SMTP id 26so2977620yxe.33
        for <linux-media@vger.kernel.org>; Thu, 02 Jul 2009 19:09:55 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Implement V4L2_CAP_STREAMING for zr364xx driver
Date: Thu, 2 Jul 2009 23:09:47 -0300
Cc: Antoine Jacquet <royale@zerezo.com>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
References: <200903252025.11544.lamarque@gmail.com> <20090328063448.66ff0340@pedra.chehab.org> <200903280711.37892.lamarque@gmail.com>
In-Reply-To: <200903280711.37892.lamarque@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907022309.47562.lamarque@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Hi all,

	I have noticed the patch mentioned in the subject was not included in 2.6.30. 
Do you plan to add it to 2.6.31?

Em Saturday 28 March 2009, Lamarque Vieira Souza escreveu:
> This patch implements V4L2_CAP_STREAMING for the zr364xx driver, by
> converting the driver to use videobuf.
>
> Tested with Creative PC-CAM 880.
>
> It basically:
> . implements V4L2_CAP_STREAMING using videobuf;
>
> . re-implements V4L2_CAP_READWRITE using videobuf;
>
> . copies cam->udev->product to the card field of the v4l2_capability
> struct. That gives more information to the users about the webcam;
>
> . moves the brightness setting code from before requesting a frame (in
> read_frame) to the vidioc_s_ctrl ioctl. This way the brightness code is
> executed only when the application requests a change in brightness and
> not before every frame read;
>
> . comments part of zr364xx_vidioc_try_fmt_vid_cap that says that Skype +
> libv4l do not work.
>
> This patch fixes zr364xx for applications such as mplayer,
> Kopete+libv4l and Skype+libv4l can make use of the webcam that comes
> with zr364xx chip.
>
> Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>
> ---
>
> --- v4l-dvb/linux/drivers/media/video/zr364xx.c	2009-03-27
> 15:18:54.050413997 -0300
> +++ v4l-dvb/linux-lvs/drivers/media/video/zr364xx.c	2009-03-27
> 15:22:47.914414277 -0300
... stripped off to not bloat the e-mail.

-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/
