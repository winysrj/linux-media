Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44232 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab0FHBET (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 21:04:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux newbie <linux.newbie79@gmail.com>
Subject: Re: cam max width and height
Date: Tue, 8 Jun 2010 03:07:01 +0200
Cc: "Linux-media" <linux-media@vger.kernel.org>,
	linux-uvc-devel@lists.berlios.de
References: <AANLkTimh-FVg9yspF6ASGrlY5kd5Puppa7VlKA6NljQ5@mail.gmail.com>
In-Reply-To: <AANLkTimh-FVg9yspF6ASGrlY5kd5Puppa7VlKA6NljQ5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006080307.02170.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday 08 June 2010 02:09:39 linux newbie wrote:
> Hi,
> 
> I am using linux 2.6.26.3. I connected "microsoft live cam" and its
> max supported resolution is 1280x800. If I use VIDIOC_G_FMT,
> fmt.fmt.pix.width, fmt.fmt.pix.height returns 640x480.
> 
> How to get the maximum supported resolution??

You can use VIDIOC_ENUM_FRAMESIZES to enumeration all the supported 
resolutions.

-- 
Regards,

Laurent Pinchart
