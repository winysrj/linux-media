Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56857 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab2ICQQx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 12:16:53 -0400
Subject: Re: [PATCH v3 04/16] media: coda: allocate internal framebuffers
 separately from v4l2 buffers
From: Philipp Zabel <p.zabel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
In-Reply-To: <CACKLOr29xXXrcspbS-zG+_mrgBfNC23sGR+_r8owXuw+mnpofg@mail.gmail.com>
References: <1346400670-16002-1-git-send-email-p.zabel@pengutronix.de>
	 <1346400670-16002-5-git-send-email-p.zabel@pengutronix.de>
	 <CACKLOr29xXXrcspbS-zG+_mrgBfNC23sGR+_r8owXuw+mnpofg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Sep 2012 18:16:46 +0200
Message-ID: <1346689006.2391.28.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Am Montag, den 03.09.2012, 13:01 +0200 schrieb javier Martin:
> Hi Philipp,
> thank you for your effort.
> 
> My comment is aimed to the whole patch.
> 
> Couldn't we use a more descriptive name for these 'framebuffers'? Both
> the internal buffers and the output frames are framebuffers which
> leads to confusion.

They are frame buffers, though, for reconstructed and reference frames.

And whether output/source vb2_buffers or capture/destination vb2_buffers
contain raw frames will depend whether ctx->inst_type is
CODA_INST_ENCODER or CODA_INST_DECODER, so it's bound to be confusing
anyway.

> How about 'internalbuffers' or 'privatebuffers'? I know the name of
> some register, according to the datasheet, is
> 'CODA_CMD_SET_FRAME_BUF_NUM', but this is quite unfortunate IMHO and
> we shouldnt' stick to this naming.

Dropping the 'frame', one could argue, would lead to confusion with the
code/work/parabuffers. ctx->internal_frames[] ?

regards
Philipp


