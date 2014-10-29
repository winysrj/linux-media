Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:33727 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbaJ2SeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 14:34:12 -0400
Received: by mail-la0-f41.google.com with SMTP id pn19so3093918lab.0
        for <linux-media@vger.kernel.org>; Wed, 29 Oct 2014 11:34:09 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Oct 2014 16:34:09 -0200
Message-ID: <CAB0d6EdsnrRmMxz=d2Di=NvitX3LLxzJMRM7ee1ZKsFViG0EDA@mail.gmail.com>
Subject: Issues with Empia + saa7115
From: Rafael Coutinho <rafael.coutinho@phiinnovations.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm having trouble to make an SAA7115 (Actually it's the generic
GM7113 version) video capture board to work on a beagle board running
Android (4.0.3).
For some reason I cannot capture any image, it always output a green image file.
The kernel is Linux-3.2.0

My current approach is the simplest I have found so far, to avoid any
issues with other sw layers. I'm forcing a 'dd' from the /dev/video
device.

dd if=/dev/video0 of=ImageOut.raw bs=10065748 count=1

And then I open the raw image file converting it on an image editor.

In my ubuntu PC (kernel 3.13.0) it works fine. however on the Beagle
Bone with android it fails to get an image.

I have now tried with a Linux (angstron) on beagle bone with 3.8
kernel and this time is even worse, the 'dd' command does not result
on any byte written on the output file.

The v4l2-ctl works fine on the 3 environments. I can even set values
as standard, input etc...

I have attached the dmesg of the environments here:

* Android - dmesg http://pastebin.com/AFdB9N9c

* Linux Angstron - dmesg http://pastebin.com/s3S3iCph
* Linux Angstron - lsmod http://pastebin.com/vh89TBKQ

* Desktop PC - dmesg http://pastebin.com/HXzHwnUJ

I have one restriction on the kernel of android due the HAL drivers
for BBB. So changing kernel is not a choice.

Anyone could give me some tips on where to look for other issues or debug it?

Thanks in advance

-- 
Regards,
Coutinho
www.phiinnovations.com
