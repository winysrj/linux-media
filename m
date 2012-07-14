Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41879 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2GNOK6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jul 2012 10:10:58 -0400
MIME-Version: 1.0
Date: Sat, 14 Jul 2012 16:10:56 +0200
Message-ID: <CANq1E4SbippxHHTaqLhpGjJLG12y94kWUFdB7P_EAG14o50vrQ@mail.gmail.com>
Subject: dma-buf/fbdev: one-to-many support
From: David Herrmann <dh.herrmann@googlemail.com>
To: dri-devel@lists.freedesktop.org
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I am currently working on fblog [1] (a replacement for fbcon without
VT dependencies) but this questions does also apply to other fbdev
users. Is there a way to share framebuffers between fbdev devices? I
was thinking especially of USB devices like DisplayLink. If they share
the same screen dimensions it would increase performance a lot if I
could display a single buffer on all the devices instead of copying it
into each framebuffer.

I was told to have a look at the dma-buf framework to implement this.
However, looking at the fbdev dma-buf support I think that this isn't
currently possible. Each fbdev device takes the exporter-role and
provides a single dma-buf object. However, if I wanted to share the
buffers, I would need to be the exporter. Or there needs to be a way
for the fbdev devices to import a dma-buf from other fbdev devices.

I also took a short look at DRM prime support and noticed that it is
capable of importing buffers (or at least it looks like it is).
Therefore,  I was wondering whether it does make sense to add an
"import dma-buf" callback to fbdev devices and if the fbdev driver
supports this, I can simply draw to a single dma-buf from one fbdev
device and push it to all other fbdev devices that share the same
dimensions.
It would also be nice to allow multiple buffer-owners or a way to
transfer ownership. That is, if the owner/exporter of the dma-buf
vanishes, I would pass it to another fbdev device which would pick it
up so I don't have to create a new one.

I think this is only interesting for DisplayLink-devices as they are
currently the only way to get a bunch of displays connected to a
single machine. Anyway, if you think that this isn't worth it, I will
probably drop this idea.

Regards
David

[1] fblog kernel driver: http://lwn.net/Articles/505965/
