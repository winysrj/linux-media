Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3312 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2LVKuq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Dec 2012 05:50:46 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id qBMAoheH015893
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sat, 22 Dec 2012 11:50:45 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id F216911E00C2
	for <linux-media@vger.kernel.org>; Sat, 22 Dec 2012 11:50:37 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] Improve media Kconfig menu
Date: Sat, 22 Dec 2012 11:50:37 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201212221150.37395.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 0dae88392395e228e67436cd08f084d395b39df5:

  [media] em28xx: add support for RC6 mode 0 on devices that support it (2012-12-21 21:16:19 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git menu

for you to fetch changes up to 3d24231b6aa4b27ace53140bb8db1ad3aa092efa:

  Improve media Kconfig menu (2012-12-22 11:48:58 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      Improve media Kconfig menu

 drivers/media/Kconfig |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)
