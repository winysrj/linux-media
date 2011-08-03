Return-path: <linux-media-owner@vger.kernel.org>
Received: from bonnie-vm4.ifh.de ([141.34.50.21]:33892 "EHLO smtp.ifh.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566Ab1HCPdL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Aug 2011 11:33:11 -0400
Date: Wed, 3 Aug 2011 17:33:09 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: DiBxxxx: fixes for 3.1/3.0
Message-ID: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Would you please pull from

git://linuxtv.org/pb/media_tree.git for_v3.0

for the following to changesets:

[media] dib0700: protect the dib0700 buffer access
[media] DiBcom: protect the I2C bufer access

?

Those two changesets are fixing the remaining problems regarding the 
dma-on-stack-buffer-fix applied for the first time in 2.6.39, IIRC.

They should go to stable 3.0 (as they are in my tree) and they can be 
cherry-picked to 3.1.

We are preparing the same thing for 2.6.39 as the patches don't apply 
cleanly.

Thanks to Javier Marcet for his help during the debug-phase.

thanks and best regards,
--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
