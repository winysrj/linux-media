Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34351 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbcGPJKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 05:10:23 -0400
Date: Sat, 16 Jul 2016 14:40:19 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Inki Dae <inki.dae@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/2] Remove improper workqueue usage
Message-ID: <cover.1468659580.git.bhaktipriya96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set fixes the improper usage of the workqueue API.
This includes dropping the freeing of workqueue and removing the deprecated
create_singlethread_workqueue instance.

Bhaktipriya Shridhar (2):
  [media] cx25821: Drop Freeing of Workqueue
  [media] cx25821: Remove deprecated create_singlethread_workqueue

 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 13 ++-----------
 drivers/media/pci/cx25821/cx25821.h                |  1 -
 2 files changed, 2 insertions(+), 12 deletions(-)

--
2.1.4

