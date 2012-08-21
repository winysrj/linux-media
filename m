Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36017 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab2HUPbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 11:31:32 -0400
Received: by lbbgj3 with SMTP id gj3so48696lbb.19
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 08:31:31 -0700 (PDT)
Message-ID: <5033A9C3.7090501@iki.fi>
Date: Tue, 21 Aug 2012 18:31:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "M. Fletcher" <mpf30@cam.ac.uk>
CC: linux-media@vger.kernel.org
Subject: Re: Unable to load dvb-usb-rtl2832u driver in Ubuntu 12.04
References: <00f301cd7fb1$b596f2c0$20c4d840$@cam.ac.uk>
In-Reply-To: <00f301cd7fb1$b596f2c0$20c4d840$@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2012 06:29 PM, M. Fletcher wrote:
> Apologies for the confusion. Having done more digging I think the
> dvb_usb_rtl2832u module was added by the package download from here
> http://www.dfragos.me/2011/11/installation-of-the-rt2832u-driver-in-linux/.
> This is confirmed by looking through the corresponding 'MakeFile'. I have
> therefore removed references to dvb_usb_rtl2832u from
> /lib/modules/3.2.0-29-generic/kernel/drivers/media/usb/dvb-usb.
>
> I have also performed a clean, build & install of V4L-DVB.
>
> The contents of the dvb-usb folder are now as follows:
>
> dct@DCTbox:/lib/modules/3.2.0-29-generic/kernel/drivers/media/usb/dvb-usb$
> ls
> dvb-usb-a800.ko           dvb-usb-dib0700.ko        dvb-usb-dtv5100.ko
> dvb-usb-nova-t-usb2.ko     dvb-usb-vp702x.ko
> dvb-usb-af9005.ko         dvb-usb-dibusb-common.ko  dvb-usb-dw2102.ko
> dvb-usb-opera.ko           dvb-usb-vp7045.ko
> dvb-usb-af9005-remote.ko  dvb-usb-dibusb-mb.ko      dvb-usb-friio.ko
> dvb-usb-pctv452e.ko
> dvb-usb-az6027.ko         dvb-usb-dibusb-mc.ko      dvb-usb-gp8psk.ko
> dvb-usb-technisat-usb2.ko
> dvb-usb-cinergyT2.ko      dvb-usb-digitv.ko         dvb-usb.ko
> dvb-usb-ttusb2.ko
> dvb-usb-cxusb.ko          dvb-usb-dtt200u.ko        dvb-usb-m920x.ko
> dvb-usb-umt-010.ko
>
> I cannot see any reference to the dvb_usb_rtl28xxu module. Having said that
> a reference to 'dvb_usb_rtl28xxu' does appear when I build V4L-DVB.
>
> Can you please advise how I correctly add dvb_usb_rtl28xxu?
>

It should be inside drivers/media/usb/dvb-usb-v2/
modinfo dvb_usb_rtl28xxu should list it. Also it is highly possible your 
device usb id is not known by driver, you should add it, easiest is just 
replace some existing rtl2832u device id.


regards
Antti

-- 
http://palosaari.fi/
