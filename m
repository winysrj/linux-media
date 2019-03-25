Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B50C4360F
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 21:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2FC32084D
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 21:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbfCYV2G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:28:06 -0400
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:50466 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730260AbfCYV2F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 17:28:05 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 608A2181D333D;
        Mon, 25 Mar 2019 21:28:04 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: skirt64_2936f772fa94d
X-Filterd-Recvd-Size: 4191
Received: from joe-laptop.perches.com (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Mon, 25 Mar 2019 21:28:03 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Bad file pattern in MAINTAINERS section 'SOC-CAMERA V4L2 SUBSYSTEM'
Date:   Mon, 25 Mar 2019 14:28:01 -0700
Message-Id: <20190325212801.27711-1-joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
References: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A file pattern line in this section of the MAINTAINERS file in linux-next
does not have a match in the linux source files.

This could occur because a matching filename was never added, was deleted
or renamed in some other commit.

The commits that added and if found renamed or removed the file pattern
are shown below.

Please fix this defect appropriately.

1: ---------------------------------------------------------------------------

linux-next MAINTAINERS section:

	14342	SOC-CAMERA V4L2 SUBSYSTEM
	14343	L:	linux-media@vger.kernel.org
	14344	T:	git git://linuxtv.org/media_tree.git
	14345	S:	Orphan
	14346	F:	include/media/soc*
-->	14347	F:	drivers/media/i2c/soc_camera/
	14348	F:	drivers/media/platform/soc_camera/

2: ---------------------------------------------------------------------------

The most recent commit that added or modified file pattern 'drivers/media/i2c/soc_camera/':

commit 90d72ac6e1c3c65233a13816770fb85c8831bff2
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Sat Sep 15 17:59:42 2012 -0300

    MAINTAINERS: fix the path for the media drivers that got renamed
    
    Due to the media tree path renaming, several drivers change their
    location. Update MAINTAINERS accordingly.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 MAINTAINERS | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

3: ---------------------------------------------------------------------------

The last commit with a real presence of file pattern 'drivers/media/i2c/soc_camera/':

commit 280de94a651945905cb8337626c40025e4cea56d
Author: Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Thu Feb 7 08:43:47 2019 -0500

    media: soc_camera: Move to the staging tree
    
    The SoC camera framework has no functional drivers left, something that
    has not changed for years. Move the leftovers to the staging tree.
    
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/i2c/Kconfig                                         | 8 --------
 drivers/media/i2c/Makefile                                        | 1 -
 drivers/media/platform/Kconfig                                    | 1 -
 drivers/media/platform/Makefile                                   | 2 --
 drivers/media/platform/soc_camera/Kconfig                         | 8 --------
 drivers/media/platform/soc_camera/Makefile                        | 1 -
 drivers/staging/media/Kconfig                                     | 2 ++
 drivers/staging/media/Makefile                                    | 1 +
 drivers/{media/i2c => staging/media}/soc_camera/Kconfig           | 8 ++++++++
 drivers/{media/i2c => staging/media}/soc_camera/Makefile          | 1 +
 drivers/{media/platform => staging/media}/soc_camera/soc_camera.c | 0
 .../{media/platform => staging/media}/soc_camera/soc_mediabus.c   | 0
 drivers/{media/i2c => staging/media}/soc_camera/soc_mt9v022.c     | 0
 drivers/{media/i2c => staging/media}/soc_camera/soc_ov5642.c      | 0
 drivers/{media/i2c => staging/media}/soc_camera/soc_ov9740.c      | 0
 15 files changed, 12 insertions(+), 21 deletions(-)
