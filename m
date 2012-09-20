Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1322 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2ITMHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv2 PATCH 00/14] davinci: clean up input/output/subdev config
Date: Thu, 20 Sep 2012 14:06:19 +0200
Message-Id: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

This is the second patch series for a vpif driver cleanup.

The first version can be found here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg52136.html

Changes since RFCv1:

- rebased to a newer git repo:
  http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git/shortlog/refs/heads/da850_vpif_machine

- fixed probe() cleanup code in both display and capture that was seriously
  broken.

- fixed a broken s_routing implementation in the tvp514x driver: if there
  is no incoming video signal, then s_routing would return EINVAL and
  leave the driver with an inconsistent internal state. This has always
  been a problem, but with this patch series it suddenly became really
  noticable. s_routing shouldn't try to wait for a valid signal, that's
  not what s_routing should do.

This patch series does some driver cleanup and reorganizes the config
structs that are used to set up subdevices.

The current driver associates an input or output with a subdev, but multiple
inputs may use the same subdev and some inputs may not use a subdev at all
(this is the case for our hardware).

Several other things were also configured in the wrong structure. For
example the vpif_interface struct is really part of the channel config
and has nothing to do with the subdev.

What is missing here is that the output doesn't have the same flexibility
as the input when it comes to configuration. It would be good if someone
can pick this up as a follow-up since it's unlikely I'll be working on
that.

What would also be nice is that by leaving the inputs or outputs for the
second channel empty (NULL) in the configuration you can disable the second
video node, e.g. trying to use it will always result in ENODEV or something.

This patch series will at least make things more flexible.

Regards,

        Hans

