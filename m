Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4323 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAYInY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 03:43:24 -0500
Message-ID: <52E3791E.7080807@xs4all.nl>
Date: Sat, 25 Jan 2014 09:43:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [PATCH/RFC 0/4] media-ctl API changes to prepare for device enumeration
 library
References: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent!

On 01/24/2014 02:08 PM, Laurent Pinchart wrote:
> Hello,
> 
> I've postponed merging media-ctl to v4l-utils for too long due to pending
> patches that I haven't had time to complete yet. It's time to fix this, so
> here are the patches for review.
> 
> The goal of this patch set is to make libmediactl usable by the upcoming media
> device enumeration library. In order to do so I need to change the libmediactl
> API and add support for emulated media devices.
> 
> In order to avoid further API/ABI breakages I've decided to make the
> media_device structure private and provide accessors for the fields that need
> to be read. I'm open to suggestions on whether I should make the media_pad,
> media_link and media_entity structures private now as well.

I would make media_entity private as well. The pad and link structs are very simple
and they model very basic concepts, so I don't think these are likely to cause
problems in the future, but the entity is more complex and more likely to be
expanded in ways that we cannot predict.

Regards,

	Hans

> 
> For reference the (work in progress) media device enumeration library is
> available at
> 
> 	http://git.ideasonboard.org/media-enum.git
> 
> Laurent Pinchart (4):
>   Split media_device creation and opening
>   Make the media_device structure private
>   Expose default devices
>   Add support for emulated devices
> 
>  src/main.c          |  53 ++++++----
>  src/mediactl-priv.h |  52 +++++++++
>  src/mediactl.c      | 296 ++++++++++++++++++++++++++++++++++++++++++++--------
>  src/mediactl.h      | 209 ++++++++++++++++++++++++++++---------
>  src/v4l2subdev.c    |   1 +
>  5 files changed, 497 insertions(+), 114 deletions(-)
>  create mode 100644 src/mediactl-priv.h
> 
