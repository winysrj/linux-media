Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:64854 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2IZHr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 03:47:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] Add back lost tda9875 copyright
Date: Wed, 26 Sep 2012 09:47:00 +0200
Cc: guillaume <guiguid@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209260947.00189.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the separate tda9875 driver was merged into tvaudio the copyright
line of the tda9875 driver was dropped inadvertently. Add it back.

Regards,

	Hans

The following changes since commit 4313902ebe33155209472215c62d2f29d117be29:

  [media] ivtv-alsa, ivtv: Connect ivtv PCM capture stream to ivtv-alsa interface driver (2012-09-18 13:29:07 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tvaudio

for you to fetch changes up to d4c90825a394f0bb3858516757c427e19cdfe224:

  tvaudio: add back lost tda9875 copyright. (2012-09-25 09:44:46 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      tvaudio: add back lost tda9875 copyright.

 drivers/media/i2c/tvaudio.c |    4 ++++
 1 file changed, 4 insertions(+)
