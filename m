Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:48814 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbcGQJLu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 05:11:50 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C6942180C37
	for <linux-media@vger.kernel.org>; Sun, 17 Jul 2016 11:11:44 +0200 (CEST)
Subject: Re: [PATCH 0/5] dv-timings: add VICs and picture aspect ratio
To: linux-media@vger.kernel.org
References: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57c6f758-f25a-3533-2acb-60c16e6f5d0d@xs4all.nl>
Date: Sun, 17 Jul 2016 11:11:44 +0200
MIME-Version: 1.0
In-Reply-To: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2016 11:08 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The v4l2_bt_timings struct is missing information about the picture aspect
> ratio and the CEA-861 and HDMI VIC (Video Identification Code).
> 
> This patch series adds support for this.

Note: the documentation patch is missing. I'll wait until 4.8-rc1 is out to add
the docrst patch for this.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> Hans Verkuil (5):
>   videodev2.h: add VICs and picture aspect ratio
>   v4l2-dv-timings: add VICs and picture aspect ratio
>   v4l2-dv-timings: add helpers to find vic and pixelaspect ratio
>   cobalt: add cropcap support
>   adv7604: add vic detect
> 
>  drivers/media/i2c/adv7604.c               | 18 +++++-
>  drivers/media/pci/cobalt/cobalt-v4l2.c    | 21 +++++++
>  drivers/media/v4l2-core/Kconfig           |  1 +
>  drivers/media/v4l2-core/v4l2-dv-timings.c | 58 +++++++++++++++++-
>  include/media/v4l2-dv-timings.h           | 18 ++++++
>  include/uapi/linux/v4l2-dv-timings.h      | 97 ++++++++++++++++++++-----------
>  include/uapi/linux/videodev2.h            | 75 +++++++++++++++++-------
>  7 files changed, 229 insertions(+), 59 deletions(-)
> 
