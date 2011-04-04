Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39680 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab1DDHiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 03:38:18 -0400
Received: by fxm17 with SMTP id 17so3701645fxm.19
        for <linux-media@vger.kernel.org>; Mon, 04 Apr 2011 00:38:16 -0700 (PDT)
From: KL <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [2.6.39] fixes - pull request
Date: Mon, 4 Apr 2011 09:37:52 +0200
Cc: linux-media@vger.kernel.org
References: <201104031823.20183.pboettcher@kernellabs.com>
In-Reply-To: <201104031823.20183.pboettcher@kernellabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104040937.52719.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

would you please also pull from 

http://git.linuxtv.org/pb/media_tree.git fixes/dib0700.dma_buffers

for 

[media] DiB0700: get rid of on-stack dma buffers

Thanks,
--
Patrick


On Sunday 03 April 2011 18:23:19 Patrick Boettcher wrote:

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
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
