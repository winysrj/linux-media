Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:65112 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3CPHoI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Mar 2013 03:44:08 -0400
Received: by mail-we0-f182.google.com with SMTP id t57so3825393wey.41
        for <linux-media@vger.kernel.org>; Sat, 16 Mar 2013 00:44:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <60593e2e438a51d9ba5be2179f56a0858df458db.1363342714.git.hans.verkuil@cisco.com>
References: <9ae3227f74816dbf699bbc8b1ce6202a5de1582f.1363342714.git.hans.verkuil@cisco.com>
 <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl> <60593e2e438a51d9ba5be2179f56a0858df458db.1363342714.git.hans.verkuil@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 16 Mar 2013 13:13:46 +0530
Message-ID: <CA+V-a8uWtg7c2ehKRt32xJ2D_049p4y98LmcEN0qmMxDVD9MaA@mail.gmail.com>
Subject: Re: [REVIEW PATCH 4/5] v4l2: add const to argument of write-only
 s_register ioctl.
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
> This ioctl is defined as IOW, so pass the argument as const.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
[snip]

>  drivers/media/platform/davinci/vpbe_display.c   |    2 +-
>  drivers/media/platform/davinci/vpif_capture.c   |    3 +-
>  drivers/media/platform/davinci/vpif_display.c   |    3 +-

For the above

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
http://www.linkedin.com/pub/prabhakar-lad/19/92b/955
