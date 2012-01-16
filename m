Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:19739 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab2APPdK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 10:33:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.3] Fix inconsistent control names
Date: Mon, 16 Jan 2012 16:32:57 +0100
Cc: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	Kamil Debski <k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161632.57481.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This one would be very nice to have for 3.3, especially for the new flash controls.

Regards,

	Hans

The following changes since commit d04ca8df70f0e1c3fe6ee2aeb1114b03a3a3de88:

  [media] cxd2820r: do not switch to DVB-T when DVB-C fails (2012-01-16 12:47:32 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git ctrlnames

Hans Verkuil (1):
      v4l2-ctrls: make control names consistent.

 drivers/media/video/v4l2-ctrls.c |   54 +++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 27 deletions(-)
