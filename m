Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:42432 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbbFWKmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 06:42:16 -0400
Received: from dc8secmta2.synopsys.com (dc8secmta2.synopsys.com [10.13.218.202])
	by smtprelay.synopsys.com (Postfix) with ESMTP id 9999B24E0B3E
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2015 03:42:16 -0700 (PDT)
Received: from dc8secmta2.internal.synopsys.com (dc8secmta2.internal.synopsys.com [127.0.0.1])
	by dc8secmta2.internal.synopsys.com (Service) with ESMTP id 8C389A4112
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2015 03:42:16 -0700 (PDT)
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
	by dc8secmta2.internal.synopsys.com (Service) with ESMTP id 735FFA4102
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2015 03:42:16 -0700 (PDT)
Received: from mailhost.synopsys.com (localhost [127.0.0.1])
	by mailhost.synopsys.com (Postfix) with ESMTP id 661AEEA6
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2015 03:42:16 -0700 (PDT)
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2-vip.internal.synopsys.com [10.12.239.238])
	by mailhost.synopsys.com (Postfix) with ESMTP id 5EEA3EA5
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2015 03:42:16 -0700 (PDT)
Message-ID: <55893803.6080407@synopsys.com>
Date: Tue, 23 Jun 2015 11:42:11 +0100
From: Joao Pinto <Joao.Pinto@synopsys.com>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: Request for help: HDLCD Controller
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I am developing a system in which the video support is made through two ARM'
HDLCD Controller and two TDA998x HDMI PHYs.

When I try to load ARM' HDLCD driver (hdlcd), it fails when it tries to bind
with the drm subsystem:

root@genericarmv8:~# modprobe hdlcd
[drm] found ARM HDLCD version r0p0
hdlcd 7ff50000.hdlcd: master bind failed: -517
[drm] found ARM HDLCD version r0p0
hdlcd 7ff60000.hdlcd: master bind failed: -517

The kernel has the controllers mapped in the I2C bus:

root@genericarmv8:/sys/bus/i2c/drivers/tda998x# ls -l
total 0
lrwxrwxrwx    1 root     root             0 Nov  6 00:44 0-0070 ->
../../../../devices/platform/7ffa0000.i2c/i2c-0/0-0070
lrwxrwxrwx    1 root     root             0 Nov  6 00:44 0-0071 ->
../../../../devices/platform/7ffa0000.i2c/i2c-0/0-0071
--w-------    1 root     root          4096 Nov  6 00:44 bind
--w-------    1 root     root          4096 Nov  6 00:44 uevent
--w-------    1 root     root          4096 Nov  6 00:44 unbind

I know that this driver is not supported in the mainline yet, but did anyone
face a similar problem?

Thank you very much for your time!

Regards,
Joao
