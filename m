Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:65186 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3CPGrE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Mar 2013 02:47:04 -0400
Date: Sat, 16 Mar 2013 07:46:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 3/5] v4l2: pass std by value to the write-only
 s_std ioctl.
In-Reply-To: <968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com>
Message-ID: <Pine.LNX.4.64.1303160745420.12165@axis700.grange>
References: <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl>
 <968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Fri, 15 Mar 2013, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This ioctl is defined as IOW, so pass the argument by value instead of by
> reference. I could have chosen to add const instead, but this is 1) easier
> to handle in drivers and 2) consistent with the s_std subdev operation.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

[snip]

>  drivers/media/platform/sh_vou.c                 |   12 ++++++------
>  drivers/media/platform/soc_camera/soc_camera.c  |    4 ++--

For the above two:

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
