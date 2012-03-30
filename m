Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50874 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578Ab2C3T7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Mar 2012 15:59:41 -0400
Received: by yhmm54 with SMTP id m54so609149yhm.19
        for <linux-media@vger.kernel.org>; Fri, 30 Mar 2012 12:59:40 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 Mar 2012 21:59:40 +0200
Message-ID: <CACHinyEr=cGYs29YOj1B38GCLtA_9DddUW7GQMCAj5GUg5C0yA@mail.gmail.com>
Subject: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid no longer works properly
 with kernel 3.3
From: Thomas Steinborn <thestonewell@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

hope you can point me into the right direction.

I have got 2 Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid cards in my
system. They worked perfectly fine with kernel 3.2 (e.g. the last
Fedora 16 kernel that worked is 3.2.10-3.fc16.x86_64).

As soon as Fedora went kernel 3.3 (kernel 3.3.0-4.fc16.x86_64) the
problems started. The cards are still recognized and you can tune
them. But trying to watch any DVB-S (or DVB-S2) channel just results
in block artefacts, loss of audio-video sychronization etc. The only
thing /var/log/messages or dmesg tells me is:


cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)

Same machine, same everything, just rebooting back into the 3.2 kernel
the problem is gone.

Any idea where I could start my investigation, please?

Thanks
Thomas
