Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:33067 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbbLVOWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 09:22:07 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Cc: magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v2 0/2] adv7604: .get_selection support
Date: Tue, 22 Dec 2015 15:22:00 +0100
Message-Id: <1450794122-31293-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

The rcar_vin driver relies on this method.  The second patch makes sure that
they return up-to-date data if the input signal has changed since
initialization.

This revision implements .get_selection instead of .g_crop/.cropcap and
includes the suggested style changes.

It has been tested with the rcar_vin driver together with Hans Verkuil's
"v4l2: remove g/s_crop and cropcap from video ops" patch:

https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=rmcrop&id=9ff32166c29d1323db090d638da27ea652d1d4d8

CU
Uli


Ulrich Hecht (2):
  media: adv7604: implement get_selection
  media: adv7604: update timings on change of input signal

 drivers/media/i2c/adv7604.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

-- 
2.6.3

