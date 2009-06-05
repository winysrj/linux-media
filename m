Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37219 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZFESRI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 14:17:08 -0400
Received: by fxm9 with SMTP id 9so758684fxm.37
        for <linux-media@vger.kernel.org>; Fri, 05 Jun 2009 11:17:09 -0700 (PDT)
Message-ID: <4A296122.7070701@gmail.com>
Date: Fri, 05 Jun 2009 20:17:06 +0200
From: Gonsolo <gonsolo@gmail.com>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Can't find firmware when resuming
References: <4A2844E0.1010902@gmail.com> <alpine.LRH.1.10.0906050925280.23189@pub2.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0906050925280.23189@pub2.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Is the following problem known?
>> The Hauppauge Nova-T stick hangs the resume for 60 seconds.
>> The firmware is there and I can watch TV before suspending.
>>
>> From my dmesg:
>>
>> [34258.180072] usb 1-1: reset high speed USB device using ehci_hcd and 
>> address 4
>> [34258.312799] dvb-usb: found a 'Hauppauge Nova-T Stick' in cold 
>> state, will try to load a firmware
>> [34258.312805] usb 1-1: firmware: requesting dvb-usb-dib0700-1.20.fw
>> [34318.312097] dvb-usb: did not find the firmware file. 
>> (dvb-usb-dib0700-1.20.fw) Please see linux/Documentation/dvb/ for mor
>> e details on firmware-problems. (-2)
> 
> You are resuming from suspend2disk, right?

This was suspend to ram but it happened with suspend to disk too.

> The driver is using a standard method to retrieve the firmware buffer 
> from user-space, if it does not work, it is a problem of you 
> installation, namely udev.

This is Ubuntu Jaunty with a kernel 2.6.30rc8 from 
http://kernel.ubuntu.com/~kernel-ppa/mainline/ but I am pretty confident 
that it happened with the 2.6.28, too.

Ok, I grepped for udev in /var/log and found:

May 30 15:08:24 ups firmware.sh[30098]: udev firmware loader misses 
sysfs directory

It seems that the dev in sysfs can't be found.
I will try to investigate that.

> OTOH, the dvb-usb-framework is not ready to handle a suspend2disk 
> correctly. E.g. being able to suspend2disk while watching TV will work, 
> but when resuming it will be seen as a device disconnect and the 
> application will stop to work.

As long I only have to push a button in me-tv to turn it on again that's 
ok with me.

Thank you for your answer.

g
