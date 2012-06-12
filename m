Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3515 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2FLHG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 03:06:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: extend v4l2_mbus_framefmt
Date: Tue, 12 Jun 2012 09:05:55 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org
References: <CAHG8p1AW6577=oGPo3o8S0LgF2p8_cfmLLnvYbikk7kEaYdxzw@mail.gmail.com> <201206111033.47369.hverkuil@xs4all.nl> <CAHG8p1CeMi16-YQMObuiwcmyf4cqVZwqppHyjuJX5ghipScVoA@mail.gmail.com>
In-Reply-To: <CAHG8p1CeMi16-YQMObuiwcmyf4cqVZwqppHyjuJX5ghipScVoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206120905.55735.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue June 12 2012 07:42:47 Scott Jiang wrote:
> Hi Hans,
> 
> > I would expect that the combination of v4l2_mbus_framefmt + v4l2_dv_timings
> > gives you the information you need.
> 
> About v4l2_mbus_framefmt, you use V4L2_MBUS_FMT_FIXED. I guess you
> can't find any yuv 24 or rgb 16/24bit format in current
> v4l2_mbus_framefmt.

It's more that Cisco didn't need this since we never change the pixelport
configuration after initialization. So this code should be improved.

BTW, I plan to update my http://git.linuxtv.org/hverkuil/cisco.git repository
today or tomorrow with our latest code that is much closer to being ready for
upstreaming.

> But a bridge driver working with variable sensors
> and decoders can't accept this.

Of course. Patches are welcome :-)

> About  v4l2_dv_timings, do I need to set a default timing similar to
> pick PAL as default standard?

Yes. Ensuring that you always have some default timing makes life a lot
easier all around, both in kernelspace and in userspace.

Otherwise you would have to check whether you actually have a timings setup
all the time.

Regards,

	Hans
