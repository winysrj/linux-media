Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:58636 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaFUUpF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jun 2014 16:45:05 -0400
Received: by mail-yh0-f45.google.com with SMTP id t59so3904650yho.18
        for <linux-media@vger.kernel.org>; Sat, 21 Jun 2014 13:45:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6a19b39b-a20a-45b7-b889-611a39bf0325@email.android.com>
References: <CAGoCfiyeHbYYTSYY_VPEXJ4z8668w6LdjprW1+FbMJCOoCekwA@mail.gmail.com>
	<6a19b39b-a20a-45b7-b889-611a39bf0325@email.android.com>
Date: Sat, 21 Jun 2014 16:45:04 -0400
Message-ID: <CALzAhNV09XiqVnNOtA=e0wNM=11riXG8hDhzA8gixqKPNmh5nw@mail.gmail.com>
Subject: Re: Best way to add subdev that doesn't use I2C or SPI?
From: Steven Toth <stoth@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>Any suggestions welcome (and in particular if you can point me to an
>>example case where this is already being done).

I'm not aware of any subdevs of that type.

Depending on the nature of the registers in the sub-dev silicon, and
its mode of operation, it may fit into a virtual i2c device model
pretty easily. Convert the usb control messages into i2c read writes
in the implementation of the subdev, and implement a virtual i2c
master in the bridge, converting the register reads/writes back into
direct bridge dependent messages. Use i2c as a bus abstraction.

The subdev looks like an i2c device. The bridge translates.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
