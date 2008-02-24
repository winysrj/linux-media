Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hs-out-0708.google.com ([64.233.178.250])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simbloke@googlemail.com>) id 1JTKCV-0005mJ-LN
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 17:59:43 +0100
Received: by hs-out-0708.google.com with SMTP id 54so862808hsz.1
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 08:59:39 -0800 (PST)
Message-ID: <cc22fa3b0802240859s36d43938v5acedcece52de49a@mail.gmail.com>
Date: Sun, 24 Feb 2008 16:59:38 +0000
From: "Simeon Walker" <simbloke@googlemail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Perfect kernel/drivers for the Nova-T stick
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

No, this isn't a question, for me I have the answer, and it is
2.6.22.18, the kernel drivers and the latest firmware.

I am using Ubuntu Gutsy and started with their included 2.6.22 kernel.
When I got the Nova-T stick (now two) I tried the stock Ubuntu kernel
with no luck. I then tried the linux-dvb drivers with the stock
kernel. The drivers worked but there was massive stream corruption.

Since then I tried 2.6.23, 2.6.23.13, 2.6.24 (inc .1 and .2). With all
these versions I have had the dvb-usb driver sometimes complaining
about the stick being on a USB 1.1 bus, a reboot always fixed that.
All these version had some problems with mt2060 i2c errors. Sometimes
I would get USB disconnects, the driver would reload but MythTV
doesn't even notice it's not recording anymore.

Finally, I don't know why, I tried compiling the latest 2.6.22 kernel.
The differences are:
 - There is no stream corruption like the Ubuntu 2.6.22 kernel.
 - USB2 mode works on every boot.
 - There are no USB disconnects.
 - There are no I2C errors.
The system has been completely stable for for two weeks with not
single instance of the previous errors.

Is it just me or has anyone else had luck with this kernel version?

Sim

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
