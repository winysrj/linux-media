Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail96.messagelabs.com ([216.82.254.19]:31108 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0CVKZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 06:25:17 -0400
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 22 Mar 2010 15:50:03 +0530
Subject: omap2 camera
Message-ID: <70376CA23424B34D86F1C7DE6B997343017F5D5BD5@VSHINMSMBX01.vshodc.lntinfotech.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi list,

I am using OMAP2430 board and I wanted to test camera module on that board.
I am using latest 2.6.33 kernel. However, it looks like camera module is not supported with latest kernel.

Anyone is having any idea? Also, do we require to have ex3691 sensor driver in mainline kernel in order to get omap24xxcam working ?

These are the steps I followed,
1. make omap2430_sdp_defconfig
2. Enable omap2 camera option which is under drivers/media/video
3. make uImage

And with this uImage, camera is not working. I would appreciate any help.

Thanks,
Viral

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
