Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60591 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaFXPQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 11:16:07 -0400
Message-ID: <1403622960.2910.38.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 18/30] [media] coda: let userspace force IDR frames by
 enabling the keyframe flag in the source buffer
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Date: Tue, 24 Jun 2014 17:16:00 +0200
In-Reply-To: <539EA9C2.3010704@xs4all.nl>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
	 <1402675736-15379-19-git-send-email-p.zabel@pengutronix.de>
	 <539EA9C2.3010704@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 16.06.2014, 10:24 +0200 schrieb Hans Verkuil:
> On 06/13/2014 06:08 PM, Philipp Zabel wrote:
> > This disables forcing IDR frames at GOP size intervals on CODA7541 and CODA960,
> > which is only needed to work around a firmware bug on CodaDx6.
> > Instead, the V4L2_BUF_FLAG_KEYFRAME v4l2 buffer flag is cleared before marking
> > the source buffer done for dequeueing. Userspace can set it before queueing a
> > frame to force an IDR frame, to implement VFU (Video Fast Update).
> 
> I'd like to see an RFC for this feature. Rather than 'misuse' it, I think this
> should be standardized. I have nothing against using KEYFRAME in order to
> implement VFU (in fact, I like it!), but it should be documented and well-defined.

Thanks, I'll prepare a separate RFC for this.
The other possibility would be to use a V4L2_ENC_CMD for this feature.

One thing I'm not sure about is how to signal to userspace that this
feature is available when using the KEYFRAME clearing. With encoder
commands, TRY_COMMAND could be used. But when using the buffer KEYFRAME
bits, I suppose a flag would have to be introduced somewhere?

regards
Philipp

