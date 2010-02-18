Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46664 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753335Ab0BRTuv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 14:50:51 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] radio-si470x-common: -EINVAL overwritten in si470x_vidioc_s_tuner()
Date: Thu, 18 Feb 2010 20:50:41 +0100
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4B69D2F5.2050100@gmail.com> <201002032252.36514.tobias.lorenz@gmx.net> <4B6A242C.8060104@infradead.org>
In-Reply-To: <4B6A242C.8060104@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002182050.41968.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

> > no, the default value of retval makes no difference to the function.
> > 
> > Retval is set by si470x_disconnect_check and si470x_set_register.
> > After each call, retval is checked.
> > There is no need to reset it passed.

> You may just do then:
> 
> 	int retval = si470x_disconnect_check(radio);

In all other set/get functions of v4l2_ioctl_ops in the driver, I just set the default value of retval to 0.
To be identical in si470x_vidioc_s_tuner, I modified the patch to the one below.
I already pushed this and another cosmetic patch into mercurial:

http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/72a2f38d5956
http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/3efd5d32a618

Mauro, can you pull them?

Bye,
Tobias

--- a/linux/drivers/media/radio/si470x/radio-si470x-common.c	Thu Feb 11 23:11:30 2010 -0200
+++ b/linux/drivers/media/radio/si470x/radio-si470x-common.c	Thu Feb 18 20:31:33 2010 +0100
@@ -748,7 +748,7 @@
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval = -EINVAL;
+	int retval = 0;
 
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
