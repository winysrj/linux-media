Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:34261 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbFDMl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2015 08:41:59 -0400
Received: by qcej9 with SMTP id j9so16985480qce.1
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2015 05:41:58 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 4 Jun 2015 08:41:58 -0400
Message-ID: <CALzAhNWD7wO5LjhMZ1B+F_onq_VGkaFNise+t+a81+6bFFo3NA@mail.gmail.com>
Subject: HVR22x5 I2C
From: Steven Toth <stoth@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti, for your records here's the I2C reply when the si2168 asks for
the chip id from one of these newer D40 chips:

80 00 44 34 30 02 00 00 00 00 00 00 00 00

It might make sense to change the "unknown chip version Si21%d-%c%c%c"
default message to include a hex dump of the first 5 bytes, to
accelerate/aid future debugging issues.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
