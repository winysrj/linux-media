Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60178 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756702Ab0FSThZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jun 2010 15:37:25 -0400
Date: Sat, 19 Jun 2010 21:37:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org
Subject: Re: Report of Helsinki mini-summit
In-Reply-To: <201006191611.25271.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1006192130120.16798@axis700.grange>
References: <201006191611.25271.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 19 Jun 2010, Hans Verkuil wrote:

> 6) TO DO list regarding V4L2 core framework including the new control framework.
> 
> - Control Framework: done, just needs a pull request. Some discussions on how
>   to handle 'auto-foo' and 'foo' controls (e.g. autogain/gain). Can be fixed
>   later.
> - Replace all s/g/try_fmt subdev ops with s/g/try_busfmt. Mostly done, want to

s/g/try_mbus_fmt were probably meant, as well as enum_mbus_fmt for that 
matter;)

>   finish this for 2.6.36.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
