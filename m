Return-path: <mchehab@pedra>
Received: from mail-px0-f173.google.com ([209.85.212.173]:65351 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab1EEM2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 08:28:44 -0400
Received: by pxi16 with SMTP id 16so1582326pxi.4
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 05:28:44 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 May 2011 08:28:44 -0400
Message-ID: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com>
Subject: CX24116 i2c patch
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

> Subject: [media] cx24116: add config option to split firmware download
> Author:  Antti Palosaari <crope@iki.fi>
> Date:    Wed Apr 27 21:03:07 2011 -0300
>
> It is very rare I2C adapter hardware which can provide 32kB I2C write
> as one write. Add .i2c_wr_max option to set desired max packet size.
> Split transaction to smaller pieces according to that option.

This is none-sense. I'm naking this patch, please unqueue, regress or whatever.

The entire point of the i2c message send is that the i2c drivers know
nothing about the host i2c implementation, and they should not need
to. I2C SEND and RECEIVE are abstract and require no knowledge of the
hardware. This is dangerous and generates non-atomic register writes.
You cannot guarantee that another thread isn't reading/writing to
other registers in the part - breaking the driver.

Please fix the host controller to split the i2c messages accordingly
(and thus keeping the entire transaction atomic).

This is the second time I've seen the 'fix' to a problem by patching
the i2c driver. Fix the i2c bridge else we'll see this behavior
spreading to multiple i2c driver. It's just wrong.

Best,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
