Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56802 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3CPH0Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Mar 2013 03:26:24 -0400
Received: by mail-wg0-f52.google.com with SMTP id 15so2666174wgd.19
        for <linux-media@vger.kernel.org>; Sat, 16 Mar 2013 00:26:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com>
References: <9ae3227f74816dbf699bbc8b1ce6202a5de1582f.1363342714.git.hans.verkuil@cisco.com>
 <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl> <968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 16 Mar 2013 12:56:02 +0530
Message-ID: <CA+V-a8vuOJitDEyWahc4Us2uThffiLB-0HW+KH2dVwLKN2yOqg@mail.gmail.com>
Subject: Re: [REVIEW PATCH 3/5] v4l2: pass std by value to the write-only
 s_std ioctl.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch!

On Fri, Mar 15, 2013 at 3:57 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This ioctl is defined as IOW, so pass the argument by value instead of by
> reference. I could have chosen to add const instead, but this is 1) easier
> to handle in drivers and 2) consistent with the s_std subdev operation.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
[snip]
>  drivers/media/platform/davinci/vpbe.c           |    8 ++++----
>  drivers/media/platform/davinci/vpbe_display.c   |    2 +-
>  drivers/media/platform/davinci/vpfe_capture.c   |   12 ++++++------
>  drivers/media/platform/davinci/vpif_capture.c   |    6 +++---
>  drivers/media/platform/davinci/vpif_display.c   |   10 +++++-----
[snip]
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |    6 +++---

For the above

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
http://www.linkedin.com/pub/prabhakar-lad/19/92b/955
