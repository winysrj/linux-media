Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:46281 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbbEALTR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2015 07:19:17 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C11452A009F
	for <linux-media@vger.kernel.org>; Fri,  1 May 2015 13:19:10 +0200 (CEST)
Message-ID: <5543612E.2040108@xs4all.nl>
Date: Fri, 01 May 2015 13:19:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Two patches
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two more patches for 4.2. The marvell-ccic depended on the marvell pull request
to be applied first and the ov2659 patch depended on the new
v4l2_of_alloc_parse_endpoint() call to be merged.

Regards,

	Hans

The following changes since commit 90ca75fd1945d9e51e21cbde0aae1aad68730dc5:

  [media] marvell-ccic: fix memory leak on failure path in cafe_smbus_setup() (2015-05-01 07:50:54 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2g

for you to fetch changes up to 55fc08d901fb5f96efb6bdc32dd056ad872fd5dc:

  marvell-ccic: fix RGB444 format (2015-05-01 13:11:43 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      marvell-ccic: fix RGB444 format

Lad, Prabhakar (1):
      media: i2c: ov2659: Use v4l2_of_alloc_parse_endpoint()

 drivers/media/i2c/ov2659.c                      | 19 ++++++++++++++-----
 drivers/media/platform/marvell-ccic/mcam-core.c |  9 ++++-----
 2 files changed, 18 insertions(+), 10 deletions(-)
