Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39844 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2DZJrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 05:47:09 -0400
Received: by vbbff1 with SMTP id ff1so750958vbb.19
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2012 02:47:08 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 26 Apr 2012 17:47:08 +0800
Message-ID: <CAHG8p1D1EAO3hgYNvwZL6HgVw-995knuf62TdXh944SkAHoWKw@mail.gmail.com>
Subject: How to implement i2c map device
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I'm writing a driver for adv7842 video decoder. This chip has 12 i2c
register maps. IO map is fixed to 0x20 and others are configurable.
I plan to use 0x20 as the subdevice addr to call
v4l2_i2c_new_subdev_board, and call i2c_new_device and i2c_add_driver
in i2c_probe to enumerate other i2c maps. Is it acceptable or any
other suggestion?

By the way, HDMI support seems under discussion, is there any
framework or guide now?

Thanks,
Scott
