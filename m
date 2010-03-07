Return-path: <linux-media-owner@vger.kernel.org>
Received: from as-10.de ([212.112.241.2]:41399 "EHLO mail.as-10.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0CGLkb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Mar 2010 06:40:31 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id 61FFA5E5B71
	for <linux-media@vger.kernel.org>; Sun,  7 Mar 2010 12:33:30 +0100 (CET)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qRT1P2B69SjU for <linux-media@vger.kernel.org>;
	Sun,  7 Mar 2010 12:33:30 +0100 (CET)
Received: from gentoo.local (pD9E0FB3F.dip.t-dialin.net [217.224.251.63])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id 371CC5E5B70
	for <linux-media@vger.kernel.org>; Sun,  7 Mar 2010 12:33:30 +0100 (CET)
Date: Sun, 7 Mar 2010 12:32:27 +0100
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-media@vger.kernel.org
Subject: problem compiling modoule mt9t031 in current v4l-dvb-hg
Message-ID: <20100307113227.GA8089@gentoo.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Folks,
I was not able to build v4l-dvb from hg (checked out today).


/root/work/v4l-dvb/v4l/mt9t031.c:729: error: unknown field 'runtime_suspend' specified in initializer
/root/work/v4l-dvb/v4l/mt9t031.c:730: error: unknown field 'runtime_resume' specified in initializer
/root/work/v4l-dvb/v4l/mt9t031.c:730: warning: initialization from incompatible pointer type
make[3]: *** [/root/work/v4l-dvb/v4l/mt9t031.o] Error 1
make[2]: *** [_module_/root/work/v4l-dvb/v4l] Error 2
make[1]: *** [default] Fehler 2
make: *** [all] Fehler 2
Kernel 2.6.31 (x86_64)
regards
Halim

