Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.imavis.com ([85.94.219.26]:48134 "EHLO mail.imavis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab1JNOLw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 10:11:52 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.imavis.com (Postfix) with ESMTP id 9F0671C0CB1F
	for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 16:00:44 +0200 (CEST)
Received: from mail.imavis.com ([127.0.0.1])
	by localhost (phx1-ss-2-lb.cnet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JE+JnssCap2u for <linux-media@vger.kernel.org>;
	Fri, 14 Oct 2011 16:00:44 +0200 (CEST)
Received: from augusto-laptop.localnet (ldap.imavis.com [89.96.73.90])
	by mail.imavis.com (Postfix) with ESMTPSA id 1C9881C0CB1D
	for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 16:00:44 +0200 (CEST)
From: Augusto Destrero <destrero@imavis.com>
To: linux-media@vger.kernel.org
Subject: bttv-gpio.c
Date: Fri, 14 Oct 2011 16:11:49 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110141611.50034.destrero@imavis.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm trying to understand how to control GPIOs on a bt878 card, as described in 
this earlier post:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/39342

I came across the file bttv-gpio.c in drivers/media/video/bt8xx, and the 
starting comment seems what I'm looking for:

"sysfs-based sub driver interface for bttv mainly intented for gpio access"

But I cannot understand how to enable this sysfs based access. Is there a 
kernel configuration somewhere? Where the gpios are supposed to show up in 
/sys?

Thank you in advance for your help and excuse me if my question is trivial.

-- 
Augusto Destrero, PhD
