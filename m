Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1627 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3CXJWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 05:22:41 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id r2O9MbRf001425
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 10:22:40 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id DDA1C11E0154
	for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 10:22:36 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] vivi: add v4l2_ctrl_modify_range test case.
Date: Sun, 24 Mar 2013 10:22:38 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303241022.38105.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Very few drivers use v4l2_ctrl_modify_range. Add it to vivi so applications
can use vivi to test their support for v4l2_ctrl_modify_range.

Regards,

	Hans

The following changes since commit 69aa6f4ec669b9121057cc9e32cb10b5f744f6d6:

  [media] drivers: staging: davinci_vpfe: use resource_size() (2013-03-23 11:35:44 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vivi

for you to fetch changes up to e9117118f71945f60c95371bea4260ba37f3a5b1:

  vivi: add v4l2_ctrl_modify_range test case. (2013-03-24 10:20:21 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      vivi: add v4l2_ctrl_modify_range test case.

 drivers/media/platform/vivi.c |    9 +++++++++
 1 file changed, 9 insertions(+)
