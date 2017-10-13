Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35290 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752468AbdJMVxi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 17:53:38 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id D3C43600EE
        for <linux-media@vger.kernel.org>; Sat, 14 Oct 2017 00:53:36 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e37tg-000318-8I
        for linux-media@vger.kernel.org; Sat, 14 Oct 2017 00:53:36 +0300
Date: Sat, 14 Oct 2017 00:53:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] Improve video-interfaces.txt DT property
 documentation
Message-ID: <20171013215335.ginbwd5l6fkfss4d@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The two patches improve documentation of lane numbering and  documentation
practices themselves.

Please pull.


The following changes since commit a8c779eb056e9874c6278151ade857c3ac227db9:

  [media] imon: Improve a size determination in two functions (2017-10-04 16:19:40 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git video-dt-doc

for you to fetch changes up to 8c2ff7f03105454400b6e40da5fbd9e29eba0357:

  dt: bindings: media: Document data lane numbering without lane reordering (2017-10-14 00:43:30 +0300)

----------------------------------------------------------------
Sakari Ailus (2):
      dt: bindings: media: Document practices for DT bindings, ports, endpoints
      dt: bindings: media: Document data lane numbering without lane reordering

 .../devicetree/bindings/media/video-interfaces.txt         | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
