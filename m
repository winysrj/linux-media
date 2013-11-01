Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:56467 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3KAWjE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 18:39:04 -0400
Received: by mail-we0-f179.google.com with SMTP id w61so115268wes.24
        for <linux-media@vger.kernel.org>; Fri, 01 Nov 2013 15:39:02 -0700 (PDT)
Message-ID: <52742D84.5060707@gmail.com>
Date: Fri, 01 Nov 2013 23:39:00 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] videobuf2 update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I've got only one patch this time. Similar functionality is already 
available
in other subsystems using DMABUF.

The following changes since commit 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

   [media] media: st-rc: Add ST remote control driver (2013-10-31 
08:20:08 -0200)

are available in the git repository at:
   git://linuxtv.org/snawrocki/samsung.git for-v3.13-videobuf2-2

Philipp Zabel (1):
       videobuf2: Add support for file access mode flags for DMABUF 
exporting

  Documentation/DocBook/media/v4l/vidioc-expbuf.xml |    8 +++++---
  drivers/media/v4l2-core/videobuf2-core.c          |    8 ++++----
  drivers/media/v4l2-core/videobuf2-dma-contig.c    |    4 ++--
  include/media/videobuf2-core.h                    |    2 +-
  4 files changed, 12 insertions(+), 10 deletions(-)

--
Regards,
Sylwester
