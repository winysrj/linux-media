Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53965 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbbERT1E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 15:27:04 -0400
Date: Mon, 18 May 2015 16:26:57 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH 0/4] Add support for V4L2_PIX_FMT_Y16_BE
Message-ID: <20150518162657.031a86fc@recife.lan>
In-Reply-To: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  4 May 2015 10:07:28 +0200
Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> escreveu:

> New pixel format type Y16_BE (16 bits greyscale big-endian).
> 
> Once I get the fist feedback on this patch I will send the patches for
> v4lconvert and qv4l2.

Hmm...

	Error: no ID for constraint linkend: V4L2-PIX-FMT-Y16-BE.

Where's the documentation for this new format?

Regards,
Mauro


> 
> 
> Thanks
> 
> Ricardo Ribalda Delgado (4):
>   media/vivid: Add support for Y16 format
>   media/v4l2-core: Add support for V4L2_PIX_FMT_Y16_BE
>   media/vivid: Add support for Y16_BE format
>   media/vivid: Code cleanout
> 
>  drivers/media/platform/vivid/vivid-tpg.c        | 20 ++++++++++++++++----
>  drivers/media/platform/vivid/vivid-vid-common.c | 16 ++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c            |  1 +
>  include/uapi/linux/videodev2.h                  |  1 +
>  4 files changed, 34 insertions(+), 4 deletions(-)
> 
