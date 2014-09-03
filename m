Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2573 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbaICMug (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 08:50:36 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id s83CoVl8046551
	for <linux-media@vger.kernel.org>; Wed, 3 Sep 2014 14:50:33 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 2CE602A075A
	for <linux-media@vger.kernel.org>; Wed,  3 Sep 2014 14:50:27 +0200 (CEST)
Message-ID: <54070E74.7030705@xs4all.nl>
Date: Wed, 03 Sep 2014 14:49:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] cx23885: vb2 conversion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request is for the cx23885 vb2 conversion. In this pull request
I dropped the VBI offset change from the first patch (as discussed on irc)
and the 'weird sizes' patch. Those will come later when I have a bit more
time for further testing and digging into the datasheet.

But I'd like to get this stuff in at least.

Regards,

	Hans

The following changes since commit 4bf167a373bbbd31efddd9c00adc97ecc69fdb67:

  [media] v4l: vsp1: fix driver dependencies (2014-09-03 09:10:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cx23c

for you to fetch changes up to a3f45ff9e8ac28e6a8fdb89e9ff353a47b863418:

  cx23885: Add busy checks before changing formats (2014-09-03 14:40:47 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      cx23885: convert to vb2
      cx23885: fix field handling
      cx23885: remove btcx-risc dependency
      cx23885: Add busy checks before changing formats

 drivers/media/pci/cx23885/Kconfig         |   5 +-
 drivers/media/pci/cx23885/Makefile        |   1 -
 drivers/media/pci/cx23885/altera-ci.c     |   4 +-
 drivers/media/pci/cx23885/cx23885-417.c   | 322 +++++++------------
 drivers/media/pci/cx23885/cx23885-alsa.c  |   9 +-
 drivers/media/pci/cx23885/cx23885-core.c  | 337 ++++++--------------
 drivers/media/pci/cx23885/cx23885-dvb.c   | 131 +++++---
 drivers/media/pci/cx23885/cx23885-vbi.c   | 275 ++++++++--------
 drivers/media/pci/cx23885/cx23885-video.c | 830 ++++++++++++++-----------------------------------
 drivers/media/pci/cx23885/cx23885.h       |  79 ++---
 10 files changed, 710 insertions(+), 1283 deletions(-)
