Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4746 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3CBXpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: [RFC PATCH 00/20] solo6x10: V4L2 compliancy fixes and major overhaul
Date: Sun,  3 Mar 2013 00:45:16 +0100
Message-Id: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series updates the solo6x10 staging driver to a usable state.

It has been tested with my Bluecherry BC-04120A MPEG4 4 port video encoder/decoder
card, generously provided by Bluecherry about two years ago.

Most of these fixes are the usual fall-out from testing with v4l2-compliance,
but due to the many locking errors in this driver I decided to also convert
it to vb2. It was frankly easier then trying to fix the locking madness
caused by the interaction between threads and videobuf.

Currently this driver seems to be quite reliable (I haven't done any long-term
tests though), but there are a few TODO items:

1) Most importantly, the video from video0 is broken: it is supposed to be
   either one of the four inputs or a 2x2 image of all four inputs, instead I
   always get the first video line of the input repeated for the whole image.

   I have no idea why and it would be very nice if someone from Bluecherry
   can look at this. I do not see anything wrong in the DMA code, so it is
   a mystery to me. I'm beginning to wonder if you are actually supposed to
   be able to DMA from video0!

2) I couldn't get it to work on a big-endian system. I keep getting
   SOLO_PCI_ERR_P2M_DESC errors, but I see nothing wrong with the DMA
   descriptor. Perhaps if someone with a solo datasheet can tell me the
   possible causes of that error interrupt I might be able to figure it
   out. It's just the DMA setup that does something wrong, the rest seems
   fine.

3) What is the meaning of this snippet of code in v4l2-enc.c?

	if (pix->priv)
		solo_enc->type = SOLO_ENC_TYPE_EXT;

   I've commented it out since it is completely undocumented and no driver
   should assume that priv is non-zero anymore, precisely because of issues
   like this. Ismael, do you know what the difference is between SOLO_ENC_TYPE_STD
   and SOLO_ENC_TYPE_EXT?

4) Most of the sources and headers need to be renamed with a solo6x10- prefix.
   The current names are too general.

5) There is a custom extension for motion detection. I left that part unchanged
   as it doesn't look too bad, but I am unable to test it properly. I've
   ordered a suitable CCTV camera from dealextreme, but that will take a few
   weeks before I have it (dx.com is cheap, but delivery is quite slow). I'd
   like to experiment a bit with this.

6) The tw28* 'drivers' should really be split off as subdevice drivers, but
   unfortunately I don't have a datasheet for the tw2815 (I found one for the
   tw2864 though). If I ever get hold of a datasheet, then creating subdev
   drivers for this would be nice.

7) The kernel threads really should be replaced by workqueues.

All in all this driver is now almost ready to go into the mainline part of
the kernel. Before that's done I'd like to get items 1, 3 and 5 resolved
first. Ismael, it would be great if you could help me out with 1 and 3!

Regards,

	Hans

