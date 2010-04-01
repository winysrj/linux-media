Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2514 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab0DAIAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 04:00:47 -0400
Received: from tschai.localnet (cm-84.208.87.21.getinternet.no [84.208.87.21])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id o3180dEA072316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 1 Apr 2010 10:00:45 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: V4L-DVB drivers and BKL
Date: Thu, 1 Apr 2010 10:01:10 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011001.10500.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I just read on LWN that the core kernel guys are putting more effort into
removing the BKL. We are still using it in our own drivers, mostly V4L.

I added a BKL column to my driver list:

http://www.linuxtv.org/wiki/index.php/V4L_framework_progress#Bridge_Drivers

If you 'own' one of these drivers that still use BKL, then it would be nice
if you can try and remove the use of the BKL from those drivers.

The other part that needs to be done is to move from using the .ioctl file op
to using .unlocked_ioctl. Very few drivers do that, but I suspect almost no
driver actually needs to use .ioctl.

On the DVB side there seem to be only two sources that use the BKL:

linux/drivers/media/dvb/bt8xx/dst_ca.c: lock_kernel();
linux/drivers/media/dvb/bt8xx/dst_ca.c: unlock_kernel();
linux/drivers/media/dvb/dvb-core/dvbdev.c:      lock_kernel();
linux/drivers/media/dvb/dvb-core/dvbdev.c:              unlock_kernel();
linux/drivers/media/dvb/dvb-core/dvbdev.c:      unlock_kernel();

At first glance it doesn't seem too difficult to remove them, but I leave
that to the DVB experts.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
