Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20787 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab2CVTbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 15:31:31 -0400
Message-ID: <4F6B7E10.2010400@kc.rr.com>
Date: Thu, 22 Mar 2012 14:31:28 -0500
From: Joe Henley <joehenley@kc.rr.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: hdpvr.ko for new device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a very new Hauppauge HD-PVR for which the drivers in git do not 
work.  I'm sure it must be because the device is so new.  I'd be happy 
to work with/test drivers for anyone who will update the drivers.

Hardware info:
HPDVR model #: SL-1212-V5.5-US
       serial #: 00a7d2a1
       usb device code:  2040:4903

Firmware:  successfully updated/reverted to: 1.5.7

OS info:  Elrepo kernel-ml Version 2.6.35-14.1.el5.elrepo
            updated v4l-dvb drivers from git on 3/21/12

Problem:  When I plug it in, it shows up in lsusb, but it doesn't work. 
  The hdpvr driver is not loaded.  If I try to force the driver to load 
(using modprobe hdpvr) there is no error message, but lsmod shows that 
it has not loaded.

Eventually, I'd like to get this working in MythTV.

Thanks for any help.

Joe Henley
