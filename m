Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42545 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab0GGOA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 10:00:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 2/6] v4l: subdev: Add device node support
Date: Wed, 7 Jul 2010 16:00:56 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com> <d27c4d2b115f01c7cd17714ee14576ad.squirrel@webmail.xs4all.nl>
In-Reply-To: <d27c4d2b115f01c7cd17714ee14576ad.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007071600.57080.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 07 July 2010 14:43:08 Hans Verkuil wrote:
> > Create a device node named subdevX for every registered subdev.
> > 
> > As the device node is registered before the subdev core::s_config
> > function is called, return -EGAIN on open until initialization
> > completes.

[snip]

> I'm missing one thing here: in this code the subdev device node is always
> registered. But for most subdev drivers there is no need for a device
> node. This should really be explicitly turned on by the subdev driver
> itself.

I'll fix that with a subdev flag.

-- 
Regards,

Laurent Pinchart
