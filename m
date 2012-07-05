Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab2GEUzi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 16:55:38 -0400
Message-ID: <4FF5FF3F.6030909@redhat.com>
Date: Thu, 05 Jul 2012 17:55:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.6] V4L2 API cleanups
References: <4FD50223.4030501@iki.fi>
In-Reply-To: <4FD50223.4030501@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-06-2012 17:22, Sakari Ailus escreveu:
> Hi Mauro,
> 
> Here are two V4L2 API cleanup patches; the first removes __user from
> videodev2.h from a few places, making it possible to use the header file
> as such in user space, while the second one changes the
> v4l2_buffer.input field back to reserved.
> 
> 
> The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:
> 
>    [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24
> 09:27:24 -0300)
> 
> are available in the git repository at:
>    ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.6
> 
> Sakari Ailus (2):
>        v4l: Remove __user from interface structure definitions

>        v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT

Indeed, no drivers use V4L2_BUF_FLAG_INPUT, although I think this should be
used there, for some devices.

There are several surveillance boards (mostly bttv boards, but there are
also cx88 and saa7134 models in the market) where the same chip is used 
by up to 4 cameras. What software does is to switch the video input
to sample one of those cameras on a given frequency (1/60Hz or 1/30Hz),
in order to collect the streams for the 4 cameras.

Without an input field there at the buffer metadata, it might happen that 
software would look into the wrong input.

That's said, considering that:

1) no driver is currently filling buffer queue with its "inputs" field,
   this flag is not used anywhere;

2) an implementation for input switch currently requires userspace to tell
   Kernel to switch to the next input, with is racy;

3) a model where the Kernel itself would switch to the next input would
   require some Kernelspace changes.

I agree that we can just remove this bad implementation. If latter needed,
we'll need to not only reapply this patch but also to add a better way to
allow time-sharing the same video sampler with multiple inputs.

So, I'll apply this patch.

Regards,
Mauro
