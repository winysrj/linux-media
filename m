Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39119 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2KCKoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2012 06:44:24 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so1951905wey.19
        for <linux-media@vger.kernel.org>; Sat, 03 Nov 2012 03:44:22 -0700 (PDT)
Message-ID: <1351939456.1915.10.camel@edge.config>
Subject: s5p-mfc cyclic refresh and slicing
From: Mike Dyer <mike.dyer@md-soft.co.uk>
To: linux-samsung-soc@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
Date: Sat, 03 Nov 2012 10:44:16 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using the MFC on an S5PV210 to encode H264.

I'm interested in enabling cyclic intra refresh and fixed size slices.

I've set the controls 
V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB to 1
V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE to
V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES
V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES to 20 * 1024

I've checked that these are making it to the driver, but they seem to
have no effect on the encode.

Are there any limitations, or other controls that need to be set to
enable these?

Cheers,
Mike


