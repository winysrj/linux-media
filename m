Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41944 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754483AbeAIWfU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 17:35:20 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id C43F9600FA
        for <linux-media@vger.kernel.org>; Wed, 10 Jan 2018 00:35:18 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eZ2UI-0005IV-7v
        for linux-media@vger.kernel.org; Wed, 10 Jan 2018 00:35:18 +0200
Date: Wed, 10 Jan 2018 00:35:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.16] CIO2 compiler warning fix
Message-ID: <20180109223517.lkj4opdpm64jpf5d@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's compile warning fix for the Intel IPU3 CIO2 driver from Arnd.

Please pull.


The following changes since commit e3ee691dbf24096ea51b3200946b11d68ce75361:

  media: ov5640: add support of RGB565 and YUYV formats (2018-01-05 12:54:14 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ipu3

for you to fetch changes up to 0bf3352560b82c12380823f035f5fb2171683f23:

  media: intel-ipu3: cio2: mark more PM functions as __maybe_unused (2018-01-09 13:16:07 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      media: intel-ipu3: cio2: mark more PM functions as __maybe_unused

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
