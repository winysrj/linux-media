Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59029 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751255AbZLRKRE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 05:17:04 -0500
Date: Fri, 18 Dec 2009 11:17:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Created files in patch comment intended?
In-Reply-To: <4B2B5574.3090407@infradead.org>
Message-ID: <Pine.LNX.4.64.0912181114070.4406@axis700.grange>
References: <Pine.LNX.4.64.0912180756580.4406@axis700.grange>
 <4B2B5574.3090407@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 18 Dec 2009, Mauro Carvalho Chehab wrote:

> Hi Guennadi,
> 
> Guennadi Liakhovetski wrote:
> > Hi Mauro
> > 
> > Looking at how my mediabus patches got committed into the mainline, I 
> > noticed, that the add-mediabus patch contains a list of added files 
> > between the patch description and the Sob's:
> > 
> >      create mode 100644 drivers/media/video/soc_mediabus.c
> >      create mode 100644 include/media/soc_mediabus.h
> >      create mode 100644 include/media/v4l2-mediabus.h
> > 
> > Is this intended, and if yes - why? If not, maybe you'd like to fix this 
> > in your hg-git export scripts.
> > 
> No, this is not intentional. The scripts have a logic to identify the description
> body of a mercurial commit and of a patch received by email. The logic should
> just import whatever description is provided on -hg.
> 
> By looking on your commit for this patch on mercurial, we have:
> 
> $ hg log -r 13658 -v
> changeset:   13658:2c60bd900a7a
> user:        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> date:        Fri Dec 11 15:41:28 2009 +0100
> files:       linux/drivers/media/video/Makefile linux/drivers/media/video/soc_mediabus.c linux/include/media/soc_mediabus.h linux/include/media/v4l2-mediabus.h linux/include/media/v4l2-subdev.h
> description:
> v4l: add a media-bus API for configuring v4l2 subdev pixel and frame formats
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Video subdevices, like cameras, decoders, connect to video bridges over
> specialised busses. Data is being transferred over these busses in various
> formats, which only loosely correspond to fourcc codes, describing how video
> data is stored in RAM. This is not a one-to-one correspondence, therefore we
> cannot use fourcc codes to configure subdevice output data formats. This patch
> adds codes for several such on-the-bus formats and an API, similar to the
> familiar .s_fmt(), .g_fmt(), .try_fmt(), .enum_fmt() API for configuring those
> codes. After all users of the old API in struct v4l2_subdev_video_ops are
> converted, it will be removed. Also add helper routines to support generic
> pass-through mode for the soc-camera framework.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/Makefile       |    2 +-
>  drivers/media/video/soc_mediabus.c |  157 ++++++++++++++++++++++++++++++++++++
>  include/media/soc_mediabus.h       |   65 +++++++++++++++
>  include/media/v4l2-mediabus.h      |   61 ++++++++++++++
>  include/media/v4l2-subdev.h        |   19 ++++-
>  5 files changed, 302 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/media/video/soc_mediabus.c
>  create mode 100644 include/media/soc_mediabus.h
>  create mode 100644 include/media/v4l2-mediabus.h
> 
> 
> As you see, you added those comments at the end of the patch, together with a diffstat.
> While the script has a logic to remove diffstats, it doesn't contain anything to remove
> the "create mode" lines that you've added at the end of the patch description.

No, _I_ didn't add those, git did. This is the standard output from "git 
format patch." And the patch format for submission to the kernel is 
roughly

<subject>

<description>

<Sob, ack,...>
---
<ignored lines>
<diff -u>

So, anything, beginning with "---\n" and the patch must be ignored. That's 
also where you provide any comments, that should not be included in the 
commit text.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
