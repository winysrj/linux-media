Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab2JASZD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 14:25:03 -0400
Date: Mon, 1 Oct 2012 15:24:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [GIT PULL FOR v3.7] Add missing vidioc-subdev-g-edid.xml.
Message-ID: <20121001152456.16923835@redhat.com>
In-Reply-To: <201209261033.51510.hverkuil@xs4all.nl>
References: <201209251356.34176.hverkuil@xs4all.nl>
	<201209261033.51510.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Sep 2012 10:33:51 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Tue 25 September 2012 13:56:34 Hans Verkuil wrote:
> > Hi Mauro,
> > 
> > As requested!
> 
> I've respun this tree, fixing one documentation bug (the max value for
> 'blocks' is 256, not 255) and adding an overflow check in v4l2-ioctl.c as
> reported by Dan Carpenter:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg52640.html

It seems you forgot to send the patches for review at the ML (at least, I'm
not seeing it on my linux-media local inbox).

Also, please document it better. Only after reading Dan's email I was able
to understand *why* you wrote such patch, as your patch description is bogus:

> Subject: Return -EINVAL if blocks > 256.
>
>...
>
>@@ -2205,6 +2205,10 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
>                struct v4l2_subdev_edid *edid = parg;
> 
>                if (edid->blocks) {
>+                       if (edid->blocks > 256) {
>+                               ret = -EINVAL;
>+                               break;

Well, Kernel developers are generally able to read C, so you don't need to repeat
what's written at the code as the patch subject ;)

Dan's comment provides the reason why this patch is needed:

>  2207                          *array_size = edid->blocks * 128;
>                                              ^^^^^^^^^^^^^^^^^^
> This can overflow.

So, the patch subject should be saying, instead:

v4l2-ioctl: limit the max amount of edid blocks to avoid overflow

and putting Dan's comments in the body of the patch description.

Thanks!
Mauro
