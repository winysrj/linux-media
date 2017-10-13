Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54222 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751571AbdJMXNn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 19:13:43 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, hansverk@cisco.com, kgene@kernel.org,
        krzk@kernel.org, s.nawrocki@samsung.com, shailendra.v@samsung.com,
        shuah@kernel.org, Julia.Lawall@lip6.fr, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] fix lockdep warnings in s5p_mfc and exynos-gsc vb2 drivers
Date: Fri, 13 Oct 2017 17:13:35 -0600
Message-Id: <cover.1507935819.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Driver mmap functions shouldn't hold lock when calling vb2_mmap(). The
vb2_mmap() function has its own lock that it uses to protect the critical
section.

Reference: commit log for f035eb4e976ef5a059e30bc91cfd310ff030a7d3

Shuah Khan (2):
  media: exynos-gsc: fix lockdep warning
  media: s5p-mfc: fix lockdep warning

 drivers/media/platform/exynos-gsc/gsc-m2m.c | 5 -----
 drivers/media/platform/s5p-mfc/s5p_mfc.c    | 3 ---
 2 files changed, 8 deletions(-)

-- 
2.7.4
