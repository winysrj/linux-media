Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:41702 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752155Ab1I1W3d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 18:29:33 -0400
Message-ID: <4E839FCB.7050403@xenotime.net>
Date: Wed, 28 Sep 2011 15:29:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Sept 28 (media/video/mt9p031.c)
References: <20110928200404.6ed0d6c34161d233be8994fd@canb.auug.org.au>
In-Reply-To: <20110928200404.6ed0d6c34161d233be8994fd@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/11 03:04, Stephen Rothwell wrote:
> Hi all,


a.  Source file needs <linux/module.h> added to it unless the dropping
of the moduleh tree for today already contained that patch.

b.  Build errors after adding <linux/module.h>:

when CONFIG_MEDIA_CONTROLLER is not enabled
and CONFIG_VIDEO_V4L2_SUBDEV_API is not enabled:


drivers/media/video/mt9p031.c:443:3: error: implicit declaration of function 'v4l2_subdev_get_try_format'
drivers/media/video/mt9p031.c:457:3: error: implicit declaration of function 'v4l2_subdev_get_try_crop'
drivers/media/video/mt9p031.c:888:42: error: 'struct v4l2_subdev' has no member named 'entity'


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
