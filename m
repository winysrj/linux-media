Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:30105 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbZEDL6u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 07:58:50 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1847683fkq.5
        for <linux-media@vger.kernel.org>; Mon, 04 May 2009 04:58:48 -0700 (PDT)
Subject: [questions] dmesg: Non-NULL drvdata on register
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Mon, 04 May 2009 15:58:42 +0400
Message-Id: <1241438322.2921.13.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, 

Not so many time ago i noticed such line in dmesg:

radio-mr800 2-1:1.0: Non-NULL drvdata on register

Quick review showed that it appears in usb_amradio_probe fucntions. Then
i found such code in v4l2_device_register() function (v4l2-device.c
file):

/* Set name to driver name + device name if it is empty. */
        if (!v4l2_dev->name[0])
                snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s %
s",
                        dev->driver->name, dev_name(dev));
        if (dev_get_drvdata(dev))
                v4l2_warn(v4l2_dev, "Non-NULL drvdata on register\n");
        dev_set_drvdata(dev, v4l2_dev);
        return 0;

The questions is - should i deal with this warning in dmesg? Probably
the order of callbacks in radio-mr800 probe function is incorrect.

The second questions - should i make atomic_t users counter instead of
int users counter? Then i can use atomic_inc(), atomic_dec(),
atomic_set(). It helps me to remove lock/unlock_kernel() functions. 

-- 
Best regards, Klimov Alexey

