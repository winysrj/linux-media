Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8368 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966088AbbD2Hdu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 03:33:50 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NNK00HG850B8B70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Apr 2015 08:33:47 +0100 (BST)
Message-id: <5540895A.5060102@samsung.com>
Date: Wed, 29 Apr 2015 09:33:46 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: S_CTRL must be called twice  to set volatile controls
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

After testing my v4l2-flash helpers patch [1] with the recent patches
for v4l2-ctrl.c ([2] and [3]) s_ctrl op isn't called despite setting
the value that should be aligned to the other step than default one.

This happens for V4L2_CID_FLASH_TORCH_INTENSITY control with
V4L2_CTRL_FLAG_VOLATILE flag.

The situation improves after setting V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
flag for the control. Is this flag required now for volatile controls
to be writable?

[1] http://www.spinics.net/lists/linux-media/msg89004.html
[2] 45f014c5 [media] media/v4l2-ctrls: Always execute EXECUTE_ON_WRITE ctrls
[3] b08d8d26 [media] media/v4l2-ctrls: volatiles should not generate 
CH_VALUE
-- 
Best Regards,
Jacek Anaszewski
