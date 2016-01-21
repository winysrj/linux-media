Return-path: <linux-media-owner@vger.kernel.org>
Received: from c.ponzo.net ([69.12.221.20]:33321 "EHLO c.ponzo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbcAUW3H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 17:29:07 -0500
From: Scott Doty <scott@ponzo.net>
Subject: hdpvr stalls in two situations
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56A15BB2.1060006@ponzo.net>
Date: Thu, 21 Jan 2016 14:29:06 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been trying the hdpvr driver in newer kernels, and I've discovered
that vlc will stall after a random amount of playback.

To fix this, one has to power cycle the device.

Linux 4.1.15 doesn't have this behavior, though, so I've moved back to
that kernel for my own use.  It's puzzling to me, because the drivers
haven't changed from 4.1.15 to 4.4.  (Could this be some kind of
regression in the USB subsystem?)

The other situation where I see stalled video is changing channels on my
DirecTV satellite box, and doesn't seem dependent on kernel version. 
(In other words, it still happens with 4.1.15.)  I have the satellite
box connected to the component input on the hdpvr.  I'm also using SPDIF
for the hdpvr's input.  Apparently the channel-change discontinuity in
the video, or audio, confuses either the driver or vlc, which means I
have to exit vlc and restart to resume video playback after changing
channels.

I'd love to dive into this and make it work properly, or help make it
work.  Any idea where to start?

Thanks. :)

 -Scott

