Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fpasia.hk ([202.130.89.98]:47449 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3EaCfp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 22:35:45 -0400
Message-ID: <51A80A28.6060209@gtsys.com.hk>
Date: Fri, 31 May 2013 10:25:44 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org
Subject: v4l and codadx6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Javier,

Good day to you! Sasha Hauer recommend you to contact.
As a maintainer of the coda implementation for the imx27/53 in the upstream 
kernel I like to ask you for help.

We have a brand new board developed using imx27 for a RFID integrated reader
and want use the VPU / V4L for video capture. The board is working well with
the 3.9.4 at the moment but the firmware for the coda is missing and I cannot
test the sensor beside check if the ov2640 can probed.

May you have a hint to get the
.firmware    = "v4l-codadx6-imx27.bin",
for test purpose.

The Freescale firmware for 2.6.22 vpu_fw_imx27_TO[12].bin didn't work and for 
sure not desire to do.


Thanks for an answer :-)
Cheers
Chris


-- 
GTSYS Limited RFID Technology
Unit 958 , KITEC - 1 Trademart Drive - Kowloon Bay - Hong Kong
Fax (852) 8167 4060 - Tel (852) 3598 9488

Disclaimer: http://www.gtsys.com.hk/email/classified.html
