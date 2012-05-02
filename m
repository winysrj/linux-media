Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.cambriumhosting.nl ([217.19.16.173]:45388 "EHLO
	relay01.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328Ab2EBOkD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 10:40:03 -0400
Received: from relay01.cambriumhosting.nl (localhost [127.0.0.1])
	by relay01.cambriumhosting.nl (Postfix) with ESMTP id 5725460000A1
	for <linux-media@vger.kernel.org>; Wed,  2 May 2012 16:32:20 +0200 (CEST)
Received: from [172.16.0.238] (82-197-206-135.dsl.cambrium.nl [82.197.206.135])
	(Authenticated sender: tk@tkteun.tweak.nl)
	by relay01.cambriumhosting.nl (Postfix) with ESMTPA id 444F0600009C
	for <linux-media@vger.kernel.org>; Wed,  2 May 2012 16:32:20 +0200 (CEST)
Message-ID: <4FA14574.5040603@tkteun.tweak.nl>
Date: Wed, 02 May 2012 16:32:20 +0200
From: Teun <tk@tkteun.tweak.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Error compiling tw68-v2 module (module_param / linux3.2)
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm having problems compiling the tw68-v2. I looked up the code from the 
error messages, but I don't know anything about making linux driver modules.
I can't find a lot about the module_param function, at least, not why 
this would be wrong.

Can anyone give any comment on this?

Thanks in advance!

Linux tkpc 3.2.0-2-amd64 #1 SMP Sun Mar 4 22:48:17 UTC 2012 x86_64 GNU/Linux

make -C /lib/modules/3.2.0-2-amd64/build M=/mnt/nfs/black/hw/tw68-v2 modules
make[1]: Entering directory `/usr/src/linux-headers-3.2.0-2-amd64'
CC [M] /mnt/nfs/black/hw/tw68-v2/tw68-video.o
/mnt/nfs/black/hw/tw68-v2/tw68-video.c:42:27: error: expected ‘)’ before 
‘int’
/mnt/nfs/black/hw/tw68-v2/tw68-video.c:43:31: error: expected ‘)’ before 
string constant
/mnt/nfs/black/hw/tw68-v2/tw68-video.c:44:24: error: expected ‘)’ before 
‘int’
/mnt/nfs/black/hw/tw68-v2/tw68-video.c:45:28: error: expected ‘)’ before 
string constant
/mnt/nfs/black/hw/tw68-v2/tw68-video.c:46:29: error: expected ‘)’ before 
‘int’
/mnt/nfs/black/hw/tw68-v2/tw68-video.c:47:33: error: expected ‘)’ before 
string constant
/mnt/nfs/black/hw/tw68-v2/tw68-video.c:48:35: error: expected ‘)’ before 
‘sizeof’
/mnt/nfs/black/hw/tw68-v2/tw68-video.c:49:25: error: expected ‘)’ before 
string constant


module_param(video_debug, int, 0644);
MODULE_PARM_DESC(video_debug, "enable debug messages [video]");
module_param(gbuffers, int, 0444);
MODULE_PARM_DESC(gbuffers, "number of capture buffers, range 2-32");
module_param(noninterlaced, int, 0644);
MODULE_PARM_DESC(noninterlaced, "capture non interlaced video");
module_param_string(secam, secam, sizeof(secam), 0644);
MODULE_PARM_DESC(secam, "force SECAM variant, either DK,L or Lc");

