Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62785 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab2HUPlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 11:41:40 -0400
Received: by lagy9 with SMTP id y9so3976880lag.19
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 08:41:38 -0700 (PDT)
Message-ID: <5033AC22.608@iki.fi>
Date: Tue, 21 Aug 2012 18:41:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "M. Fletcher" <mpf30@cam.ac.uk>
CC: linux-media@vger.kernel.org
Subject: Re: Unable to load dvb-usb-rtl2832u driver in Ubuntu 12.04
References: <00f301cd7fb1$b596f2c0$20c4d840$@cam.ac.uk> <5033A9C3.7090501@iki.fi> <00f401cd7fb2$d402c530$7c084f90$@cam.ac.uk>
In-Reply-To: <00f401cd7fb2$d402c530$7c084f90$@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2012 06:37 PM, M. Fletcher wrote:
>> It should be inside drivers/media/usb/dvb-usb-v2/ modinfo dvb_usb_rtl28xxu
> should list it.
>
> Correct, it was in drivers/media/usb/dvb-usb-v2/
> modinfo gives the expected output
>
>> Also it is highly possible your device usb id is not known >by driver, you
> should add it, easiest is just replace some existing rtl2832u device id.
>
> Can you please advise how I do this? lsusb gives my device ID as 185b:0680

Open the rtl28xxu.c file and find line:
	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK,
replace it:
	{ DVB_USB_DEVICE(0x185b, 0x0680,

Compile and install.

Enable debugs:
#modprobe dvb_usb_rtl28xxu; echo -n 'module dvb_usb_rtl28xxu +p' > 
/sys/kernel/debug/dynamic_debug/control

plug stick in and look what dmesg says. With a good luck there is 
supported RF-tuner and it works, but most likely there is some RF-tuner 
which is not supported and it does not work.


regards
Antti

-- 
http://palosaari.fi/
