Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3115 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3LQHh3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 02:37:29 -0500
Message-ID: <52AFFF1B.4070809@xs4all.nl>
Date: Tue, 17 Dec 2013 08:36:59 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v3 0/7] SDR API
References: <1387231688-8647-1-git-send-email-crope@iki.fi>
In-Reply-To: <1387231688-8647-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2013 11:08 PM, Antti Palosaari wrote:
> Now with some changes done requested by Hans.
> I did not agree	very well that VIDIOC_G_FREQUENCY tuner type check
> exception, but here it is...
> 
> Also two patches, as example, conversion of msi3101 and rtl2832_sdr
> drivers to that API.
> 
> regards
> Antti
> 
> Antti Palosaari (7):
>   v4l: add new tuner types for SDR
>   v4l: 1 Hz resolution flag for tuners
>   v4l: add stream format for SDR receiver
>   v4l: define own IOCTL ops for SDR FMT
>   v4l: enable some IOCTLs for SDR receiver

Is it just too early in the day or is the patch adding VFL_TYPE_SDR and
the swradio device missing in this patch series?

Regards,

	Hans

>   rtl2832_sdr: convert to SDR API
>   msi3101: convert to SDR API
> 
>  drivers/media/v4l2-core/v4l2-dev.c               |  27 ++-
>  drivers/media/v4l2-core/v4l2-ioctl.c             |  75 +++++-
>  drivers/staging/media/msi3101/sdr-msi3101.c      | 204 +++++++++++-----
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 291 ++++++++++++++++++-----
>  include/media/v4l2-ioctl.h                       |   8 +
>  include/trace/events/v4l2.h                      |   1 +
>  include/uapi/linux/videodev2.h                   |  14 ++
>  7 files changed, 486 insertions(+), 134 deletions(-)
> 

