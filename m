Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60521 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaDYSqc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Apr 2014 14:46:32 -0400
Received: by mail-ob0-f172.google.com with SMTP id wo20so4720152obc.3
        for <linux-media@vger.kernel.org>; Fri, 25 Apr 2014 11:46:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyuG0q-pCsPsSkMPFa8V+qo97ewY7ngyu4Mhmu_45RDYw@mail.gmail.com>
References: <CAOS+5GGaHQvO30fhgG6PYGc2POHFiFwHvDozZ6k6f_1MEy9_eA@mail.gmail.com>
	<CAGoCfiyuG0q-pCsPsSkMPFa8V+qo97ewY7ngyu4Mhmu_45RDYw@mail.gmail.com>
Date: Fri, 25 Apr 2014 19:46:31 +0100
Message-ID: <CAOS+5GGC8-Pbx9eoA0eNYU0sH5bEzqUKsuowog2BQ214djUmjA@mail.gmail.com>
Subject: Re: Elgato Eye TV Deluxe V2 supported?
From: Another Sillyname <anothersname@googlemail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Devin

Is the as102 tree ever likely to go mainline?

Regards

Tony

On 25 April 2014 19:40, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> On Fri, Apr 25, 2014 at 2:31 PM, Another Sillyname
> <anothersname@googlemail.com> wrote:
>> I have an Elgato Eye TV V2 USB device  USB ID 0fd9:002c which reading here....
>>
>> https://github.com/mirrors/linux-2.6/blob/master/drivers/staging/media/as102/as102_usb_drv.h
>>
>> Looks like it should be supported (it looks like Devin wrote some of
>> the code?)......it gets recognised in dmesg and indeed lsusb sees it,
>> but no firmware is loaded (I have the required as102 files in
>> /lib/firmware) and in effect it never 'initialises'.
>
> Hi Tony,
>
> Sorry, I saw your email yesterday but forgot to reply.  The issue is
> that the as102 is still in "staging", so it won't appear in mainline
> kernels by default.  You would need to install the media_build tree,
> run "make menuconfig", enable "staging drivers" and then enable the
> "as102" bridge.
>
> The messages you are seeing in dmesg and lsusb are just the kernel
> finding the hardware at a USB level - these messages will appear
> whether there is a driver or not for the actual device.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
