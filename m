Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2706 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab0GXMDA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jul 2010 08:03:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v2 02/10] media: Media device
Date: Sat, 24 Jul 2010 14:02:50 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007241402.50974.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 July 2010 16:35:27 Laurent Pinchart wrote:
> The media_device structure abstracts functions common to all kind of
> media devices (v4l2, dvb, alsa, ...). It manages media entities and
> offers a userspace API to discover and configure the media device
> internal topology.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/media-framework.txt |   68 ++++++++++++++++++++++++++++++++
>  drivers/media/Makefile            |    2 +-
>  drivers/media/media-device.c      |   77 +++++++++++++++++++++++++++++++++++++
>  include/media/media-device.h      |   53 +++++++++++++++++++++++++
>  4 files changed, 199 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/media-framework.txt
>  create mode 100644 drivers/media/media-device.c
>  create mode 100644 include/media/media-device.h
> 

<snip>

As discussed on IRC: I would merge media-device and media-devnode. I see no
benefit in separating them at this time.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
