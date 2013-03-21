Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46909 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3CUSQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 14:16:04 -0400
Received: by mail-ee0-f48.google.com with SMTP id t10so1930119eei.35
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 11:16:02 -0700 (PDT)
Message-ID: <514B4E97.6010903@googlemail.com>
Date: Thu, 21 Mar 2013 19:16:55 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: media-tree build is broken
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

...
Kernel: arch/x86/boot/bzImage is ready  (#2)
ERROR: "__divdi3" [drivers/media/common/siano/smsdvb.ko] undefined!
make[1]: *** [__modpost] Fehler 1
make: *** [modules] Fehler 2


Mauro, I assume this is caused by one of the recent Siano patches ?

Regards,
Frank
