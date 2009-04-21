Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41056 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755511AbZDUKa5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 06:30:57 -0400
Date: Tue, 21 Apr 2009 12:31:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-subdev: add a v4l2_i2c_new_dev_subdev() function
In-Reply-To: <6049.62.70.2.252.1240309148.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0904211229390.6551@axis700.grange>
References: <6049.62.70.2.252.1240309148.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 21 Apr 2009, Hans Verkuil wrote:

> The board_info struct didn't appear until 2.6.22, so that's certainly a
> cut-off point. Since the probe version of this call does not work on
> kernels < 2.6.26 the autoprobing mechanism is still used for those older
> kernels. I think it makes life much easier to require that everything that
> uses board_info needs kernel 2.6.26 at the minimum. I don't think that is
> an issue anyway for soc-camera. Unless there is a need to use soc-camera
> from v4l-dvb with kernels <2.6.26?

No, most definitely ultimately undoubtedly NOT.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
