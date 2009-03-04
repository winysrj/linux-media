Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:51527 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZCDI0r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 03:26:47 -0500
Received: by fxm24 with SMTP id 24so2767735fxm.37
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2009 00:26:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49AD9C59.1050803@gmail.com>
References: <49AD88BF.30507@gmail.com>
	 <617be8890903031229n79f93882k63560cb4d17c6b33@mail.gmail.com>
	 <49AD9C59.1050803@gmail.com>
Date: Wed, 4 Mar 2009 09:26:44 +0100
Message-ID: <617be8890903040026t679991bmf69b0076ff5bb64e@mail.gmail.com>
Subject: Re: Hauppauge NOVA-T 500 falls over after warm reboot
From: Eduard Huguet <eduardhc@gmail.com>
To: uTaR <utar101@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Have you tried rmmoding the module (dvb_usb_dib0700) and reloading it?
I think that it was in such a case where it then wrongly detected the
card as 'cold', attempting to reload it, which failed.



2009/3/3 uTaR <utar101@gmail.com>:
>
>> Hi,
>>     Same here. I've been observing the same behaviour in the lastest
>> times. I can't say exactly since when this happens, though.
>>
>> I've observed that stopping mythbackend,  unloading the driver with
>> 'rmmod dvb_usb_dib0700' and rebooting again seems to fix the problem.
>>
>> By the dmesg it seems like, on a warm reboot, it fails to detect the
>> card as 'warm' state (dmesg says it's 'cold'), so it attempts to load
>> the firmware again, which fails and leaves the card in an unusable
>> state.
>>
>> Best regards,
>>   Eduard
>
> Thanks for the reply.
>
> In my case the Nova is correctly identified as being in the "warm" state
> after a reboot, however it still falls over either before I can even
> start playing TV or within a minute or so of actually playing TV.
>
>
>
>
>
>
>
>
>
>
