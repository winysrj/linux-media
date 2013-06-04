Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:40719 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab3FDQFS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 12:05:18 -0400
Date: Tue, 4 Jun 2013 10:05:16 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv1 29/38] marvell-ccic: check register address.
Message-ID: <20130604100516.076436d4@lwn.net>
In-Reply-To: <1369825211-29770-30-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
	<1369825211-29770-30-git-send-email-hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 29 May 2013 13:00:02 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Prevent out-of-range register accesses.

Certainly I agree with the goal, and what's here is better than what the
driver does now.  But...

> +	if (reg->reg > cam->regs_size - 4)
> +		return -EINVAL;

The alleged size of the MMIO region is likely to be quite a bit larger than
the offset of the last real register, and I wouldn't count on the hardware
to not lock up if you try to access something beyond that last register.
So I'd much rather add a MAX_MCAM_REG_OFFSET define to mcam-core.h after
the last register define and test against that.  I can try to toss
something together shortly.

Thanks,

jon
