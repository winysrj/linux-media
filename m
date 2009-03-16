Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbZCPKiN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 06:38:13 -0400
Date: Mon, 16 Mar 2009 07:37:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
Message-ID: <20090316073742.0affb09a@gaivota.chehab.org>
In-Reply-To: <200903151324.00784.hverkuil@xs4all.nl>
References: <200903151324.00784.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009 13:24:00 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Mauro,
> 
> Can you review my ~hverkuil/v4l-dvb-bttv2 tree?
> 
> It converts this driver to v4l2_subdev, and as far as I can see it works and 
> should probe all the different audio devices in the correct and safe order.
> 
> I kept things as simple as possible in order to make a review easy.

Could you please break this changeset even more:
	http://linuxtv.org/hg/~hverkuil/v4l-dvb-bttv2/rev/583981be1a4d

The reason is that it not just add support to tda9875, but also changes the
behaviour of mute and input selection. Had you find a bug with the old way?

> 
> There is only one possible i2c conflict left between tvaudio and ir-kbd-i2c, 
> but I'll discuss that separately since we need input from Jean Delvare as 
> well on that.
> 
> Regards,
> 
> 	Hans
> 




Cheers,
Mauro
