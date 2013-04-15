Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3457 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab3DOKlN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 06:41:13 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id r3FAT35a082643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 12:29:05 +0200 (CEST)
	(envelope-from hansverk@cisco.com)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 2A22611E00F4
	for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 12:29:02 +0200 (CEST)
From: Hans Verkuil <hansverk@cisco.com>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] cx25821: do not expose broken video output streams
Date: Mon, 15 Apr 2013 12:29:02 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304151229.02226.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

As requested: the cx25821 fix to prevent it exposing the broken video output
streams posing a security risk.

Regards,

	Hans

The following changes since commit 4c41dab4d69fb887884dc571fd70e4ddc41774fb:

  [media] rc: fix single line indentation of keymaps/Makefile (2013-04-14 22:51:41 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cx25821-fix

for you to fetch changes up to 7f7ae0c294ed718d4d0fe129518c6b144b68235d:

  cx25821: do not expose broken video output streams. (2013-04-15 12:23:45 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      cx25821: do not expose broken video output streams.

 drivers/media/pci/cx25821/cx25821-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
