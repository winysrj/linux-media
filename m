Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:43408 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbZCCVIq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 16:08:46 -0500
Received: by ewy25 with SMTP id 25so2511673ewy.37
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2009 13:08:43 -0800 (PST)
Message-ID: <49AD9C59.1050803@gmail.com>
Date: Tue, 03 Mar 2009 21:08:41 +0000
From: uTaR <utar101@gmail.com>
MIME-Version: 1.0
To: Eduard Huguet <eduardhc@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge NOVA-T 500 falls over after warm reboot
References: <49AD88BF.30507@gmail.com> <617be8890903031229n79f93882k63560cb4d17c6b33@mail.gmail.com>
In-Reply-To: <617be8890903031229n79f93882k63560cb4d17c6b33@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi,
>     Same here. I've been observing the same behaviour in the lastest
> times. I can't say exactly since when this happens, though.
> 
> I've observed that stopping mythbackend,  unloading the driver with
> 'rmmod dvb_usb_dib0700' and rebooting again seems to fix the problem.
> 
> By the dmesg it seems like, on a warm reboot, it fails to detect the
> card as 'warm' state (dmesg says it's 'cold'), so it attempts to load
> the firmware again, which fails and leaves the card in an unusable
> state.
> 
> Best regards,
>   Eduard

Thanks for the reply.

In my case the Nova is correctly identified as being in the "warm" state
after a reboot, however it still falls over either before I can even
start playing TV or within a minute or so of actually playing TV.









