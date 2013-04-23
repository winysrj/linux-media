Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53838 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3DWKwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 06:52:22 -0400
Received: by mail-pd0-f172.google.com with SMTP id 4so360312pdd.31
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 03:52:22 -0700 (PDT)
From: Katsuya Matsubara <matsu@igel.co.jp>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH 0/3] Fix some bugs in the sh_veu driver
Date: Tue, 23 Apr 2013 19:51:34 +0900
Message-Id: <1366714297-2784-1-git-send-email-matsu@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

This patch set fixes some small bugs in the sh_veu driver.
They have been tested on the Mackerel board.

Thanks,

Katsuya Matsubara (3):
  [media] sh_veu: invoke v4l2_m2m_job_finish() even if a job has been
    aborted
  [media] sh_veu: keep power supply until the m2m context is released
  [media] sh_veu: fix the buffer size calculation

 drivers/media/platform/sh_veu.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

---
Katsuya Matsubara / IGEL Co., Ltd
