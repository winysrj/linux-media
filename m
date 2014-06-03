Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3968 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaFCGwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 02:52:42 -0400
Message-ID: <538D70AD.8090800@xs4all.nl>
Date: Tue, 03 Jun 2014 08:52:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 0/2] v4l-utils: Add missing v4l2-mediabus.h header
References: <1401756292-27676-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401756292-27676-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2014 02:44 AM, Laurent Pinchart wrote:
> Hello,
> 
> This patch set adds the missing v4l2-mediabus.h header, required by media-ctl.
> Please see individual patches for details, they're pretty straightforward.

Nack.

The kernel headers used in v4l-utils are installed via 'make sync-with-kernel'.
So these headers shouldn't be edited, instead Makefile.am should be updated.
In particular, that's where the missing header should be added.

Regards,

	Hans

> Laurent Pinchart (2):
>   Use installed kernel headers instead of raw kernel headers
>   Add the missing v4l2-mediabus.h kernel header
> 
>  include/linux/dvb/dmx.h       |   8 +--
>  include/linux/dvb/frontend.h  |   4 --
>  include/linux/dvb/video.h     |  12 ++--
>  include/linux/fb.h            |   8 +--
>  include/linux/ivtv.h          |   6 +-
>  include/linux/v4l2-mediabus.h | 147 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/videodev2.h     |  16 ++---
>  7 files changed, 168 insertions(+), 33 deletions(-)
>  create mode 100644 include/linux/v4l2-mediabus.h
> 

