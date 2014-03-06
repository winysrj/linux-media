Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2355 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaCFKCE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 05:02:04 -0500
Message-ID: <53184773.8090006@xs4all.nl>
Date: Thu, 06 Mar 2014 11:01:23 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [PATCH/RFC v2 0/5] media-ctl API changes to prepare for device
 enumeration library
References: <1394040741-22503-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394040741-22503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/05/14 18:32, Laurent Pinchart wrote:
> Hello,
> 
> Here's the second version of the patch set that make libmediactl usable by the
> upcoming media device enumeration library. In order to do so I need to change
> the libmediactl API and add support for emulated media devices.
> 
> In order to avoid further API/ABI breakages I've decided to make the
> media_device and media_entity structures private and provide accessors for the
> fields that need to be read. I'm open to suggestions on whether I should make
> the media_pad and media_link structures private now as well, or on any other
> aspect of these changes.
> 
> For reference the (work in progress) media device enumeration library is
> available at
> 
> 	http://git.ideasonboard.org/media-enum.git
> 
> Changes since v1:
> 
> - Made struct media_entity private

For this patch series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> 
> Laurent Pinchart (5):
>   Split media_device creation and opening
>   Make the media_device structure private
>   Make the media_entity structure private
>   Expose default devices
>   Add support for emulated devices
> 
>  src/main.c          | 137 +++++++++++++---------
>  src/mediactl-priv.h |  64 ++++++++++
>  src/mediactl.c      | 330 +++++++++++++++++++++++++++++++++++++++++++++-------
>  src/mediactl.h      | 281 ++++++++++++++++++++++++++++++++++----------
>  src/v4l2subdev.c    |   1 +
>  5 files changed, 652 insertions(+), 161 deletions(-)
>  create mode 100644 src/mediactl-priv.h
> 

