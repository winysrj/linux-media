Return-path: <mchehab@pedra>
Received: from as-10.de ([212.112.241.2]:36099 "EHLO mail.as-10.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab0HXIpR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 04:45:17 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id 67FDC33A687
	for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 10:45:15 +0200 (CEST)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kp9VsYbuVaKt for <linux-media@vger.kernel.org>;
	Tue, 24 Aug 2010 10:45:15 +0200 (CEST)
Received: from gentoo.local (pD9E3C096.dip.t-dialin.net [217.227.192.150])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id 176AE33A669
	for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 10:45:15 +0200 (CEST)
Date: Tue, 24 Aug 2010 10:45:21 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-media@vger.kernel.org
Subject: bugreport: strange issues in tda8261 frontend (missing symbols
 etc).
Message-ID: <20100824084521.GB8417@gentoo.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi List,
1. The module adds 
MODULE_PARM_DESC(verbose, "Set verbosity level");
but doesn't declare the needed variables or uses this parameter
somewhere.
This ends in missing symbol when trying to specify that parameter when
loading the frontend.

2. The module logs many lines when tuning to a new channel.
This results in fast growing big logs in /var/log (several mb's ad a
day).

Here some lines of the log:
Aug 24 07:23:57 vdr kernel: [44045.944177] tda8261_get_frequency: Frequency=1880000
Aug 24 07:23:57 vdr kernel: [44045.952037] tda8261_get_bandwidth: Bandwidth=40000000
Aug 24 07:24:04 vdr kernel: [44052.132637] tda8261_get_bandwidth: Bandwidth=40000000
Aug 24 07:24:04 vdr kernel: [44052.136747] tda8261_get_bandwidth: Bandwidth=40000000
Aug 24 07:24:04 vdr kernel: [44052.138596] tda8261_set_state: Step size=1, Divider=1000, PG=0x798 (1944)
Aug 24 07:24:04 vdr kernel: [44052.138883] tda8261_set_state: Waiting to Phase LOCK
Aug 24 07:24:04 vdr kernel: [44052.160156] tda8261_get_status: Tuner Phase Locked
Aug 24 07:24:04 vdr kernel: [44052.160163] tda8261_set_state: Tuner Phase locked: status=1
Aug 24 07:24:04 vdr kernel: [44052.160168] tda8261_set_frequency: Frequency=1944000
Aug 24 07:24:04 vdr kernel: [44052.160173] tda8261_get_frequency: Frequency=1944000
Aug 24 07:24:04 vdr kernel: [44052.168031] tda8261_get_bandwidth: Bandwidth=40000000
Aug 24 07:24:09 vdr kernel: [44057.016717] tda8261_get_bandwidth: Bandwidth=40000000
Aug 24 07:24:09 vdr kernel: [44057.021165] tda8261_get_bandwidth: Bandwidth=40000000
Aug 24 07:24:09 vdr kernel: [44057.023052] tda8261_set_state: Step size=1, Divider=1000, PG=0x60c (1548)
Aug 24 07:24:09 vdr kernel: [44057.023305] tda8261_set_state: Waiting to Phase LOCK
Aug 24 07:24:09 vdr kernel: [44057.044169] tda8261_get_status: Tuner Phase Locked
Aug 24 07:24:09 vdr kernel: [44057.044177] tda8261_set_state: Tuner Phase locked: status=1
Aug 24 07:24:09 vdr kernel: [44057.044182] tda8261_set_frequency: Frequency=1548000
Aug 24 07:24:09 vdr kernel: [44057.044187] tda8261_get_frequency: Frequency=1548000
Aug 24 07:24:09 vdr kernel: [44057.053034] tda8261_get_bandwidth: Bandwidth=40000000

Kernel 2.6.34 was used on that system.
Thx.
Halim


