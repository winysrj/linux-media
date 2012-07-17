Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60240 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab2GQKjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 06:39:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: dri-devel@lists.freedesktop.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: dma-buf/fbdev: one-to-many support
Date: Tue, 17 Jul 2012 12:39:43 +0200
Message-ID: <1497600.3Qx4Vx9if4@avalon>
In-Reply-To: <CANq1E4SbippxHHTaqLhpGjJLG12y94kWUFdB7P_EAG14o50vrQ@mail.gmail.com>
References: <CANq1E4SbippxHHTaqLhpGjJLG12y94kWUFdB7P_EAG14o50vrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

On Saturday 14 July 2012 16:10:56 David Herrmann wrote:
> Hi
> 
> I am currently working on fblog [1] (a replacement for fbcon without
> VT dependencies) but this questions does also apply to other fbdev
> users. Is there a way to share framebuffers between fbdev devices? I
> was thinking especially of USB devices like DisplayLink. If they share
> the same screen dimensions it would increase performance a lot if I
> could display a single buffer on all the devices instead of copying it
> into each framebuffer.
> 
> I was told to have a look at the dma-buf framework to implement this.
> However, looking at the fbdev dma-buf support I think that this isn't
> currently possible. Each fbdev device takes the exporter-role and
> provides a single dma-buf object. However, if I wanted to share the
> buffers, I would need to be the exporter. Or there needs to be a way
> for the fbdev devices to import a dma-buf from other fbdev devices.
> 
> I also took a short look at DRM prime support and noticed that it is
> capable of importing buffers (or at least it looks like it is).
> Therefore,  I was wondering whether it does make sense to add an
> "import dma-buf" callback to fbdev devices and if the fbdev driver
> supports this, I can simply draw to a single dma-buf from one fbdev
> device and push it to all other fbdev devices that share the same
> dimensions.

The main issue is that fbdev has been designed with the implicit assumption 
that an fbdev driver will always own the graphics memory it uses. All 
components in the stack, from drivers to applications, have been designed 
around that assumption.

We could of course fix this, revamp the fbdev API and turn it into a modern 
graphics API, but I really wonder whether it would be worth it. DRM has been 
getting quite a lot of attention lately, especially from embedded developers 
and vendors, and the trend seems to me like the (Linux) world will gradually 
move from fbdev to DRM.

Please feel free to disagree :-)

> It would also be nice to allow multiple buffer-owners or a way to
> transfer ownership. That is, if the owner/exporter of the dma-buf
> vanishes, I would pass it to another fbdev device which would pick it
> up so I don't have to create a new one.
> 
> I think this is only interesting for DisplayLink-devices as they are
> currently the only way to get a bunch of displays connected to a
> single machine. Anyway, if you think that this isn't worth it, I will
> probably drop this idea.
> 
> Regards
> David
> 
> [1] fblog kernel driver: http://lwn.net/Articles/505965/

-- 
Regards,

Laurent Pinchart

