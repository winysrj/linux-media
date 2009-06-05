Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36950 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZFEUJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 16:09:47 -0400
Received: by fxm9 with SMTP id 9so819596fxm.37
        for <linux-media@vger.kernel.org>; Fri, 05 Jun 2009 13:09:48 -0700 (PDT)
Message-ID: <4A297B86.6000807@gmail.com>
Date: Fri, 05 Jun 2009 22:09:42 +0200
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
> 
> The driver is using a standard method to retrieve the firmware buffer 
> from user-space, if it does not work, it is a problem of you 
> installation, namely udev.

Is it possible that this is a initrd problem?
I found out that device initialization is done before running /sbin/init 
(which includes running running /etc/rcS which includes mounting sysfs).
I also found out about the FIRMWARE_IN_KERNEL config. The Ubuntu kernel 
leaves this unset.

Is it possible that the kernel tries to initialize the device when 
running the initial ramdisk? Then it seems natural that it can't find 
the firmware because it is not included as I found out with:

file-roller /boot/initrd.img-2.6.30-020630rc8-generic

So I guess this is an Ubuntu bug about initrd/firmare configuration?

Thank you.

g
