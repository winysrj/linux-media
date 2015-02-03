Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55691 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbbBCLUF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 06:20:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Subject: Re: [RFC PATCH 2/2] [media] videobuf2: return -EPIPE from DQBUF after the last buffer
Date: Tue, 03 Feb 2015 13:20:49 +0200
Message-ID: <4994964.UYaXg1ctzs@avalon>
In-Reply-To: <54CF8313.5020207@xs4all.nl>
References: <1421926118-29535-1-git-send-email-p.zabel@pengutronix.de> <1421926118-29535-3-git-send-email-p.zabel@pengutronix.de> <54CF8313.5020207@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 02 February 2015 15:00:51 Hans Verkuil wrote:
> On 01/22/2015 12:28 PM, Philipp Zabel wrote:
> > If the last buffer was dequeued from a capture queue, let poll return
> > immediately and let DQBUF return -EPIPE to signal there will no more
> > buffers to dequeue until STREAMOFF.
> 
> This looks OK to me, although I would like to see comments from others as
> well. Of course, this needs to be documented in the spec as well.

I haven't followed the V4L2 codec API discussion during ELC-E. Could someone 
briefly expose the rationale for this and the codec draining flow ? The 
explanation should probably included in the documentation.

Existing applications will receive -EPIPE from DQBUF now. Have potential 
breakages been taken into account ?

> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > TODO: (How) should the last_buffer_dequeud flag be cleared in reaction to
> > V4L2_DEC_CMD_START?
> 
> I would suggest an inline function in videobuf2-core.h that clears the flag
> and that drivers can call. I don't think the vb2 core can detect when it is
> OK to clear the flag, it needs to be told by the driver (correct me if I am
> wrong).

-- 
Regards,

Laurent Pinchart

