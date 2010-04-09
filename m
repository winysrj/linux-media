Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:57847 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab0DILeX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Apr 2010 07:34:23 -0400
Received: by fg-out-1718.google.com with SMTP id 19so131370fgg.1
        for <linux-media@vger.kernel.org>; Fri, 09 Apr 2010 04:34:21 -0700 (PDT)
Date: Fri, 9 Apr 2010 13:36:04 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-media@vger.kernel.org, uris@siano-ms.com
Subject: remote control for idVendor=2040, idProduct=5500 Siano MDTV
Message-ID: <20100409113604.GD3468@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am using this stick with a 2.6.33.2 kernel kernel.org) and kaffeine. Works nicely so far
but the infrared remote does not work.

I am quite happy to apply pacthes or experimental dirvers - are there any? Is there any
documentation that woud allow me to write the code?

Apr  8 15:05:23 localhost kernel: [ 1204.812906] usb 5-6: Product: WinTV MiniStick
Apr  8 15:05:23 localhost kernel: [ 1204.812908] usb 5-6: Manufacturer: Hauppauge Computer Works
Apr  8 15:05:23 localhost kernel: [ 1204.812910] usb 5-6: SerialNumber: f069684c
Apr  8 15:05:23 localhost kernel: [ 1204.815314] usb 5-6: firmware: requesting sms1xxx-hcw-55xxx-dvbt-02.fw
Apr  8 15:05:24 localhost kernel: [ 1205.396048] smscore_set_device_mode: firmware download success: sms1xxx-hcw-55xxx-dvbt-02.fw
Apr  8 15:05:24 localhost kernel: [ 1205.396478] DVB: registering new adapter (Hauppauge WinTV MiniStick)
Apr  8 15:05:24 localhost kernel: [ 1205.397538] DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...


Regards
Richard
