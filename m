Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm1-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.27]:28713
	"HELO nm1-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752508Ab1IXWrz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 18:47:55 -0400
Message-ID: <4E7E5E19.1070602@sbcglobal.net>
Date: Sat, 24 Sep 2011 18:47:53 -0400
From: Scott <pickle136@sbcglobal.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Media Build Git Master is Broke
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Im trying to build the master for the build media git (specifically for 
the driver for the hdpvr).

First error is from a patch is (altera patch):
1 out of 1 hunk FAILED -- saving rejects to file 
drivers/media/video/cx23885/cx23885-cards.c.rej

I commented out the patch from backports/backports.txt

Second error then is:
File not found: ./../linux/drivers/staging/tm6000/Kconfig at 
./scripts/make_kconfig.pl line 284, <GEN59> line 36.

Im stumped as how to fix this, it almost seems this should be in the git 
or created automatically.
Hope someone can help. Thanks.

Scott
