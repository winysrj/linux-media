Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46734 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZC1JfC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 05:35:02 -0400
Date: Sat, 28 Mar 2009 06:34:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Lamarque Vieira Souza <lamarque@gmail.com>
Cc: Antoine Jacquet <royale@zerezo.com>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
Subject: Re: Patch implementing V4L2_CAP_STREAMING for zr364xx driver
Message-ID: <20090328063448.66ff0340@pedra.chehab.org>
In-Reply-To: <200903271539.27515.lamarque@gmail.com>
References: <200903252025.11544.lamarque@gmail.com>
	<20090327133914.7050d21d@pedra.chehab.org>
	<200903271539.27515.lamarque@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lamarque,
On Fri, 27 Mar 2009 15:39:26 -0300
Lamarque Vieira Souza <lamarque@gmail.com> wrote:

> 	Here is the patch with the modifications you asked.

There's just one important part missing on your patch: you forgot so send your
Signed-off-by: (please read README.patches file, at v4l-dvb tree:
http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches).

Also, you didn't provide a description.

So, I need you to re-send at the proper format, by adding a subject line like:

[PATCH] Implement V4L2_CAP_STREAMING for zr364xx driver

And the body of the email should contain just the description plus your patch. Something like:

This patch implements V4L2_CAP_STREAMING for the zr364xx driver, by
converting the driver to use videobuf.

Tested with PC-CAM 880.

It basically:
. re-implements V4L2_CAP_READWRITE using videobuf;

. copies cam->udev->product to the card field of the v4l2_capability struct.
That gives more information to the users about the webcam;

. moves the brightness setting code from before requesting a frame (in
read_frame) to the vidioc_s_ctrl ioctl. This way the brightness code is
executed only when the application request a change in brightness and
not before every frame read;

. comments part of zr364xx_vidioc_try_fmt_vid_cap that says that Skype + libv4l
do not work.

This patch fixes zr364xx for applications such as mplayer,
Kopete+libv4l and Skype+libv4l can make use of the webcam that comes
with zr364xx chip.

Signed-off-by: <your name/email should be here>

<the patch>
