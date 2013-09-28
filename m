Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53241 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3I1SjP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Sep 2013 14:39:15 -0400
Received: from [192.168.2.100] ([93.218.116.97]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0MWwp6-1VKXtV2PH2-00VzL1 for
 <linux-media@vger.kernel.org>; Sat, 28 Sep 2013 20:39:13 +0200
Message-ID: <5247224B.7050507@rempel-privat.de>
Date: Sat, 28 Sep 2013 20:39:07 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
	USB list <linux-usb@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: Cannot shutdown power use from built in webcam in thinkpad T530
 questions]
References: <20130922193102.GA28515@merlins.org> <Pine.LNX.4.44L0.1309221623390.3257-100000@netrider.rowland.org> <20130922203622.GB28515@merlins.org> <523FFA03.7050404@rempel-privat.de> <20130928180811.GD3177@merlins.org>
In-Reply-To: <20130928180811.GD3177@merlins.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.09.2013 20:08, schrieb Marc MERLIN:
> On Mon, Sep 23, 2013 at 10:21:23AM +0200, Oleksij Rempel wrote:
>>> Understood, just making sure this was still potentially useful considering
>>> what I found out since my last message.
>>
>> Which version of powertop are you actually using? None of current
> 
> The latest, i.e. 2.4.
> 
>> versions would show you Watt usage for devices.
> 
> Sure it does :)
> 
> Summary: 3182.2 wakeups/second,  82.5 GPU ops/seconds, 0.0 VFS ops/sec and 33.5%
> 
> Power est.              Usage       Events/s    Category       Description
>   9.82 W    100.0%                      Device         USB device: Yubico Yubike
>   2.67 W      4.1 ms/s      43.2        Process        /usr/bin/pulseaudio --sta
>   2.58 W    100.0%                      Device         USB device: Integrated Ca
>   2.35 W    100.0%                      Device         USB device: BCM20702A0 (B
>   2.32 W     32.9%                      Device         Display backlight
>   1.39 W    100.0%                      Device         Radio device: btusb
>   343 mW    100.0%                      Device         Radio device: thinkpad_ac

ah ok, i see, you right. In usb.cpp:
double usbdevice::power_usage(struct result_bundle *result, struct
parameter_bundle *bundle)
{
        double power;
        double factor;
        double util;

        if (rootport || !cached_valid)
                return 0.0;


        power = 0;
        factor = get_parameter_value(index, bundle);
        util = get_result_value(r_index, result);

        power += util * factor / 100.0;

        return power;
}



but, if i understand it correctly, this values are not provided by usb.
If you start "powertop --calibrate" it will switch on/off some devices
and measure global power usage.

-- 
Regards,
Oleksij
