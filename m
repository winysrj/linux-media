Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp12.wxs.nl ([195.121.247.24]:53407 "EHLO psmtp12.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439AbZKMU23 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 15:28:29 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp12.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KT200BWOE7K6G@psmtp12.wxs.nl> for linux-media@vger.kernel.org;
 Fri, 13 Nov 2009 21:28:32 +0100 (MET)
Date: Fri, 13 Nov 2009 21:28:30 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: [linux-dvb] Organizing ALL device data in linuxtv wiki
In-reply-to: <20091113181023.GA31295@www.viadmin.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	linux-media@vger.kernel.org
Message-id: <4AFDC16E.3040103@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20091112173130.GV31295@www.viadmin.org>
 <20091113160850.GY31295@www.viadmin.org> <4AFD8B9A.7000309@hoogenraad.net>
 <829197380911130845y7a18ca25k266159c3af031a3e@mail.gmail.com>
 <20091113181023.GA31295@www.viadmin.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

H. Langos wrote:
> On Fri, Nov 13, 2009 at 11:45:07AM -0500, Devin Heitmueller wrote:

>> The challenge you run into there is that every driver organizes its
>> table of products differently, and the driver source code does not
>> expose what features the device supports in any easily easily parsed
>> manner.  Also, it does not indicate what the hardware supports which
>> is not supported by the Linux driver.
>>
>> So for example, you can have a hybrid USB device that supports
>> ATSC/QAM and analog NTSC.  The driver won't really tell you these
>> things, nor will it tell you that the hardware also supports IR but
>> the Linux driver does not.
>>
>> It's one of those ideas that sounds reasonable until you look at how
>> the actual code defines devices.
> 
> Yeap. I agree whole heartedly. For some simle drivers you can read that
> information from the source. But most drivers support e.g. more than one
> tuner and the information which device has which tuner, is not part of
> the driver anymore. Rather the driver looks onto the device's i2c bus
> to find out which tuner is present. At least this is what I gathered
> from browsing through the driver code in order to get my device 
> table up to date. (see
> http://www.linuxtv.org/wiki/index.php/Talk:DVB-T_USB_Devices#Adding_supported_devices_from_kernel_sources
> ) I don't actually have a clue. So don't take my word for it.
> 
> cheers
> -henrik

I agree, now you spell it out.

I first thought that at least the names of the supported devices should 
be readable from the code.
All supported USB IDs can be found easily from

grep -i  dvb /lib/modules/`uname -r`/modules.usbmap | sed -e 
's/0x0000.*$//' -e 's/ 0x0003/ /' -e 's/^.*://'

As the code lists names for each device, I would expect there would be 
an utility like
lsusb -v -d xxxx:xxxx
to list the names from the .devices = sections , just like depmod scans 
the device IDs.

However, I have not found such a utility.
