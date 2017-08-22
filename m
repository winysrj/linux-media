Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43670 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754645AbdHVHzu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 03:55:50 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 0369960179
        for <linux-media@vger.kernel.org>; Tue, 22 Aug 2017 10:55:49 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dk42O-0008TM-91
        for linux-media@vger.kernel.org; Tue, 22 Aug 2017 10:55:48 +0300
Date: Tue, 22 Aug 2017 10:55:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.14] DW9714 DT support
Message-ID: <20170822075547.dfqv2776lcoaczls@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set adds Devicetree support for DW9714.

Please pull.


The following changes since commit ec0c3ec497cabbf3bfa03a9eb5edcc252190a4e0:

  media: ddbridge: split code into multiple files (2017-08-09 12:17:01 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git dw

for you to fetch changes up to cb94db0d0877db090fe342d47c8b689c4a1cec5d:

  dw9714: Remove ACPI match tables, convert to use probe_new (2017-08-22 09:33:09 +0300)

----------------------------------------------------------------
Sakari Ailus (3):
      dt-bindings: Add bindings for Dongwoon DW9714 voice coil
      dw9714: Add Devicetree support
      dw9714: Remove ACPI match tables, convert to use probe_new

 .../bindings/media/i2c/dongwoon,dw9714.txt         |  9 ++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 drivers/media/i2c/dw9714.c                         | 26 +++++++++-------------
 3 files changed, 21 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
