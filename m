Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:28067 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab2JDJgR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 05:36:17 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] Fix fsl-viu compiler warning
Date: Thu, 4 Oct 2012 11:36:02 +0200
Cc: Anatolij Gustschin <agust@denx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210041136.02959.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a quick fix for a compiler warning due to the constifying of vidioc_s_fbuf.

Regards,

	Hans

The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

  em28xx: regression fix: use DRX-K sync firmware requests on em28xx (2012-10-02 17:15:22 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git const2

for you to fetch changes up to c6419c4e74aa986d234f2ce8e13ea3c9d53f1015:

  fsl-viu: fix compiler warning. (2012-10-04 08:46:00 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      fsl-viu: fix compiler warning.

 drivers/media/platform/fsl-viu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
