Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4.bt.bullet.mail.ukl.yahoo.com ([217.146.183.202]:26741 "HELO
	nm4.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751816Ab1HPVuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 17:50:09 -0400
Received: from volcano.underworld (volcano.underworld [192.168.0.3])
	by wellhouse.underworld (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p7GLo3oT032390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 22:50:06 +0100
Message-ID: <4E4AE60B.4050903@yahoo.com>
Date: Tue, 16 Aug 2011 22:50:03 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Locking problem between em28xx and em28xx-dvb modules - Part 2
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been looking deeper into the em28xx and em28xx-dvb modules, and I'm 
concerned that there are some races and resource leaks inherent in the current code:

a) Shouldn't em28xx_init_extension() and em28xx_add_into_devlist() be unified 
into a single function? Otherwise, consider someone plugging a DVB adapter into 
a host when the em28xx-dvb module is not yet loaded:

- em28xx_init_dev() adds new device to list.
- em28xx-dvb module registers itself, and initialises every device in the list 
(including our new one).
- em28xx_init_dev() iterates over the list of extensions (including em28xx-dvb) 
with the new device.

At this point, dvb_init() has been called twice for our new device, resulting in 
a leaked struct em28xx_dvb.

b) When em28xx_init_dev() returns something != 0, em28xx_usb_probe() frees the 
struct em28xx and exits without calling usb_put_dev().

c) There are many ways that em28xx_init_dev() can return something != 0, and not 
all of them release the V4L2 device or I2C device.

Am I understanding this code correctly, please? I can obviously extend my patch 
accordingly - it is currently running without any obvious problems, but I only 
have one DVB adapter and none that uses the ALSA extension.

Cheers,
Chris

