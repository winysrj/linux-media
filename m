Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:39777 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754261AbdBGQIz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 11:08:55 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 0/4] media-ctl: frame interval propagation and colorimetry
Date: Tue,  7 Feb 2017 17:08:46 +0100
Message-Id: <20170207160850.10299-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

while testing the i.MX6 CSI drivers I noticed that media-ctl currently does not
propagate frame intervals between source and sink pads of connected entities
like it does pad formats. It doesn't even support setting the frame interval
of pads with an index other than 0.
The first three patches fix that and also print the frame interval if set.
The final patch adds colorimetry support to the pad formats.

regards
Philipp

Philipp Zabel (4):
  media-ctl: add pad support to set/get_frame_interval
  media-ctl: print the configured frame interval
  media-ctl: propagate frame interval
  media-ctl: add colorimetry support

 utils/media-ctl/libv4l2subdev.c | 295 ++++++++++++++++++++++++++++++++++++++--
 utils/media-ctl/media-ctl.c     |  25 ++++
 utils/media-ctl/options.c       |  22 ++-
 utils/media-ctl/v4l2subdev.h    |  84 +++++++++++-
 4 files changed, 411 insertions(+), 15 deletions(-)

-- 
2.11.0

