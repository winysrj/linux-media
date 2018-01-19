Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48464 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753332AbeASNwi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 08:52:38 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 3A238600E9
        for <linux-media@vger.kernel.org>; Fri, 19 Jan 2018 15:52:36 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ecX5v-00073A-Qr
        for linux-media@vger.kernel.org; Fri, 19 Jan 2018 15:52:35 +0200
Date: Fri, 19 Jan 2018 15:52:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.16] Last minute CIO2 fixes
Message-ID: <20180119135235.7nz2mcabirkgsasn@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a couple of fixes for the Intel IPU3 CIO2 driver. One is
functional, another fixes a compiler warning.

Please pull.


The following changes since commit e3ee691dbf24096ea51b3200946b11d68ce75361:

  media: ov5640: add support of RGB565 and YUYV formats (2018-01-05 12:54:14 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ipu3

for you to fetch changes up to 8d677b031a4f5d7a5ead85b1ad2486721b4039c5:

  media: intel-ipu3: cio2: fixup off-by-one bug in cio2_vb2_buf_init (2018-01-19 15:49:16 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      media: intel-ipu3: cio2: mark more PM functions as __maybe_unused

Yong Zhi (1):
      media: intel-ipu3: cio2: fixup off-by-one bug in cio2_vb2_buf_init

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
