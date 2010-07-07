Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:39335 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0GGMfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 08:35:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 4/6] v4l: subdev: Control ioctls support
Date: Wed, 7 Jul 2010 14:35:34 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278503608-9126-5-git-send-email-laurent.pinchart@ideasonboard.com> <97beeba6e8a645b4d57e16ffa36f2321.squirrel@webmail.xs4all.nl>
In-Reply-To: <97beeba6e8a645b4d57e16ffa36f2321.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007071435.35635.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the quick review.

On Wednesday 07 July 2010 14:33:52 Hans Verkuil wrote:
> > Pass the control-related ioctls to the subdev driver through the core
> > operations.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[snip]

> This should simplify substantially once the control framework is in place.

Definitely.

> IMHO the control framework should go in first, then this code, updated for
> the control framework.

I'm fine with either way.

-- 
Regards,

Laurent Pinchart
