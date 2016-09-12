Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52432 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755607AbcILHqv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 03:46:51 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
        by tschai.lan (Postfix) with ESMTPSA id BFF8C18026F
        for <linux-media@vger.kernel.org>; Mon, 12 Sep 2016 09:46:45 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Fix two compilation issues
Message-ID: <6ca10155-97ba-a64b-b761-3e23ed9416d9@xs4all.nl>
Date: Mon, 12 Sep 2016 09:46:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These two patches fix compilation issues for 4.9. One simple warning and one
fixing duplicate functions.

Regards,

	Hans

The following changes since commit 8a5a2ba86ab8fc12267fea974b9cd730ad2dee24:

  [media] v4l: vsp1: Add R8A7792 VSP1V support (2016-09-09 11:32:43 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.9d

for you to fetch changes up to 2fb0feefa258953ebdb0f81931f4725fd5498c14:

  pulse8-cec: fix compiler warning (2016-09-11 11:00:15 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      pxa_camera: merge soc_mediabus.c into pxa_camera.c
      pulse8-cec: fix compiler warning

 drivers/media/platform/Makefile               |   2 +-
 drivers/media/platform/pxa_camera.c           | 482 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/staging/media/pulse8-cec/pulse8-cec.c |   2 +-
 3 files changed, 460 insertions(+), 26 deletions(-)
