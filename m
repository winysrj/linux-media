Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4562 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3CRMc1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: [REVIEW PATCH 00/19] solo6x10: driver overhaul
Date: Mon, 18 Mar 2013 13:31:59 +0100
Message-Id: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is my second attempt. This time I sync to the latest code from Bluecherry
first before applying my patches.

Remaining open issues:

1) Most importantly, the video from video0 is broken: it is supposed to be
   either one of the four inputs or a 2x2 image of all four inputs, instead I
   always get the first video line of the input repeated for the whole image.

   I have no idea why and it would be very nice if someone from Bluecherry
   can look at this. I do not see anything wrong in the DMA code, so it is
   a mystery to me.

2) I couldn't get it to work on a big-endian system. Perhaps it is because
   the PCI card is sitting in a PCIe slot using a PCIe-to-PCI adapter.

3) The 'extended streams' have been disabled. Basically you can get two
   encoded streams out of the box: each with different encoder settings
   (e.g. high and low bitrates). This should probably be implemented as
   an extra video node.

4) There is a custom extension for motion detection. Besides adding two
   private ioctls to support regional motion thresholds I left that part
   otherwise unchanged as it doesn't look too bad, but I am unable to test
   it properly. I've ordered a suitable CCTV camera from dealextreme, but that
   will take a few weeks before I have it (dx.com is cheap, but delivery is
   quite slow). I'd like to experiment a bit with this.

5) The tw28* 'drivers' should really be split off as subdevice drivers.

6) Capture of video0 is now using dma-contig. It used to be dma-sg, but due
   to locking issues Bluecherry changed it to dma-contig. So I've kept it
   that way, but it can probably be converted back to dma-sg. But issue 1 should
   be fixed first before we mess with this.

So there is still work to be done, but at least the driver is in a much better
state.

If there are no more comments, then I'll add a final patch that prefixes the
sources with 'solo6x10-' and post a pull request on Friday.

The idea is that Bluecherry will develop from this code base and keep the
kernel driver in sync.

Regards,

	Hans


