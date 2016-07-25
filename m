Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36054 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbcGYOt6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 10:49:58 -0400
Date: Mon, 25 Jul 2016 20:19:52 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Inki Dae <inki.dae@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 0/2] Remove improper workqueue usage
Message-ID: <20160725144952.GA11594@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set fixes the improper usage of the workqueue API.
This includes dropping the freeing of workqueue and removing the
deprecated create_singlethread_workqueue instance.

Bhaktipriya Shridhar (2):
  [media] cx25821: Drop Freeing of Workqueue
  [media] cx25821: Remove deprecated create_singlethread_workqueue

 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 14 ++------------
 drivers/media/pci/cx25821/cx25821.h                |  1 -
 2 files changed, 2 insertions(+), 13 deletions(-)

--
2.1.4

