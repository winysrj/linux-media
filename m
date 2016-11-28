Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49495 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932283AbcK1OSG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 09:18:06 -0500
Received: from axis700.grange ([89.0.199.8]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LnlmV-1cdnc32HE7-00hryX for
 <linux-media@vger.kernel.org>; Mon, 28 Nov 2016 15:18:04 +0100
Received: from localhost (localhost [127.0.0.1])
        by axis700.grange (Postfix) with ESMTP id 8D8288B110
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2016 15:18:03 +0100 (CET)
Date: Mon, 28 Nov 2016 15:18:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: 3A / auto-exposure Region of Interest setting
Message-ID: <Pine.LNX.4.64.1611281449520.6665@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Has anyone already considered supporting 3A (e.g. auto-exposure) Region of 
Interest selection? In UVC this is the "Digital Region of Interest (ROI) 
Control." Android defines ANDROID_CONTROL_AE_REGIONS, 
ANDROID_CONTROL_AWB_REGIONS, ANDROID_CONTROL_AF_REGIONS. The UVC control 
defines just a single rectangle for all (supported) 3A functions. That 
could be implemented, defining a new selection target. However, Android 
allows arbitrary numbers of ROI rectangles with associated weights. Any 
ideas?

Thanks
Guennadi
