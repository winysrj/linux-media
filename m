Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:45038 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaJ2TI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 15:08:57 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NE7001U3ZUWLN70@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Oct 2014 15:08:56 -0400 (EDT)
Date: Wed, 29 Oct 2014 17:08:53 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Rafael Coutinho <rafael.coutinho@phiinnovations.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Issues with Empia + saa7115
Message-id: <20141029170853.1ee823cb.m.chehab@samsung.com>
In-reply-to: <CAB0d6EdsnrRmMxz=d2Di=NvitX3LLxzJMRM7ee1ZKsFViG0EDA@mail.gmail.com>
References: <CAB0d6EdsnrRmMxz=d2Di=NvitX3LLxzJMRM7ee1ZKsFViG0EDA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Oct 2014 16:34:09 -0200
Rafael Coutinho <rafael.coutinho@phiinnovations.com> escreveu:

> Hi all,
> 
> I'm having trouble to make an SAA7115 (Actually it's the generic
> GM7113 version) video capture board to work on a beagle board running
> Android (4.0.3).
> For some reason I cannot capture any image, it always output a green image file.
> The kernel is Linux-3.2.0

Support for GM7113 were added only on a recent version.

So, you need to get a newer driver. So, you'll need to either upgrade
the Kernel, use either Linux backports or media-build to get a newer
driver set or do the manual work of backporting saa7115 and the bridge
driver changes for gm7113 for it to work.

Regards,
Mauro

> 
> My current approach is the simplest I have found so far, to avoid any
> issues with other sw layers. I'm forcing a 'dd' from the /dev/video
> device.
> 
> dd if=/dev/video0 of=ImageOut.raw bs=10065748 count=1
> 
> And then I open the raw image file converting it on an image editor.
> 
> In my ubuntu PC (kernel 3.13.0) it works fine. however on the Beagle
> Bone with android it fails to get an image.
> 
> I have now tried with a Linux (angstron) on beagle bone with 3.8
> kernel and this time is even worse, the 'dd' command does not result
> on any byte written on the output file.
> 
> The v4l2-ctl works fine on the 3 environments. I can even set values
> as standard, input etc...
> 
> I have attached the dmesg of the environments here:
> 
> * Android - dmesg http://pastebin.com/AFdB9N9c
> 
> * Linux Angstron - dmesg http://pastebin.com/s3S3iCph
> * Linux Angstron - lsmod http://pastebin.com/vh89TBKQ
> 
> * Desktop PC - dmesg http://pastebin.com/HXzHwnUJ
> 
> I have one restriction on the kernel of android due the HAL drivers
> for BBB. So changing kernel is not a choice.
> 
> Anyone could give me some tips on where to look for other issues or debug it?
> 
> Thanks in advance
> 
