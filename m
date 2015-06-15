Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33775 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbbFOLd7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:33:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk
Subject: [PATCH 00/14] Various soc_camera related fixes
Date: Mon, 15 Jun 2015 13:33:27 +0200
Message-Id: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

I had a pile of straightforward fixes pending in one of my git branches
that were all related to soc_camera in some way. Some were part of William's
r-car patch series, but this collects them all in one place.

These fixes are all due to v4l2-compliance failures or warnings (well, except
of the DocBook patch at the end of course).

Regards,

	Hans

Hans Verkuil (14):
  sh-veu: initialize timestamp_flags and copy timestamp info
  sh-veu: don't use COLORSPACE_JPEG.
  tw9910: don't use COLORSPACE_JPEG
  tw9910: init priv->scale and update standard
  ak881x: simplify standard checks
  mt9t112: JPEG -> SRGB
  sh_mobile_ceu_camera: fix querycap
  sh_mobile_ceu_camera: set field to FIELD_NONE
  soc_camera: fix enum_input
  soc_camera: fix expbuf support
  soc_camera: compliance fixes
  soc_camera: pass on streamoff error
  soc_camera: always release queue for queue owner
  DocBook/media: fix bad spacing in VIDIOC_EXPBUF

 Documentation/DocBook/media/v4l/vidioc-expbuf.xml  | 38 ++++++++---------
 drivers/media/i2c/ak881x.c                         |  8 ++--
 drivers/media/i2c/soc_camera/mt9t112.c             |  8 ++--
 drivers/media/i2c/soc_camera/tw9910.c              | 35 ++++++++++++++--
 drivers/media/platform/sh_veu.c                    | 10 ++++-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  3 ++
 drivers/media/platform/soc_camera/soc_camera.c     | 48 +++++++++++++---------
 7 files changed, 99 insertions(+), 51 deletions(-)

-- 
2.1.4

