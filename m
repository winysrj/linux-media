Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2627 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab3EJLJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 07:09:32 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id r4AB9SnZ038902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 10 May 2013 13:09:31 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 93EFC1300099
	for <linux-media@vger.kernel.org>; Fri, 10 May 2013 13:09:28 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] Fixes for 3.10
Date: Fri, 10 May 2013 13:09:27 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305101309.27588.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

It's all small stuff for 3.10.

Note the DocBook change: while not a bug fix, I do want this fixed for 3.10:
at least two companies I talked to assumed that there is no codec support in
V4L2 due to this incorrect text. I consider that a major bug, which is why
I'm queuing this for 3.10.

Regards,

	Hans

The following changes since commit 02615ed5e1b2283db2495af3cf8f4ee172c77d80:

  [media] cx88: make core less verbose (2013-04-28 12:40:52 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.10

for you to fetch changes up to 7ac492209145da3f08a524d39435aca0fe4d1f93:

  vpfe-capture.c: remove unused label probe_free_lock (2013-05-10 12:53:08 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      radio-si476x: depend on SND_SOC

Geert Uytterhoeven (1):
      v4l2: SI476X MFD - Do not use binary constants

Hans Verkuil (2):
      DocBook: media: update codec section, drop obsolete 'suspended' state.
      vpfe-capture.c: remove unused label probe_free_lock

Lad, Prabhakar (2):
      media: davinci: vpbe: fix layer availability for NV12 format
      davinci: vpfe: fix error path in probe

Wei Yongjun (1):
      davinci: vpfe: fix error return code in vpfe_probe()

 Documentation/DocBook/media/v4l/dev-codec.xml        |   35 ++++++++++++++++++++++-------------
 drivers/media/platform/davinci/vpbe_display.c        |   15 +++++++++++++++
 drivers/media/platform/davinci/vpfe_capture.c        |    3 +--
 drivers/media/radio/Kconfig                          |    1 +
 drivers/media/radio/radio-si476x.c                   |    2 +-
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c |    6 ++++--
 6 files changed, 44 insertions(+), 18 deletions(-)
