Return-path: <linux-media-owner@vger.kernel.org>
Received: from as-10.de ([212.112.241.2]:41306 "EHLO mail.as-10.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0CGLjM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Mar 2010 06:39:12 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id D772D5E5B72
	for <linux-media@vger.kernel.org>; Sun,  7 Mar 2010 12:39:11 +0100 (CET)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SxqrVqXlsW40 for <linux-media@vger.kernel.org>;
	Sun,  7 Mar 2010 12:39:11 +0100 (CET)
Received: from gentoo.local (pD9E0FB3F.dip.t-dialin.net [217.224.251.63])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id AAE4C5E5B70
	for <linux-media@vger.kernel.org>; Sun,  7 Mar 2010 12:39:11 +0100 (CET)
Date: Sun, 7 Mar 2010 12:38:08 +0100
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-media@vger.kernel.org
Subject: v4l-dvb build problem with soc_camera
Message-ID: <20100307113808.GA12517@gentoo.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Same environment like in my previous mail:

/root/work/v4l-dvb/v4l/soc_camera.c:27:30: error: linux/pm_runtime.h: No such file or directory
/root/work/v4l-dvb/v4l/soc_camera.c: In function 'soc_camera_open':
/root/work/v4l-dvb/v4l/soc_camera.c:392: error: implicit declaration of function 'pm_runtime_enable'
/root/work/v4l-dvb/v4l/soc_camera.c:393: error: implicit declaration of function 'pm_runtime_resume'
/root/work/v4l-dvb/v4l/soc_camera.c:422: error: implicit declaration of function 'pm_runtime_disable'
/root/work/v4l-dvb/v4l/soc_camera.c: In function 'soc_camera_close':
/root/work/v4l-dvb/v4l/soc_camera.c:448: error: implicit declaration of function 'pm_runtime_suspend'
make[3]: *** [/root/work/v4l-dvb/v4l/soc_camera.o] Error 1
make[2]: *** [_module_/root/work/v4l-dvb/v4l] Error 2
make[1]: *** [default] Fehler 2
make: *** [all] Fehler 2
BR.
Halim

