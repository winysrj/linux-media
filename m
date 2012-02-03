Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:54104 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab2BCLEb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Feb 2012 06:04:31 -0500
Message-ID: <4F2BBF3E.1030809@ukfsn.org>
Date: Fri, 03 Feb 2012 11:04:30 +0000
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: PCTV 290e page allocation failure
References: <4F2AC7BF.4040006@ukfsn.org> <4F2ADDCB.4060200@gmail.com> <4F2AEA81.90506@ukfsn.org> <4F2B184F.4030709@gmail.com>
In-Reply-To: <4F2B184F.4030709@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gianluca Gennari wrote:

>> What kernel are you using?
>>
>> I see someone else had problems with>  3.0, I've got a 3.08 built on
>> this box, I'll try it out when I get a chance to reboot, though it took
>> a couple of days to show on my current kernel.
>>
>> Andy.
>>
>
> Hi Andy,
> I'm running 3.1.0 but I back-ported a few patches from 3.2.0 to update
> the PCTV 290e driver to the latest version.
> In the past months I run 2.6.18/2.6.31/3.0.3 before buying the PCTV
> 290e, but I never had this problem with the old dvb-usb stick.

Hi,

I tried my 3.08 but changed back as I was getting corrupted HD streams.

Maybe because the config for that kernel was no SMP and no preemption.

I did do lots of cat /proc/buddyinfo and echo m > /proc/sysrq-trigger 
and it looks like having lots of files open is my problem - but I didn't 
run long enough to provoke a fail.

It seems even if the above commands show no continuous DMA above 16k 
when you actually try and use it the kernel defrags so it works and the 
output will then show larger chunks available for a while.

When I had 2xPCI running it was mainly on 2.6.26 and I was also using 
legacy IDE - I wonder if that behaved differently with 00s of open files 
- or maybe it's just that PCIs (remaining one is cx88) just don't ask 
for big 64k DMA buffers.

