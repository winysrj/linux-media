Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32845 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZC0Qj0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 12:39:26 -0400
Date: Fri, 27 Mar 2009 13:39:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Lamarque Vieira Souza <lamarque@gmail.com>
Cc: Antoine Jacquet <royale@zerezo.com>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
Subject: Re: Patch implementing V4L2_CAP_STREAMING for zr364xx driver
Message-ID: <20090327133914.7050d21d@pedra.chehab.org>
In-Reply-To: <200903252025.11544.lamarque@gmail.com>
References: <200903252025.11544.lamarque@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Wed, 25 Mar 2009 20:25:10 -0300
Lamarque Vieira Souza <lamarque@gmail.com> wrote:

> 	Hi,
> 
>         I have implemented V4L2_CAP_STREAMING for the zr364xx driver (see the 
> attached file). Could you review the code for me? My 
> Creative PC-CAM 880 works, but I do not have any other webcam to test the 
> code. Besides the streaming implementation the patch also does:
> 
> . re-implement V4L2_CAP_READWRITE using videobuf.
> 
> . copy cam->udev->product to the card field of the v4l2_capability struct. 
> That gives more information to the users about the webcam.
> 
> . move the brightness setting code from before requesting a frame (in 
> read_frame) to the vidioc_s_ctrl ioctl. This way the brightness code is 
> executed only when the application request a change in brightness and not 
> before every frame read. Is there any reason to set the brightness before 
> every frame read?
> 
> . comment part of zr364xx_vidioc_try_fmt_vid_cap. Skype + libv4l do not work 
> if it is there and libv4's maintainer told me it is a driver bug, so I fix it.
> 
> 	This patch is needed for applications such as mplayer, Kopete+libv4l and 
> Skype+libv4l can make use of the webcam that comes with zr364xx chip. The 
> patch is big, if you need it splitted into small patches I can do it.

Your patch didn't apply:

patching file drivers/media/video/zr364xx.c
Hunk #4 FAILED at 37.
Hunk #5 succeeded at 114 (offset 2 lines).
Hunk #7 succeeded at 474 (offset 2 lines).
Hunk #9 succeeded at 782 (offset 2 lines).
Hunk #11 succeeded at 848 (offset 2 lines).
Hunk #13 succeeded at 918 (offset 2 lines).
Hunk #15 succeeded at 1198 (offset 2 lines).
Hunk #17 succeeded at 1242 (offset 2 lines).
Hunk #19 succeeded at 1373 (offset 2 lines).
Hunk #21 succeeded at 1409 (offset 2 lines).
Hunk #23 succeeded at 1532 (offset 2 lines).
1 out of 24 hunks FAILED -- saving rejects to file drivers/media/video/zr364xx.c.rej
Patch doesn't apply

Probably because you didn't generate it against the development tree. Could you please re-generate it against:
	http://linuxtv.org/hg/v4l-dvbg/v4l-dvb

The better is to clone it using:
	hg clone http://linuxtv.org/hg/v4l-dvb


Also, please test it against checkpatch tool, since there are a few coding style issues like:

	}
	else {

and
	if (foo)
	{

Violating Linux codingstyle. For more info, please read the README.patches file at the tree.


> Lamarque V. Souza
> http://www.geographicguide.com/brazil.htm
> Linux User #57137 - http://counter.li.org/

Legal! outro brasileiro na lista! Bem vindo ao time.

Cheers,
Mauro
