Return-path: <linux-media-owner@vger.kernel.org>
Received: from hl140.dinaserver.com ([82.98.160.94]:53595 "EHLO
	hl140.dinaserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbbG2G0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2015 02:26:21 -0400
Received: from [192.168.2.27] (5.Red-212-170-183.staticIP.rima-tde.net [212.170.183.5])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by hl140.dinaserver.com (Postfix) with ESMTPSA id 36C034BB1BCE
	for <linux-media@vger.kernel.org>; Wed, 29 Jul 2015 08:26:15 +0200 (CEST)
Message-ID: <55B87201.1070801@by.com.es>
Date: Wed, 29 Jul 2015 08:26:09 +0200
From: Javier Martin <javiermartin@by.com.es>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: coda: Problems with encoding in i.MX6DL.
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I am running kernel 4.1 in a var-dvk-solo-linux evaluation board from 
Variscite.

This is what I get at system start-up:

coda 2040000.vpu: Firmware code revision: 34588
coda 2040000.vpu: Initialized CODA960.
coda 2040000.vpu: Unsupported firmware version: 2.1.8
coda 2040000.vpu: codec registered as /dev/video[0-1]

Apparently, the firmware is being loaded properly although it complains 
about that version not being supported.


After queuing some YUV420 buffers with a simple application I perform a 
VIDIOC_STREAMON in both the CAPTURE and the OUTPUT interfaces but I get 
the following error:

coda 2040000.vpu: coda is not initialized.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 91 at drivers/media/v4l2-core/videobuf2-core.c:1792 
vb2_start_streaming+0xe0/0x15c()
Modules linked in:
CPU: 0 PID: 91 Comm: wmip_bsp_tests Tainted: G        W 
4.1.0-00004-g192a113-dirty #96
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Backtrace:
[<c0012cb4>] (dump_backtrace) from [<c0012ecc>] (show_stack+0x18/0x1c)
  r6:c0815888 r5:00000000 r4:c08d3764 r3:00000000
[<c0012eb4>] (show_stack) from [<c061ab8c>] (dump_stack+0x8c/0x9c)
[<c061ab00>] (dump_stack) from [<c002775c>] (warn_slowpath_common+0x88/0xb8)
  r5:00000700 r4:00000000
[<c00276d4>] (warn_slowpath_common) from [<c0027830>] 
(warn_slowpath_null+0x24/0x2c)
  r8:edc35000 r7:00000000 r6:ee1ee408 r5:ee1ee4d8 r4:fffffff2
[<c002780c>] (warn_slowpath_null) from [<c0489734>] 
(vb2_start_streaming+0xe0/0x15c)
[<c0489654>] (vb2_start_streaming) from [<c048bc50>] 
(vb2_internal_streamon+0x118/0x164)
  r7:00000000 r6:edc1614c r5:ee1ee400 r4:ee1ee408
[<c048bb38>] (vb2_internal_streamon) from [<c048bcd4>] 
(vb2_streamon+0x38/0x58)
  r5:ee1ee400 r4:00000001
[<c048bc9c>] (vb2_streamon) from [<c0485670>] (v4l2_m2m_streamon+0x38/0x54)
[<c0485638>] (v4l2_m2m_streamon) from [<c04856a4>] 
(v4l2_m2m_ioctl_streamon+0x18/0x1c)
  r5:ee82f068 r4:40045612
[<c048568c>] (v4l2_m2m_ioctl_streamon) from [<c0474ea0>] 
(v4l_streamon+0x20/0x24)
[<c0474e80>] (v4l_streamon) from [<c0477810>] (__video_do_ioctl+0x264/0x2cc)
[<c04775ac>] (__video_do_ioctl) from [<c0477294>] 
(video_usercopy+0x190/0x48c)
  r10:ee1ebe20 r9:00000001 r8:be916b74 r7:00000000 r6:00000000 r5:c04775ac
  r4:40045612
[<c0477104>] (video_usercopy) from [<c04775a8>] (video_ioctl2+0x18/0x1c)
  r10:eea7dd88 r9:be916b74 r8:ee82fcf0 r7:40045612 r6:be916b74 r5:edc35000
  r4:ee82f068
[<c0477590>] (video_ioctl2) from [<c0473a4c>] (v4l2_ioctl+0xac/0xc8)
[<c04739a0>] (v4l2_ioctl) from [<c00f8334>] (do_vfs_ioctl+0x430/0x624)
  r8:00000003 r7:be916b74 r6:00000003 r5:edc35000 r4:edc35000 r3:c04739a0
[<c00f7f04>] (do_vfs_ioctl) from [<c00f8564>] (SyS_ioctl+0x3c/0x64)
  r10:00000000 r9:ee1ea000 r8:00000003 r7:be916b74 r6:40045612 r5:edc35000
  r4:edc35000
[<c00f8528>] (SyS_ioctl) from [<c000f720>] (ret_fast_syscall+0x0/0x3c)
  r8:c000f8c4 r7:00000036 r6:00008aa8 r5:00000000 r4:00000000 r3:be916b74
---[ end trace 2b0ba71bfb12fec4 ]---

As anyone seen the same issue? Could be related to the "Unsupported 
firmware version" complaint?
Do you know where to get the 2.1.5 firmware for the i.MX6D?

Regards,
Javier.
