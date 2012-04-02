Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53727 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2DBIAM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 04:00:12 -0400
Received: by pbcun15 with SMTP id un15so4235724pbc.19
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 01:00:12 -0700 (PDT)
Message-ID: <4F795C8B.4090801@googlemail.com>
Date: Mon, 02 Apr 2012 10:00:11 +0200
From: Thomas Steinborn <thestonewell@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid no longer works properly
 with kernel 3.3
References: <CACHinyEr=cGYs29YOj1B38GCLtA_9DddUW7GQMCAj5GUg5C0yA@mail.gmail.com>
In-Reply-To: <CACHinyEr=cGYs29YOj1B38GCLtA_9DddUW7GQMCAj5GUg5C0yA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I got pointed to:

http://www.spinics.net/lists/linux-media/msg45592.html

Has this been applied to the kernel since?

Thomas

On 30.03.2012 21:59, Thomas Steinborn wrote:
> Hi,
>
> hope you can point me into the right direction.
>
> I have got 2 Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid cards in my
> system. They worked perfectly fine with kernel 3.2 (e.g. the last
> Fedora 16 kernel that worked is 3.2.10-3.fc16.x86_64).
>
> As soon as Fedora went kernel 3.3 (kernel 3.3.0-4.fc16.x86_64) the
> problems started. The cards are still recognized and you can tune
> them. But trying to watch any DVB-S (or DVB-S2) channel just results
> in block artefacts, loss of audio-video sychronization etc. The only
> thing /var/log/messages or dmesg tells me is:
>
>
> cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)
>
> Same machine, same everything, just rebooting back into the 3.2 kernel
> the problem is gone.
>
> Any idea where I could start my investigation, please?
>
> Thanks
> Thomas
