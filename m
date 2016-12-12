Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52851 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751494AbcLLLRB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 06:17:01 -0500
Received: from axis700.grange ([89.0.199.8]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MI4yc-1cCY322dZ8-003sWn for
 <linux-media@vger.kernel.org>; Mon, 12 Dec 2016 12:16:58 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 893578B116
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2016 12:17:05 +0100 (CET)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v3 0/4] uvcvideo: metadata device node
Date: Mon, 12 Dec 2016 12:16:48 +0100
Message-Id: <1481541412-1186-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

This is v3 of the uvcvideo metadata node patch along with three 
auxiliary patches. All comments to v2 have been addressed, more 
details are in the patch header. Patch 3 in the series is a fix and 
should go to stable too.

Thanks
Guennadi
