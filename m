Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vrodic@gmail.com>) id 1KvU5n-00064Z-IO
	for linux-dvb@linuxtv.org; Thu, 30 Oct 2008 10:45:28 +0100
Received: by wf-out-1314.google.com with SMTP id 27so523734wfd.17
	for <linux-dvb@linuxtv.org>; Thu, 30 Oct 2008 02:45:23 -0700 (PDT)
Message-ID: <8ccf2e9c0810300245v64954641yafe9e7b29f243e84@mail.gmail.com>
Date: Thu, 30 Oct 2008 10:45:23 +0100
From: "Vedran Rodic" <vrodic@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Gigabyte U7000 (dvb_usb_dib0700) power management
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

Hello.

I have a gigabyte u7000 USB dvb-t receiver with dib0700 and mt2060.

It's working fine (debian linux 2.6.26-1 stock kernel, firmware
dvb-usb-dib0700-1.10.fw or dvb-usb-dib0700-03-pre1.fw), but the device
is not powering down when the frontend and other device files are
closed.
The device has a LED diode indicating power state and it's warm all
the time in Linux after the driver has been loaded. In  Windows the
LED is only on when the TV Viewing software is used, and the device is
cold when not used.

I've tried unloading all dvb/dib/tuner etc modules but the LED is
still on. Are there any sysfs/proc control files to power it down when
not used? Should I try the latest v4l-dvb tree?

Thanks,
Vedran

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
