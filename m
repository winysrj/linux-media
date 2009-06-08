Return-path: <linux-media-owner@vger.kernel.org>
Received: from malik.acsalaska.net ([209.112.173.227]:52710 "EHLO
	malik.acsalaska.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZFHIBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 04:01:00 -0400
Received: from [192.168.1.3] (66-230-83-240-rb1.fai.dsl.dynamic.acsalaska.net [66.230.83.240])
	by malik.acsalaska.net (8.14.1/8.14.1) with ESMTP id n587eVtb058889
	for <linux-media@vger.kernel.org>; Sun, 7 Jun 2009 23:40:32 -0800 (AKDT)
	(envelope-from rogerx@sdf.lonestar.org)
Subject: s5h1411_readreg: readreg error (ret == -5)
From: Roger <rogerx@sdf.lonestar.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 07 Jun 2009 23:40:30 -0800
Message-Id: <1244446830.3797.6.camel@localhost2.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From looking at "linux/drivers/media/dvb/frontends/s5h1411.c",  The
s5h1411_readreg wants to see "2" but is getting "-5" from the i2c bus.

--- Snip ---

s5h1411_readreg: readreg error (ret == -5)
pvrusb2: unregistering DVB devices
device: 'dvb0.net0': device_unregister

--- Snip ---

What exactly does this mean?



$ uname -a
Linux localhost2.local 2.6.29-gentoo-r4Y #9 SMP PREEMPT Tue Jun 2
03:38:16 AKDT 2009 i686 Pentium III (Coppermine) GenuineIntel GNU/Linux

Using pvrusb2 module which requests firmware to initialize a Hauppauge
HVR-1950 device.

-- 
Roger
http://rogerx.freeshell.org

