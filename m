Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41902 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721Ab1J1Mlj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Oct 2011 08:41:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gilles Gigan <gilles.gigan@gmail.com>
Subject: Re: Switching input during capture
Date: Fri, 28 Oct 2011 14:42:21 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CAJWu0HN8WC-xfAy3cNnA_o3YPj7+9Eo5+YCvNtqRNs9dG18+8A@mail.gmail.com>
In-Reply-To: <CAJWu0HN8WC-xfAy3cNnA_o3YPj7+9Eo5+YCvNtqRNs9dG18+8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110281442.21776.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gilles,

On Friday 28 October 2011 03:31:53 Gilles Gigan wrote:
> Hi,
> I would like to know what is the correct way to switch the current
> video input during capture on a card with a single BT878 chip and 4
> inputs
> (http://store.bluecherry.net/products/PV%252d143-%252d-4-port-video-captur
> e-card-%2830FPS%29-%252d-OEM.html). I tried doing it in two ways:
> - using VIDIOC_S_INPUT to change the current input. While this works,
> the next captured frame shows video from the old input in its top half
> and video from the new input in the bottom half.
> - I tried setting the input field to the new input and flags to
> V4L2_BUF_FLAG_INPUT in the struct v4l2_buffer passed to VIDIOC_QBUF
> when enqueuing buffers. However, when doing so, the ioctl fails
> altogether, and I cannot enqueue any buffers with the
> V4L2_BUF_FLAG_INPUT flag set.

V4L2_BUF_FLAG_INPUT is (or at least should be) deprecated. It isn't supported 
by mainline drivers and was a mistake in the first place.

> Is there another way of doing it ? or is there a way to synchronise
> the input change (when using VIDIOC_S_INPUT) so it happens in between
> 2 frames and produces a clean switch ?

You will need hardware support for that.

-- 
Regards,

Laurent Pinchart
