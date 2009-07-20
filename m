Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f197.google.com ([209.85.210.197]:46849 "EHLO
	mail-yx0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZGTTdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 15:33:44 -0400
Received: by yxe35 with SMTP id 35so41714yxe.33
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 12:33:43 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 20 Jul 2009 15:25:57 -0400
Message-ID: <bb2708720907201225t5ecdab50t4ceb7c95261901df@mail.gmail.com>
Subject: omap35xx question
From: John Sarman <johnsarman@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am working with the omap34xx camera driver.  I have a working sensor
driver that is capable of delivering Bayer data.  I have successfully
ran the driver with both raw output and YUYV.  However when in YUYV
the previewer resizer seems SLOW
and over time the select call will timeout.  I am able to run the
device using xawtv, but it will sadly end with a v4l2: oops select
timeout.  My sensor is set to 2592 x 1944 although my driver says
800x600 and is outputing 7 fps.  When I observe the interrupts i get a
series of HS_VS then I will get a preview and resizer interrupt, then
more HS_VS.  I was thinking I would get a HS_VS then VDO VD1 PREV
RESize, but am unsure of this.  Any help or enlightenment is
appreciated.


--
John Sarman
