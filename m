Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:39388 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab3CPMSj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Mar 2013 08:18:39 -0400
Received: by mail-ve0-f175.google.com with SMTP id cy12so3229533veb.6
        for <linux-media@vger.kernel.org>; Sat, 16 Mar 2013 05:18:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <097e3e28dc8fbe8105fa3b2a489e18a5c5eca7bb.1363342714.git.hans.verkuil@cisco.com>
References: <9ae3227f74816dbf699bbc8b1ce6202a5de1582f.1363342714.git.hans.verkuil@cisco.com>
	<1363343245-23531-1-git-send-email-hverkuil@xs4all.nl>
	<097e3e28dc8fbe8105fa3b2a489e18a5c5eca7bb.1363342714.git.hans.verkuil@cisco.com>
Date: Sat, 16 Mar 2013 16:18:38 +0400
Message-ID: <CALW4P+KY8iXrVm5GEPQ=_8O2qYxOqStxE15_Gifo-Hwkuy=ozw@mail.gmail.com>
Subject: Re: [REVIEW PATCH 2/5] v4l2: add const to argument of write-only
 s_tuner ioctl.
From: Alexey Klimov <klimov.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
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

On Fri, Mar 15, 2013 at 2:27 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This ioctl is defined as IOW, so pass the argument as const.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

[snip]

>  drivers/media/radio/dsbr100.c                    |    2 +-

>  drivers/media/radio/radio-ma901.c                |    2 +-

>  drivers/media/radio/radio-mr800.c                |    2 +-

Acked-by: Alexey Klimov <klimov.linux@gmail.com>

for this three radio drivers.
Thanks.

-- 
Best regards, Klimov Alexey
