Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4583 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3BPJ2p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:28:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [RFC PATCH 00/18] Remove DV_PRESET API
Date: Sat, 16 Feb 2013 10:28:03 +0100
Message-Id: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

This patch series removes the last remnants of the deprecated DV_PRESET API
from the kernel:

- remove the dv_preset ops from the tvp7002 driver: all bridge drivers that
  use this i2c driver have already been converted to the DV_TIMINGS API, so
  these ops are no longer used. Prabhakar, can you test this for me?

- fix some remaining references to the preset API from the davinci drivers.
  It's trivial stuff, but I would appreciate it if you can look at it, 
  Prabhakar.

- rename some CUSTOM_TIMINGS defines to DV_TIMINGS since CUSTOM_TIMINGS
  is deprecated. It certainly shouldn't be used anymore in the kernel.
  Trivial patches, but please look at it as well, Prabhakar and Scott.

- convert the s5p-tv drivers from the DV_PRESET to the DV_TIMINGS API and
  remove the DV_PRESET API. Tomasz or Kyungmin Park, can you test this?
  I do not know whether removal of the DV_PRESET API is possible at this
  stage for the s5p-tv since I do not know if any code inside Samsung
  uses the DV_PRESET API. If the DV_PRESET API cannot be removed at this
  time, then let me know. I would have to make some changes to allow the
  preset and timings APIs to co-exist. I would really like to remove the
  preset API some time this year, though, if only to prevent new drivers 
  from attempting to use the preset API.

- finally remove the remaining core DV_PRESET support.

- remove the DV_PRESET API from the videodev2.h header. Note that I am not
  at all certain if we should do this. I know that the DV_PRESET API has
  only been used in embedded systems, so the impact should be very limited.
  But it is probably better to wait for a year or so before actually 
  removing it from the header. The main reason for adding this removal is
  to verify that I haven't forgotten any driver conversions.

Comments are welcome!

Regards,

	Hans

