Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:59922 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2DXMb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 08:31:58 -0400
Received: from kipc2.localdomain (unknown [3.249.69.203])
	by mail-rly-prd-01.am.health.ge.com (Postfix) with ESMTP id CDFF447BF2
	for <linux-media@vger.kernel.org>; Tue, 24 Apr 2012 12:21:57 +0000 (GMT)
Date: Tue, 24 Apr 2012 14:21:56 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: linux-media@vger.kernel.org
Subject: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2
Message-ID: <20120424122156.GA16769@kipc2.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

guvcview does not display the extra controls (focus, led etc)
any more since kernel 3.2 an higher (Fedora 16, x86_64).

after the various video modes it says:

vid:046d
pid:0990
driver:uvcvideo
Adding control for Pan (relative)
UVCIOC_CTRL_ADD - Error: Inappropriate ioctl for device
checking format: 1196444237
VIDIOC_G_COMP:: Inappropriate ioctl for device
fps is set to 1/25
drawing controls

Checking video mode 640x480@32bpp : OK

----------

/usr/bin/uvcdynctrl -i /usr/share/uvcdynctrl/data/046d/logitech.xml
[libwebcam] Unsupported V4L2_CID_EXPOSURE_AUTO control with a non-contiguous range of choice IDs found
[libwebcam] Invalid or unsupported V4L2 control encountered: ctrl_id = 0x009A0901, name = 'Exposure, Auto'
Importing dynamic controls from file /usr/share/uvcdynctrl/data/046d/logitech.xml.
ERROR: Unable to import dynamic controls: Invalid device or device cannot be opened. (Code: 5)
/usr/share/uvcdynctrl/data/046d/logitech.xml: error: device 'video0' \
    skipped because the driver 'uvcvideo' behind it does not seem to support \
        dynamic controls.

----------

Is there work in progess to get the missing functionality back?

Can I help somehow?

Greetings,
Karl


