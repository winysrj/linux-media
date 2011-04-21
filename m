Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59079 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1DUNIu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 09:08:50 -0400
Received: by eyx24 with SMTP id 24so502689eyx.19
        for <linux-media@vger.kernel.org>; Thu, 21 Apr 2011 06:08:49 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Apr 2011 09:08:49 -0400
Message-ID: <BANLkTim79ug6rFJDpdMAi4iaFu8=d3eXTw@mail.gmail.com>
Subject: Driver for r5u870 USB webcams
From: Jon Mason <jdmason@kudzu.us>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

My laptop has the "Ricoh Co., Ltd Visual Communication Camera VGP-VCC7
[R5U870]" webcam.  A quick scan of the kernel does not show the USB ID
listed.  `lsusb` has it listed as:

Bus 001 Device 005: ID 05ca:183a Ricoh Co., Ltd Visual Communication
Camera VGP-VCC7 [R5U870]

I managed to find a Linux driver on the internet at
http://code.google.com/p/r5u870/
The comment on the website seems to imply the driver has been
abandoned by it's original writer.

I am wondering if there are any plans to provide support for this
hardware via extending another driver or if there are any plans to
pull this driver into the kernel.

Thanks,
Jon
