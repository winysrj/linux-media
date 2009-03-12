Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2548 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZCLHjR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 03:39:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Add cx231xx USB driver
Date: Thu, 12 Mar 2009 08:38:59 +0100
Cc: Sri Deevi via Mercurial <Srinivasa.Deevi@conexant.com>
References: <E1LhZu5-0002zX-83@www.linuxtv.org>
In-Reply-To: <E1LhZu5-0002zX-83@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120838.59192.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 12 March 2009 02:40:09 Patch from Sri Deevi wrote:
> The patch number 10954 was added via Mauro Carvalho Chehab
> <mchehab@redhat.com> to http://linuxtv.org/hg/v4l-dvb master development
> tree.
>
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
>
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>

Mauro,

What the hell??!

Since when does a big addition like this get merged without undergoing a 
public review?

I've been working my ass off converting drivers to the new i2c API and 
v4l2_subdev structures and here you merge a big driver that uses old-style 
(which will lead to 'deprecated' warnings when compiling with 2.6.29, BTW), 
where the driver writes directly to i2c modules instead of adding a proper 
i2c module for them. And what are 'colibri', 'flatrion' and 'hammerhead' 
anyway? Are they integrated devices of the cx231xx? Can they be used 
separately in other products as well?

So yes, I have objections. At the minimum it should be converted first to 
use v4l2_device/v4l2_subdev and I need more information on the new i2c 
devices so I can tell whether the code for those should be split off into 
separate i2c modules. Not to mention that I want to have the time to review 
this code more closely.

Sorry Sri, this isn't your fault.

Regards,

	Hans

>
> ------
>
> From: Sri Deevi  <Srinivasa.Deevi@conexant.com>
> Add cx231xx USB driver
>
>
> Signed-off-by: Srinivasa Deevi <srinivasa.deevi@conexant.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>
> ---
>
>  linux/drivers/media/video/Kconfig                    |    2
>  linux/drivers/media/video/Makefile                   |    1
>  linux/drivers/media/video/cx231xx/Kconfig            |   35
>  linux/drivers/media/video/cx231xx/Makefile           |   15
>  linux/drivers/media/video/cx231xx/cx231xx-audio.c    |  664 ++
>  linux/drivers/media/video/cx231xx/cx231xx-avcore.c   | 2289 ++++++++++
>  linux/drivers/media/video/cx231xx/cx231xx-cards.c    |  947 ++++
>  linux/drivers/media/video/cx231xx/cx231xx-conf-reg.h |  491 ++
>  linux/drivers/media/video/cx231xx/cx231xx-core.c     | 1197 +++++
>  linux/drivers/media/video/cx231xx/cx231xx-dvb.c      |  566 ++
>  linux/drivers/media/video/cx231xx/cx231xx-i2c.c      |  580 ++
>  linux/drivers/media/video/cx231xx/cx231xx-input.c    |  267 +
>  linux/drivers/media/video/cx231xx/cx231xx-reg.h      | 1574 +++++++
>  linux/drivers/media/video/cx231xx/cx231xx-vbi.c      |  697 +++
>  linux/drivers/media/video/cx231xx/cx231xx-vbi.h      |   61
>  linux/drivers/media/video/cx231xx/cx231xx-video.c    | 2440 +++++++++++
>  linux/drivers/media/video/cx231xx/cx231xx.h          |  771 +++
>  linux/include/linux/i2c-id.h                         |    1
>  18 files changed, 12598 insertions(+)
>
> <diff discarded since it is too big>
>
> ---
>
> Patch is available at:
> http://linuxtv.org/hg/v4l-dvb/rev/1d836224ecbf5ce6cf60696b4590630a92a4587
>5
>
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
