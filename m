Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45053 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115AbbGMLKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 07:10:07 -0400
Message-ID: <55A39C57.9060008@xs4all.nl>
Date: Mon, 13 Jul 2015 13:09:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: matrandg@cisco.com, linux-media@vger.kernel.org
CC: hansverk@cisco.com, p.zabel@pengutronix.de, kernel@pengutronix.de
Subject: Re: [RFC v04] Driver for Toshiba TC358743
References: <1436431547-27319-1-git-send-email-matrandg@cisco.com>
In-Reply-To: <1436431547-27319-1-git-send-email-matrandg@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mats, Philipp,

I'll merge this driver, but not yet the follow-ups from Philipp since those
need some more work.

Regards,

	Hans

On 07/09/2015 10:45 AM, matrandg@cisco.com wrote:
> From: Mats Randgaard <matrandg@cisco.com>
> 
> Improvements based on feedback from Hans Verkuil:
> - Use functions in linux/hdmi.h to print AVI info frames
> - Replace private format change event with V4L2_EVENT_SOURCE_CHANGE
> - Rewrite set_fmt/get_fmt
> - Remove V4L2_SUBDEV_FL_HAS_DEVNODE
> 
> Other improvements since the previous version:
> - Protect CONFCTL with a mutex since it is written in both process
>   context and interrupt context
> - Restructure and describe the platform data
> - Replace the register that is verified in the probe function with the
>   read-only register CHIPID
> 
> Mats Randgaard (1):
>   Driver for Toshiba TC358743 HDMI to CSI-2 bridge
> 
>  MAINTAINERS                        |    7 +
>  drivers/media/i2c/Kconfig          |    9 +
>  drivers/media/i2c/Makefile         |    1 +
>  drivers/media/i2c/tc358743.c       | 1778 ++++++++++++++++++++++++++++++++++++
>  drivers/media/i2c/tc358743_regs.h  |  681 ++++++++++++++
>  include/media/tc358743.h           |  131 +++
>  include/uapi/linux/v4l2-controls.h |    4 +
>  7 files changed, 2611 insertions(+)
>  create mode 100644 drivers/media/i2c/tc358743.c
>  create mode 100644 drivers/media/i2c/tc358743_regs.h
>  create mode 100644 include/media/tc358743.h
> 

