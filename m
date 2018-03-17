Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:41122 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752077AbeCQP2d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Mar 2018 11:28:33 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/5] Tegra Video Decoder patches for 4.17
Date: Sat, 17 Mar 2018 18:28:10 +0300
Message-Id: <cover.1521300358.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello media maintainers,

I've been postponing sending out these patches for awhile because I was
waiting for a review for the Tegra memory controller patches that would
allow to reset VDE HW properly and was hoping that they will get into 4.17,
but it's getting quite late now and seems 4.18 is the best bet now for the
proper VDE reset. So here is a small patchset that addresses couple of
minor issues that I've spotted over time.

Dmitry Osipenko (5):
  media: staging: tegra-vde: Align bitstream size to 16K
  media: staging: tegra-vde: Silence some of checkpatch warnings
  media: staging: tegra-vde: Correct minimum size of U/V planes
  media: staging: tegra-vde: Do not handle spurious interrupts
  media: staging: tegra-vde: Correct included header

 drivers/staging/media/tegra-vde/tegra-vde.c | 63 ++++++++++++++++-------------
 1 file changed, 34 insertions(+), 29 deletions(-)

-- 
2.16.1
