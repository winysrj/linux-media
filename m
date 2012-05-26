Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36487 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab2EZLcS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 07:32:18 -0400
Message-ID: <4FC0BF3E.2080509@iki.fi>
Date: Sat, 26 May 2012 14:32:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: RC-core ".driver_name"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there any reason RC-core .driver_name should be set as a module name 
which registers remote?

http://lxr.free-electrons.com/source/drivers/media/rc/rc-main.c

I see .driver_name is passed to the hotplug:
if (dev->driver_name)
     ADD_HOTPLUG_VAR("DRV_NAME=%s", dev->driver_name);


ir-keytable command shows that name:
# ir-keytable
     Driver af9015, table rc-digitalnow-tinytwin


I would like to use set name same as the device name - not the driver 
name. And af9015 is not the module name, correct is IMHO dvb_usb_af9015.

regards
Antti
-- 
http://palosaari.fi/
