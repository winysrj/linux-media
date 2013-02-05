Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3899 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3BEOmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 09:42:25 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id r15EgLlU095589
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 5 Feb 2013 15:42:24 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id F335411E00AF
	for <linux-media@vger.kernel.org>; Tue,  5 Feb 2013 15:42:20 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] meye: convert to the control framework
Date: Tue, 5 Feb 2013 15:42:20 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302051542.20444.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches upgrade meye to the control framework.

Unchanged from the RFC patches posted a week ago.

Regards,

        Hans

The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:

  Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git meye

for you to fetch changes up to 41ec4c3e097ca471aa5884aa020cc51a9430493c:

  meye: convert to the control framework (2013-01-29 11:21:02 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      meye: convert to the control framework

 drivers/media/pci/meye/meye.c      |  278 +++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
 drivers/media/pci/meye/meye.h      |    2 +
 include/uapi/linux/meye.h          |    8 ++--
 include/uapi/linux/v4l2-controls.h |    5 ++
 4 files changed, 99 insertions(+), 194 deletions(-)
