Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2616 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2HFNod (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 09:44:33 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id q76DiUYl005694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 6 Aug 2012 15:44:31 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.186])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 5E6B046A0146
	for <linux-media@vger.kernel.org>; Mon,  6 Aug 2012 15:44:30 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] A bunch of fixes/improvements for vivi
Date: Mon, 6 Aug 2012 15:44:29 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208061544.29718.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ccc0e3483c2447fd14d4fb9ba2a77da628322815:

  [media] move dvb-usb-ids.h to dvb-core (2012-08-05 19:53:26 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vivi

for you to fetch changes up to 441aed7ba9a6abbebea5b77f30a2a637f1f4c8b2:

  vivi: zero fmt.pix.priv as per spec. (2012-08-06 15:43:13 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      vivi: fix colorspace setup.
      vivi: add frame size reporting.
      vivi: zero fmt.pix.priv as per spec.

 drivers/media/video/vivi.c |   48 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)
