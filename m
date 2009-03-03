Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:39273 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbZCCU3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 15:29:51 -0500
Received: by bwz26 with SMTP id 26so2534512bwz.37
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2009 12:29:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49AD88BF.30507@gmail.com>
References: <49AD88BF.30507@gmail.com>
Date: Tue, 3 Mar 2009 21:29:48 +0100
Message-ID: <617be8890903031229n79f93882k63560cb4d17c6b33@mail.gmail.com>
Subject: Re: Hauppauge NOVA-T 500 falls over after warm reboot
From: Eduard Huguet <eduardhc@gmail.com>
To: uTaR <utar101@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
    Same here. I've been observing the same behaviour in the lastest
times. I can't say exactly since when this happens, though.

I've observed that stopping mythbackend,  unloading the driver with
'rmmod dvb_usb_dib0700' and rebooting again seems to fix the problem.

By the dmesg it seems like, on a warm reboot, it fails to detect the
card as 'warm' state (dmesg says it's 'cold'), so it attempts to load
the firmware again, which fails and leaves the card in an unusable
state.

Best regards,
  Eduard



2009/3/3 uTaR <utar101@gmail.com>:
>
> Just thought I would report some unusual behaviour I am seeing on my
> Nova-T 500.  Basically the card works fine with a cold boot but falls
> over rapidly after a warm reboot.
>
> This started after I compiled the latest v4l source tree (as at 22 Feb
> 09) due to me adding a Tevii S650 to my system.  At first I thought it
> was the Tevii which was causing the problem but testing showed the Nova
> falls over irrespective of if the Tevii is attached.
>
> I'm running Ubuntu with 2.6.27-11 and I never had this issue with v4l
> running "out of the box."
>
> Sample of the log after the Nova falls over follows:
>
> [  117.920002] ehci_hcd 0000:05:00.2: force halt; handhake f88f4c14
> 00004000 00000000 -> -110
> [  129.412342] mt2060 I2C write failed
> [  132.412253] mt2060 I2C write failed
> [  133.713596] mt2060 I2C write failed
> [  136.712264] mt2060 I2C write failed
> [  138.004603] mt2060 I2C write failed
> [  141.004564] mt2060 I2C write failed
> [  147.177361] mt2060 I2C write failed
> [  150.176124] mt2060 I2C write failed
> [  171.026988] mt2060 I2C write failed
> [  171.041701] mt2060 I2C write failed (len=2)
> [  171.041824] mt2060 I2C write failed (len=6)
> [  171.041922] mt2060 I2C read failed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
