Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36304 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbbHZTHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 15:07:38 -0400
MIME-Version: 1.0
In-Reply-To: <1440615385.2780.42.camel@perches.com>
References: <1440615110-11575-1-git-send-email-kuleshovmail@gmail.com> <1440615385.2780.42.camel@perches.com>
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Date: Thu, 27 Aug 2015 01:07:17 +0600
Message-ID: <CANCZXo6OUsbhr_f4dyQ=56T0t-+efqjs4Ax_gcOFTM9W5-iAng@mail.gmail.com>
Subject: Re: [PATCH] media/pci/cobalt: Use %*ph to print small buffers
To: Joe Perches <joe@perches.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oh, nope, resent

2015-08-27 0:56 GMT+06:00 Joe Perches <joe@perches.com>:
> On Thu, 2015-08-27 at 00:51 +0600, Alexander Kuleshov wrote:
>> printk() supports %*ph format specifier for printing a small buffers,
>> let's use it intead of %02x %02x...
>
> Having just suffered this myself...
>
>> diff --git a/drivers/media/pci/cobalt/cobalt-cpld.c b/drivers/media/pci/cobalt/cobalt-cpld.c
> []
>> @@ -330,9 +330,7 @@ bool cobalt_cpld_set_freq(struct cobalt *cobalt, unsigned f_out)
>>
>>               if (!memcmp(read_regs, regs, sizeof(read_regs)))
>>                       break;
>> -             cobalt_dbg(1, "retry: %02x %02x %02x %02x %02x %02x\n",
>> -                     read_regs[0], read_regs[1], read_regs[2],
>> -                     read_regs[3], read_regs[4], read_regs[5]);
>> +             cobalt_dbg(1, "retry: %6ph\n");
>
> Aren't you missing something like compile testing?
>
>
