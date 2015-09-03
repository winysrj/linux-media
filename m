Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36608 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836AbbICXMl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2015 19:12:41 -0400
Received: by lbcao8 with SMTP id ao8so2320708lbc.3
        for <linux-media@vger.kernel.org>; Thu, 03 Sep 2015 16:12:39 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: g.liakhovetski@gmx.de, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, lars@metafoo.de
Cc: linux-sh@vger.kernel.org, g.liakhovetski@gmx.de
Subject: [PATCH 0/3] VIN: call g std() method as requested by Hans
Date: Fri, 04 Sep 2015 02:12:37 +0300
Message-ID: <6015647.cjLjRfTWc7@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

   Here are 3 patches against the 'fixes' branch of the 'media_tree.git' repo
plus the VIN driver patch to propagate querystd() error. First we add support
for the g_std() video method to the ADV7180 and ML86V7667 I2C drivers which
is needed for the full 'soc_camera' compliance, then we replace the quesrystd()
video method call with g_std() in the R-Car VIN driver; 2 former patches are
pre-requisites for the 3rd, otherwise that patch would break the frame capture.

[1/3] adv7180: implement g_std() method
[2/3] ml86v7667-implement-g_std-method
[3/3/] rcar_vin: call g_std() instead of querystd()

MBR, Sergei

