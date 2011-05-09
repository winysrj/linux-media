Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45872 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab1EIVlV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 17:41:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Jiang, Scott" <Scott.Jiang@analog.com>
Subject: Re: why is there no enum_input in v4l2_subdev_video_ops
Date: Mon, 9 May 2011 23:42:05 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
References: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE0C@NWD2CMBX1.ad.analog.com> <Pine.LNX.4.64.1105091102320.21938@axis700.grange> <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE4D@NWD2CMBX1.ad.analog.com>
In-Reply-To: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE4D@NWD2CMBX1.ad.analog.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105092342.06166.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Scott,

On Monday 09 May 2011 11:53:18 Jiang, Scott wrote:
> Hi all,
> 
> >> Why is there no enum_input operation in v4l2_subdev_video_ops?

Why do you need one ?

> > Maybe because noone needed it until now?
> > 
> >> I found some drivers put this info in board specific data, but in my
> >> opinion this info is sensor or decoder related.
> > 
> > Can you tell which drivers / boards you're referring to?
> 
> I referred to drivers/media/video/davinci files.
> 
> >> So it should be put into the sensor drivers.
> > 
> > Maybe. Also notice, I'm not a maintainer nor a principal v4l2-subdev
> > developer. I've added Hans and Laurent to Cc:, will see what they say, or
> > you can just point out which drivers / platforms are doing this wrong and
> > propose a fix.
> 
> Sorry, I only found your mail in MAINTAINERS.

-- 
Regards,

Laurent Pinchart
