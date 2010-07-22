Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57263 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0GVIcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 04:32:31 -0400
Received: by wyf19 with SMTP id 19so349759wyf.19
        for <linux-media@vger.kernel.org>; Thu, 22 Jul 2010 01:32:30 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 22 Jul 2010 11:32:29 +0300
Message-ID: <AANLkTikXKlxppwCP4eBvsx_uR47Nf_zipDlZGewrr3Eo@mail.gmail.com>
Subject: V4L2 driver
From: liat korner <liatkorner@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to load the tvp5150 driver with OMAP35.
I get no /dev/video0 device.
I have noticed that this driver uses the new subdev mechanism. It
seems that the driver does not call the function:
video_register_device (I understand that this is the function that
creates video0).

Can anyone please help me understand how the subdev supposed to work?
How it supposed to create video0?

Thanks in advance,
Liat
