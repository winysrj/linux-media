Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36651 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbbBBPXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 10:23:50 -0500
Message-ID: <1422890625.6112.12.camel@pengutronix.de>
Subject: Re: [RFC PATCH 2/2] [media] videobuf2: return -EPIPE from DQBUF
 after the last buffer
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Kamil Debski <k.debski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>
Date: Mon, 02 Feb 2015 16:23:45 +0100
In-Reply-To: <54CF8313.5020207@xs4all.nl>
References: <1421926118-29535-1-git-send-email-p.zabel@pengutronix.de>
	 <1421926118-29535-3-git-send-email-p.zabel@pengutronix.de>
	 <54CF8313.5020207@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 02.02.2015, 15:00 +0100 schrieb Hans Verkuil:
> On 01/22/2015 12:28 PM, Philipp Zabel wrote:
> > If the last buffer was dequeued from a capture queue, let poll return
> > immediately and let DQBUF return -EPIPE to signal there will no more
> > buffers to dequeue until STREAMOFF.
> 
> This looks OK to me, although I would like to see comments from others as well.
> Of course, this needs to be documented in the spec as well.

Thanks, I'll fix that in the next round.

> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > TODO: (How) should the last_buffer_dequeud flag be cleared in reaction to
> > V4L2_DEC_CMD_START?
> 
> I would suggest an inline function in videobuf2-core.h that clears the flag
> and that drivers can call. I don't think the vb2 core can detect when it is
> OK to clear the flag, it needs to be told by the driver (correct me if I am
> wrong).

No, I think you are right that this should be done explicitly. I'll add
an inline function next time.

regards
Philipp

