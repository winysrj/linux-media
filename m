Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41239 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1DCQXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 12:23:52 -0400
Received: by wwa36 with SMTP id 36so5664764wwa.1
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 09:23:50 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [2.6.39] fixes - pull request
Date: Sun, 3 Apr 2011 18:23:19 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104031823.20183.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

I cleaned my mailbox and collected some small fixes for 2.6.39 and for other 
version (stable is Cc'd in that case).

Please pull from (sorry for the wrong branch name)

http://git.linuxtv.org/pb/media_tree.git staging/for_v2.6.39

for 

[PATCH] Fix dependencies for Technisat USB2.0 DVB-S/S2
[PATCH] [media] dib0700: fix possible NULL pointer...
FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci
DIB0700: fix typo in dib0700_devices.c

Thanks,
--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
