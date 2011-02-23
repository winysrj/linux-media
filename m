Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:56767 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1BWLQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 06:16:40 -0500
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LH2004VIHZOUG90@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Feb 2011 20:16:36 +0900 (KST)
Received: from NOSUNGCHUNK01 ([12.23.102.212])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LH200KBIHZPJ0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Feb 2011 20:16:37 +0900 (KST)
Date: Wed, 23 Feb 2011 20:16:36 +0900
From: Sungchun Kang <sungchun.kang@samsung.com>
Subject: Hello, how to control FrameBuffer device as v4l2 sub-device?
To: linux-media@vger.kernel.org
Reply-to: sungchun.kang@samsung.com
Message-id: <015301cbd34b$22aa38a0$67fea9e0$%kang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: ko
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

FIMC is hardware function like csc, post, rotatin and so on.
It is necessary to send some data to FB from FIMC.

So, I have registered FB driver as v4l2 sub-device of FIMC.
----------------         
|  v4l2_device   |       
 ----------------            
|   fimc-0       |----------------
|                |                |
 ----------------              |
        |                         |
----------------         ----------------         
|  v4l2_subdev   |       |  v4l2_subdeve   |       
 ----------------         ----------------            
|     FB1        |       |     mipi-csi,   |
|     FB2        |       |      senor     |
 ----------------         ----------------
And, it is controlled using platform_get_drvdata and platform_set_drvdata between FIMC and FB drvier.
But, FB driver uses drvdata for its own purpose. If I set v4l2_subdev ptr like this :
platform_set_drvdata(pdev, &sfb->sd); // v4l2_subdev sd;

platform_device ptr is changed.

Because FB driver aleady set like this :
platform_set_drvdata(pdev, sfb);

So, I wonder how to control data between 2 hardware.

If you have some idea, pls reply.

BRs,

