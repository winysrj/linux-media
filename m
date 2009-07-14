Return-path: <linux-media-owner@vger.kernel.org>
Received: from toc.rii.ricoh.com ([205.226.66.129]:51275 "EHLO
	mailx.crc.ricoh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbZGNQte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 12:49:34 -0400
Date: Tue, 14 Jul 2009 09:49:18 -0700 (PDT)
From: Zach LeRoy <zleroy@rii.ricoh.com>
To: "Aguirre Rodriguez, Sergio" <saaguirre@ti.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	linux-omap <linux-omap@vger.kernel.org>
Message-ID: <15157053.23861247590158808.JavaMail.root@mailx.crc.ricoh.com>
In-Reply-To: <17937063.23811247589353235.JavaMail.root@mailx.crc.ricoh.com>
Subject: Problems configuring OMAP35x ISP driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sergio,

I spoke with you earlier about using the ISP and omap34xxcam drivers with a micron mt9d111 SOC sensor.  I have since been able to take pictures, but the sensor data is not making it through the ISP data-path correctly.  I know the problem is in the ISP data-path because I am configuring the sensor the exact same way as I have been on my working PXA system.  I am expecting 4:2:2 packed YUV data, but all of the U and V data is no more than 2 bits where it should be 8.  I know the ISP has a lot of capabilities, but all I want to use it for is grabbing 8-bit data from my sensor and putting it in a buffer untouched using the CCDC interface (and of course clocking and timing).  What are the key steps to take to get this type of configuration?  

Other Questions:

Is there any processing done on YUV data in the ISP driver by default that I am missing?
Has any one else experienced similar problems while adding new sensor support?

Any help here would be greatly appreciated.

Thank you,

Zach LeRoy
