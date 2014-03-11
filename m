Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56958 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaCKW6R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 18:58:17 -0400
Received: by mail-qc0-f202.google.com with SMTP id m20so1230360qcx.5
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 15:58:16 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, k.debski@samsung.com, posciak@google.com,
	arun.m@samsung.com, kgene.kim@samsung.com
Subject: Upstream patches for Samsung Exynos s5p-mfc and gsc-m2m
Date: Tue, 11 Mar 2014 15:52:01 -0700
Message-Id: <1394578325-11298-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset upstreams some changes carried in the ChromeOS kernel tree
especially regarding the s5p-mfc video encoder and gsc-m2m color converter
hardware functionality.

Patch 4 in particular affects the V4L2 interface by allowing VIDIOC_REQBUFS(0)
to succeed when the queue is of type V4L2_MEMORY_MMAP, inline with the rest
of the queue memory types.

