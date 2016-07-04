Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:28129 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752844AbcGDKsm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 06:48:42 -0400
From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
To: <linux-firmware@kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	<linux-mediatek@lists.infradead.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <tiffany.lin@mediatek.com>,
	<eddie.huang@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Subject: pull request: lunux-firmware: Add Mediatek MT8173 VPU firmware
Date: Mon, 4 Jul 2016 18:48:34 +0800
Message-ID: <1467629314-31902-1-git-send-email-andrew-ct.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi linux-firmware maintainers,

The following changes since commit 3ef7857d511ce6a91c5ce609da76c4702651cfa5:

  amdgpu: update polaris ucode (2016-06-28 14:31:11 -0400)

are available in the git repository at:

  https://github.com/andrewct-chen/vpu-linux-firmware.git vpu_encode

for you to fetch changes up to 40876d7b3c911161ab71bc84a6e90f257a13cdc4:

  mediatek: Add mt8173 VPU firmware (2016-07-04 16:26:54 +0800)

----------------------------------------------------------------
Andrew-CT Chen (1):
      mediatek: Add mt8173 VPU firmware

 WHENCE    |   19 +++++++++++++++++++
 vpu_d.bin |  Bin 0 -> 4084848 bytes
 vpu_p.bin |  Bin 0 -> 131036 bytes
 3 files changed, 19 insertions(+)
 create mode 100644 vpu_d.bin
 create mode 100644 vpu_p.bin
