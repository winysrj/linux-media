Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.22]:48140 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751138Ab0LYOis (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 09:38:48 -0500
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: linux-media@vger.kernel.org
Subject: missing Patch in v4l-dvb hg
Date: Sat, 25 Dec 2010 15:38:39 +0100
Cc: dougsland@redhat.com, ian@iarmst.demon.co.uk
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012251538.40204.martin.dauskardt@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Douglas,

you backported a few ivtv patches from June 2010 to v4l-dvb hg:
http://linuxtv.org/hg/v4l-
dvb/log/abd3aac6644e/linux/drivers/media/video/ivtv/ivtv-streams.c

Unfortunately one patch is missing, which is important for proper function:
http://git.linuxtv.org/media_tree.git?a=commit;h=f06b9bd4c62ef93f9467a1432acf2efa84aa3456

Could you please add it?

Greets,
Martin
